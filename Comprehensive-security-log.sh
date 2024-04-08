# This script generates a comprehensive log of all current computer data, including user permissions, hardware and network data
# and collects all the log files present in the system into one compressed file
#!/bin/bash
SYS_TIME=$(date '+%Y-%m-%d_%H%M%S')
USER_INFO="/etc/group /etc/passwd /etc/shadow"
mkdir ~/_support
{
  echo -e "\e[1;33mThis log file is from the computer:\n\e[0m $(uname -a)"
  hostnamectl
  echo -e "\n\n=== Current User Information ===\n\n"
  echo "User name: $(whoami)"                                                            #User
  echo "ID Information: $(id)"                                                           #ID
  echo "User data information:"
  for DIRECTORY in $USER_INFO
  do
	echo -e "\n*** Information from the Directory: $DIRECTORY\n"
	if [ -e $DIRECTORY ] && [ -r $DIRECTORY ]
	then
		cat $DIRECTORY  | grep ^$USER
	else
		echo "No Permissions"
	fi
  done
  echo -e "\n\n====== Current Processes ======\n\n"
  ps aux
  echo -e "\n$(pstree)"
  echo -e "\n\n====== Network Configuration ======\n\n"
  echo "NIC: $(ip address | grep -A 6 "state UP" | grep  -E "state UP|inet")"             #NIC
  echo -e "\nNetwork connections:\n$(netstat -an | head -8)"                              #Network connections
  echo -e "\nRouting table:\n$(ip route)"                                                 #IP route
  echo -e"\n\n====== System Information ======\n\n"
  echo -e "\nThe computer is running for:$(uptime)"		                                  #running time
  echo -e "\nCPU Model: $(lscpu | grep "Model name" | cut -d : -f 2 | tr -s ' ')"         #CPU
  echo -e "\nCPU Architecture: $(lscpu | grep "Architecture" | cut -d : -f 2 | tr -s \ )" #CPU Architecture
  echo -e "\nDisk space usage:\n$(df -h)"                                                 #free space
  echo -e "\nMemory:\n$(free -h)"                                                         #Memory
  if [ -e /proc/partitions ]
  then
		echo -e "\nSATA Drivers:\n$(cat /proc/partitions)"                                #SATA Drivers
  fi
  echo -e "\nBlock Device Information:\n$(lsblk)"                                         #Block
  echo -e "\nEthernet:$(lspci | grep -i "ethernet" | cut -d ' ' -f 4-)"                   #Network 
  echo -e "\nList of the updaded apllication:\n$(apt list --installed)"                   #updaded apllication
  echo -e "\n\n====== File System Information =======\n\n"
  df -h
} > ~/_support/System_log 2>/dev/null
tar -czf ~/_support/log-$SYS_TIME.tar.gz /var/log/*.log ~/_support/System_log 2>> ~/_support/System_log
rm ~/_support/System_log
echo -e "\n\n\e[1;33mYour log archive has been created successfully"!!", have a nice day and keep your network safe"!!""
