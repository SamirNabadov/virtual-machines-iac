#!/bin/bash

#Assignment of variables
project_dir=$(pwd)
key_path=$HOME/.ssh/id_rsa.pub
host_path=$project_dir/vars/host_ip_vars.yml
os_var_path=$project_dir/vars/os_vars.yml
host_list=( $(grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' $host_path) )
passwd=$(grep -e "os_password" $os_var_path | awk -F ' ' '{print $2}')
user=$(grep -e "os_username" $os_var_path | awk -F ' ' '{print $2}')
SECONDS=0

#Deploying Virtual Machines
function deploy_vm() {
    ansible-playbook $project_dir/deploy_vm.yml
    if [ $? -eq 0 ];
    then
        echo "VMs deployment was successful!"
        echo "-------------------------------------------------------------------"
    else
        echo "Deploy failed!"
        exit 1
    fi
}

#Create SSH key if is not exists
function create_sshkeygen() {
    if [ ! -f $key_path ]
    then
        ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
    else
        echo "The SSH key is already available!"
        echo "-------------------------------------------------------------------"
    fi
}

#Copy SSH key to new created VMs
function ssh_copy() {
    for host in "${host_list[@]}"
    do
        echo "-------------------------------------------------------------------"
        sshpass -p $passwd ssh-copy-id $user@$host > /dev/null 2>&1
        if [ $? -eq 0 ];
        then
            echo "IP Address: $host -- SSH key transferred successfully!"
        else
            echo "IP Address: $host -- SSH key transfer failed!"
        fi
    done
}

function main() {
    deploy_vm
    create_sshkeygen
    ssh_copy
    echo "Time spent deploying the VMs: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
}

main
