# VM Infrastructure as Code
Based on Ansible playbooks, you can create new VMs(including all settings) in vCenter within a few minutes and delete it in seconds.
```


Add hosts address and names for VMs : /vars/host_ip_vars.yml
Add new users and packages for VMs: /vars/os_vars.yml
Change vCenter configuration based on your requirements: /vars/vm_vars.yml

Install VMs:
./scripts/deploy_vm.sh

Remove VMs:
./scripts/remove_vm.sh
```
