#!/bin/bash
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
#ec2-list(){
#    EC2_RAW=$(aws ec2 describe-instances)
#    for reservation in $(jq -r '.Reservations[] | @base64' <<< "$EC2_RAW"); do
#        reservation=$(base64 --decode <<< $reservation)
#        for tag in $(jq -r  '.Instances[0].Tags[] | @base64' <<< "$reservation" 2>/dev/null ); do
#          tag=$(base64 --decode <<< $tag)
#          if [ $(jq -r '.Key' <<< "$tag") == "Name" ]; then
#              printf $(jq -r '.Value' <<< "$tag")
#              printf "\t"
#              printf $(jq -r '.Instances[0].PrivateIpAddress' <<< "$reservation")
#              printf "\n"
#          fi
#        done
#    done
#}
ec2list(){
  aws ec2 describe-instances --output table   --query 'Reservations[].Instances[].[Tags[?Key==`Name`] | [0].Value, PublicIpAddress, PrivateIpAddress]'  --filters "Name=tag-value,Values=*$1*" "Name=instance-state-name, Values=running" ${@:2}
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

