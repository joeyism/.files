#!/bin/bash
_check_no_args(){
#     somefunction(){
#        _check_no_args $@
#        if [ $? != 0 ]
#        then
#            echo "Some help doc to show how to use somefunction"
#            return $?
#        fi
#        some_code_to_run_here
#     }

    if [ $# -eq 0 ]
        then
            echo "No arguments supplied"
            return 1
        else
            return 0
    fi
}
_check_no_args_quiet(){
    if [ $# -eq 0 ]
        then
            return 1
        else
            return 0
    fi
}
runcho(){
    echo $@
    $@
}
