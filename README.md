# Ansible
## What is Ansible?
* Automation engine
* Automates cloud provisioning, configuration management, app deployment and more.
* Uses YAML syntax
* Requires Python on Linux hosts and PowerShell 3 on Windows hosts.
* Push Configuration Tool - Doesn't require an agent to be installed on the host. The server pushes the configuration to the nodes. (Chef and Puppet are opposite, they use the pull configuration)

### Platform Agnostic
* With the Ansible abstraction layer, can run code in any environment for any OS and it will know how to perform the operation.
* For example, the following OS's use:
   * Ubuntu - `apt` or `apt-get`
   * CentOS - `dnf` or `yum`
   * IOS - `brew`

## Ansible Architecture?
![Ansible](images/ansible.png)
* Local Machine - This is where Ansible is installed
  * Module - Collection of configuration code files i.e. playbooks
  * Inventory - Document which groups nodes under specific labels
* Nodes - The systems to be configured. Controlled by the local machine
* Local Machine connects to nodes using SSH client

## Testing Strategies
* If you use Ansible language in your playbook (not bash), then it will automatically install/configure and then test if the specified actions has been completed. If the action fails, test will notify you of this.

## How does Ansible provision one machine?
* Uses Playbooks specify the desired structure of an environment.
* Playbooks:
  * Set of instructions to configure nodes
  * Written in YAML - language used to describe data
  * List of plays
* Example:
```YAML
#start of script denoted by ---
---
  # We have 2 plays, play 1 and play 2
  -name: play 1
  # Host is the target for play
  hosts: webserver # webserver is target for play 1
  # Define tasks we want to carry out
  tasks:
    -name: install apache
    yum:
      name: apache
      state: present
    -name: start apache
    service:
      name: apache
      state: start
  -name: play 2
  hosts: databaseserver  # db server is target for play 2
  tasks:
    -name: install MySQL
    yum:
      name: MySQL
      state: present
```
* Where does the host come from? We use inventory
* Inventory file classifies nodes i.e
```
[webserver]
web1.machine
web2.machine
web3.machine

[databaseserver]
db1.machine

```
