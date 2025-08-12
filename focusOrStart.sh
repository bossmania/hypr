#get the values
className=$1
execCommand=$2
workspaceOnStart=$3

#throw an error if jq is missing
if ! command -v jq &>/dev/null
then
  echo "jq is missing and required"
  exit 1
fi

#get the window id of the program 
address=$(hyprctl -j clients | jq -r ".[] | select(.initialClass == \"${className}\") | .address")
echo $address

#check if the program is running
if [[ $address != "" ]]
then
	#focus onto the program
  echo focus
	hyprctl dispatch focuswindow address:$address
else
  echo new
	#check if the workspace isnt a negative number
    if [[ $workspaceOnStart -ge 0 ]]
    then
      echo go to workspace $workspaceOnStart
      # run it in a speific workspace
	    hyprctl dispatch workspace $workspaceOnStart
    fi
    #run the program
	${execCommand} & 
fi