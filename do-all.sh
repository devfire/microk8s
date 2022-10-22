#!/usr/bin/env bash
############################################################
Help() {
   # Display Help
   echo "Multipass management options"
   echo
   echo "Syntax: $0 [-g|h|v|V]"
   echo "options:"
   echo "d     Delete all nodes."
   echo "h     Print this Help."
   echo "s     Stop all nodes."
   echo "a     StArt all nodes."
   echo "l     Launch all nodes."
   echo "r     Reboot all nodes."
   echo
}

Do() {
    action="$1"
    echo Executing "$action" against all nodes
    for node in $(multipass list | grep Ubuntu | awk '{print $1}'); do
         multipass $action $node
    done
}

############################################################
############################################################
# Main program                                             #
############################################################
############################################################

# Get the options
while getopts ":dhasr" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      d)
         Do "delete"
         exit;;
      l)
         for node in $(node1 node2 node3); do
            multipass $action $node
         done
         exit;;
      s)
         Do "stop"
         exit;;
      a)
         Do "start"
         exit;;
      r)
         Do "reboot"
         exit;;
     \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done


echo "Must specify an option."
exit 0;
