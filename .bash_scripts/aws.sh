#!/bin/bash
aws-env(){
    _check_no_args_quiet $@
    if [ $? != 0 ]
    then
        eval "$(aws configure export-credentials --format env $@)" 
    else
        eval "$(aws configure export-credentials --profile ${1} --format env ${@:2})" 
    fi
}
_aws-env(){
    COMPREPLY=($(compgen -W "$(cat ~/.aws/credentials | awk -F'[][]' '{print $2}' | xargs)" -- "${COMP_WORDS[1]}"))
}
complete -F _aws-env aws-env

ecslog_once(){
    ecs-cli logs --task-id $1 --region us-east-1 --aws-profile hubbabd --task-def $(aws ecs describe-tasks --cluster production-ecs --tasks $1 --profile hubbabd | jq -r '.tasks[0].taskDefinitionArn' | cut -d '/' -f2)
}

ecslog(){
    watch --color ecs-cli logs --task-id $1 --region us-east-1 --aws-profile hubbabd --task-def $(aws ecs describe-tasks --cluster production-ecs --tasks $1 --profile hubbabd | jq -r '.tasks[0].taskDefinitionArn' | cut -d '/' -f2)
}

stream-kinesis(){
    PROFILE=default
    RUN=true

    for i in "$@"
    do
    case $i in
        -p=*|--profile=*)
        PROFILE="${i#*=}"
        shift # past argument=value
        ;;
        -s=*|--streamname=*)
        STREAMNAME="${i#*=}"
        shift # past argument=value
        ;;
        -h*|--help*)
        echo "HELP"
        RUN=false
        ;;
        *)
              # unknown option
        ;;
    esac
    done

    if $RUN ; then
        SHARDS=$(aws kinesis list-shards --stream-name $STREAMNAME --profile $PROFILE)
        SHARDID=$(jq -r  '.Shards[0].ShardId' <<< "$SHARDS")
        SHARD_ITERATOR_JSON=$(aws kinesis get-shard-iterator --stream-name $STREAMNAME --shard-id $SHARDID --shard-iterator-type LATEST --profile $PROFILE)
        SHARD_ITERATOR_VAL=$(jq -r  '.ShardIterator' <<< "$SHARD_ITERATOR_JSON")
        ITERATOR_VAL=$(aws kinesis get-records --shard-iterator $SHARD_ITERATOR_VAL --profile $PROFILE)
        for row in $(jq -r  '.Records[] | @base64' <<< "$ITERATOR_VAL" ); do
            SHARD_DATA_JSON=$(base64 --decode <<< $row)
            SHARD_DATA_RAW=$(jq -r  '.Data' <<< "$SHARD_DATA_JSON")
            echo $(base64 --decode <<< $SHARD_DATA_RAW) | jq -r ${1}
        done

    fi

}
alias s3_buckets="aws s3 ls"
s3_cat(){
    _check_no_args_quiet $@
    if [ $? != 0 ]
    then
        echo "Usage:"
        printf "\ts3_cat [s3://bucket/folders]\n"
        return $?
    fi
    location=$1
    filenames=$(aws s3 ls $location | awk '{print $4}')
    for filename in $filenames; do
        echo "$(aws s3 cp ${location}${filename} -)"
    done
}
s3_filter(){
    _check_no_args_quiet $@
    if [ $? != 0 ]
    then
        echo "Usage:"
        printf "\ts3_filter [bucket] [name-to-filter-by : optional]\n"
        return $?
    fi
    aws s3 ls --summarize --human-readable --recursive $1 | egrep "*$2*"
}
ssh-keys(){
    select activate in $(find ~/.ssh -type f -print0 | xargs -0 grep -l "BEGIN RSA PRIVATE KEY");
    do
        echo "ssh -i $activate"
        break
    done
}
get_current_ip(){
    dig +short myip.opendns.com @resolver1.opendns.com
}
ec2-start(){
    INSTANCE_ID=$(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --filters "Name=tag-value,Values=*$1*" --output text ${@:2})
    aws ec2 start-instances --instance-ids $INSTANCE_ID ${@:2}
}
ec2-stop(){
    INSTANCE_ID=$(aws ec2 describe-instances --query 'Reservations[].Instances[].InstanceId' --filters "Name=tag-value,Values=*$1*" --output text ${@:2})
    aws ec2 stop-instances --instance-ids $INSTANCE_ID ${@:2}
}
ec2-list(){
    if [[ $1 == "--all" || $1 == "-a" ]];
    then
        aws ec2 describe-instances --output table   --query 'Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value, PublicIpAddress, PrivateIpAddress]' ${@:2}
    else
        aws ec2 describe-instances --output table   --query 'Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value, PublicIpAddress, PrivateIpAddress]'  --filters "Name=tag-value,Values=*$1*" "Name=instance-state-name, Values=running" ${@:2}
    fi
}
ec2-list-raw(){
    _check_no_args_quiet $@
    if [ $? != 0 ]
    then
        echo "Usage:"
        printf "\tec2list-raw instance-query\n"
        return $?
    fi
    IP_ADDRESS=$(aws ec2 describe-instances --query 'Reservations[].Instances[].PublicIpAddress' --filters "Name=tag-value,Values=*$1*" "Name=instance-state-name, Values=running" --output text ${@:2})
    echo $IP_ADDRESS
}
