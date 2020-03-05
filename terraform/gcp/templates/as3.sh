function runAS3 () {
    count=0
    while [ \$count -le 4 ]
        do
            # make task
            task=\$(curl -s -u $CREDS -H "Content-Type: Application/json" -H 'Expect:' -X POST $local_host$as3Url?async=true -d @/config/as3.json | jq -r .id)
            echo "===== starting as3 task: \$task ====="
            sleep 1
            count=\$[\$count+1]
            # check task code
            taskCount=0
        while [ \$taskCount -le 3 ]
        do
            as3CodeType=\$(curl -s -u $CREDS -X GET $local_host$as3TaskUrl/\$task | jq -r type )
            if [[ "\$as3CodeType" == "object" ]]; then
                code=\$(curl -s -u $CREDS -X GET $local_host$as3TaskUrl/\$task | jq -r .results[].message)
                tenants=\$(curl -s -u $CREDS -X GET $local_host$as3TaskUrl/\$task | jq -r .results[].tenant)
                echo "object \$code"
            elif [ "\$as3CodeType" == "array" ]; then  
                echo "array \$code check task, breaking"
                break
            else
                echo "unknown type:\$as3CodeType"
            fi
            sleep 1
            if [[ -n "\$code" ]]; then
                status=\$(curl -s -u $CREDS $local_host$as3TaskUrl/\$task | jq -r .results[].message)
                case \$status in
                *Error*)
                    # error
                    echo -e "Error: \$task status: \$status tenants: \$tenants "
                    break
                    ;;
                *failed*)
                    # failed
                    echo -e "failed: \$task status: \$status tenants: \$tenants "
                    break
                    ;;
                *success*)
                    # successful!
                    echo -e "success: \$task status: \$status tenants: \$tenants "
                    break 3
                    ;;
                no*change)
                    # finished
                    echo -e "no change: \$task status: \$status tenants: \$tenants "
                    break 3
                    ;;
                in*progress)
                    # in progress
                    echo -e "Running: \$task status: \$status tenants: \$tenants count: \$taskCount "
                    sleep 60
                    taskCount=\$[\$taskCount+1]
                    ;;
                *)
                # other
                echo "status: \$status"
                debug=\$(curl -s -u $CREDS $local_host$as3TaskUrl/\$task | jq .)
                echo "debug: \$debug"
                error=\$(curl -s -u $CREDS $local_host$as3TaskUrl/\$task | jq -r '.results[].message')
                echo "Other: \$task, \$error"
                break
                ;;
                esac
            else
                echo "AS3 status code: \$code"
                debug=\$(curl -s -u $CREDS $local_host$doTaskUrl/\$task | jq .)
                echo "debug do code: \$debug"
                # count=\$[\$count+1]
            fi
        done
    done
}