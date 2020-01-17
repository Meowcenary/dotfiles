## Configuration

By default host key checking is enabled, which is why there must be a key under authorized keys to be included.

### Contains the public ssh keys allowed to access a server
~/.ssh/authorized_keys

### Default inventory, use -i on command line use different file
/etc/ansible/hosts

### Configuration file
/etc/ansible/ansible.cfg

### Post install permission issue
after installing ansible by default ~/.ansible/ belongs to root. run the following to prevent permission errors
```chown -R ~/.ansible/```

## Basic Commands

### Basic ping to all machines listed in inventory
ansible all -i hosts -m ping

### Similar idea, but create a file too
ansible all -i hosts -a "/bin/echo hello >> ~/ansible_test"

### Send a message to everyone on the server
ansible all -i hosts -a "/bin/wall hello"

### Replacing all will only use specified host
ansible qa-hec -i hosts -a "/bin/wall hello"

## Etc

group_vars/all contains variables available to every other ansible file

tasks for a play execute in order listed one at a time

ansible.cfg , set nocows = 1 to end that nonsense
