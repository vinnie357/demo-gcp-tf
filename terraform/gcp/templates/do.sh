function runDO() {
count=0
while [ \$count -le 4 ]
    do 
    # make task
    task=\$(curl -s -u $CREDS -H "Content-Type: Application/json" -H 'Expect:' -X POST $local_host$doUrl -d @/config/\$1 | jq -r .id)
    echo "====== starting DO task: \$task =========="
    sleep 1
    count=\$[\$count+1]
    # check task code
    taskCount=0
    while [ \$taskCount -le 10 ]
    do
        doCodeType=\$(curl -s -u $CREDS -X GET $local_host$doTaskUrl/\$task | jq -r type )
        if [[ "\$doCodeType" == "object" ]]; then
            code=\$(curl -s -u $CREDS -X GET $local_host$doTaskUrl/\$task | jq .result.code)
            echo "object \$code"
        elif [ "\$doCodeType" == "array" ]; then  
            echo "array \$code check task, breaking"
            break
        else
            echo "unknown type:\$doCodeType"
        fi
        sleep 1
        if [[ -n "\$code" ]]; then
            status=\$(curl -s -u $CREDS $local_host$doTaskUrl/\$task | jq -r .result.status)
            sleep 1
            echo "object \$status"
            # 200,202,422,400,404,500,422
            echo "DO: \$task response:\$code status:\$status"
            sleep 1
            #FINISHED,STARTED,RUNNING,ROLLING_BACK,FAILED,ERROR,NULL
            case \$status in 
            FINISHED)
                # finished
                echo " \$task status: \$status "
                # bigstart start dhclient
                break 2
                ;;
            STARTED)
                # started
                echo " \$filename status: \$status "
                sleep 30
                ;;
            RUNNING)
                # running
                echo "DO Status: \$status task: \$task Not done yet...count:\$taskCount"
                sleep 30
                taskCount=\$[\$taskCount+1]
                ;;
            FAILED)
                # failed
                error=\$(curl -s -u $CREDS $local_host$doTaskUrl/\$task | jq -r .result.status)
                echo "failed \$task, \$error"
                #count=\$[\$count+1]
                break
                ;;
            ERROR)
                # error
                error=\$(curl -s -u $CREDS $local_host$doTaskUrl/\$task | jq -r .result.status)
                echo "Error \$task, \$error"
                #count=\$[\$count+1]
                break
                ;;
            ROLLING_BACK)
                # Rolling back
                echo "Rolling back failed status: \$status task: \$task"
                break
                ;;
            OK)
                # complete no change
                echo "Complete no change status: \$status task: \$task"
                break 2
                ;;
            *)
                # other
                echo "other: \$status"
                debug=\$(curl -s -u $CREDS $local_host$doTaskUrl/\$task | jq .)
                echo "debug: \$debug"
                error=\$(curl -s -u $CREDS $local_host$doTaskUrl/\$task | jq -r .result.status)
                echo "Other \$task, \$error"
                # count=\$[\$count+1]
                sleep 30
                ;;
            esac
        else
            echo "DO status code: \$code"
            debug=\$(curl -s -u $CREDS $local_host$doTaskUrl/\$task | jq .)
            echo "debug do code: \$debug"
            # count=\$[\$count+1]
        fi
    done
done
}