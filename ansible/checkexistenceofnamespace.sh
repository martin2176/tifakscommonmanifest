returndatadirectory=<+pipeline.executionId>
returndatafile="/tmp/${returndatadirectory}-returndata"
returndata=`cat "$returndatafile"`
rm -f "$returndatafile"

#check if playbook ran successfully or failed
failed=$( jq -r  '.failed' <<< "${returndata}" )

if $failed
 then
  echo "ansible playbook failed for reason described in debug message"
  echo ${returndata}
  exit 1
 else
  echo "ansible playbook completed succesfully"
fi

#now check if namespace exist already

namespace=$( jq -r  '.servicebuses[0].name' <<< "${returndata}" )

if [ "$namespace" = "null" ]
 then
  echo "Namespace with the given name not found in Azure.Hence continuing.."
 else
  echo "Namespace with given name already existing in Azure. Cannot continue. exiting.."
  exit 2
fi