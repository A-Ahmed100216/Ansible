# Task - Create a playbook for the Sparta Sample Node App

### Installations and Tasks
* Install git
```YAML
- name: install git
  apt: pkg=git state=present
```
* Install nodejs
```YAML
- name: add apt key for nodesource
  apt_key: url=https://deb.nodesource.com/gpgkey/nodesource.gpg.key

- name: install nodejs
  apt: name=nodejs
```
* Install pm2
```YAML
- name: Install pm2
  npm:
    name: pm2
    global: yes
```
* Install npm
```YAML
- name: install npm
  apt: name=npm state=present
```
* Install nginx
```YAML
- name: install nginx
  apt: name=nginx state=present
  # Notify used in conjuction with handlers
  notify:
    - Start nginx
```
* Copy app files into controller and then into the hosts
```YAML
- name: Copy app files
  copy:
    src: /home/ubuntu/app
    dest: /home/ubuntu/app
    # Force ensures that if the file has no changes, it is not rewritten
    force: no
```
* Configure nginx reverse proxy:
  * Remove the default file
  ```YAML
  - name: remove nginx default file
    file:
      path: /etc/nginx/sites-enabled/default
      state: absent
  ```
  * Create a new configuration file in /etc/nginx/sites-available
  ```YAML
  - name: create config file
    file:
      path: /etc/nginx/sites-available/custom_server.conf
      state: touch
      # Mode used to define permissions
      mode: 666
  ```
  * Write the reverse proxy commands to the new file
  ```YAML
  - name: Creating a file with content
    copy:
      dest: "/etc/nginx/sites-available/custom_server.conf"
      content: |
        server {
        listen 80;
        location / {
        proxy_pass http://127.0.0.1:3000;
        }
        }
  ```
  * Create a symbolic link to copy data to the sites-enabled directory
  * Restart nginx
  ```YAML
  - name: Create a symbolic link between sites enabled and sites available
    file:
      src: /etc/nginx/sites-available/custom_server.conf
      dest: /etc/nginx/sites-enabled/custom_server.conf
      state: link
    # Use notify to trigger a restart nginx handle   
    notify:
    -  Restart nginx
    ```
* Start the app
```YAML
- name: Start APP
  become_user: ubuntu
  command: pm2 start app.js --name app chdir=/home/ubuntu/app/app
  ignore_errors: yes
```



## Playbook
The complete playbook is as follows:
```YAML
---
- name: provision app
  hosts: host_a
  gather_facts: yes
  become: True

  tasks:
    - name: install python
      apt: pkg=python state=latest

    - name: install curl
      apt: pkg=curl state=present

    - name: add apt key for nodesource
      apt_key: url=https://deb.nodesource.com/gpgkey/nodesource.gpg.key

    - name: install nodejs
      apt: name=nodejs

    - name: install git
      apt: pkg=git state=present

    - name: install npm
      apt: name=npm state=present

    - name: install nginx
      apt: name=nginx state=present
      notify:
        - Start nginx

    - name: Install pm2
      npm:
        name: pm2
        global: yes

    - name: Copy app files
      copy:
        src: /home/ubuntu/app
        dest: /home/ubuntu/app
        force: no

    - name: remove nginx default file
      file:
        path: /etc/nginx/sites-enabled/default
        state: absent

    - name: create config file
      file:
        path: /etc/nginx/sites-available/custom_server.conf
        state: touch
        mode: 666


    - name: Creating a file with content
      copy:
        dest: "/etc/nginx/sites-available/custom_server.conf"
        content: |
          server {
          listen 80;
          location / {
          proxy_pass http://127.0.0.1:3000;
          }
          }

    - name: Create a symbolic link between sites enabled and sites available
      file:
        src: /etc/nginx/sites-available/custom_server.conf
        dest: /etc/nginx/sites-enabled/custom_server.conf
        state: link
      notify:
      -  Restart nginx

    - name: Start APP
      become_user: ubuntu
      command: pm2 start app.js --name app chdir=/home/ubuntu/app/app
      ignore_errors: yes

  handlers:
    - name: Start nginx
      service:
        name: nginx
        state: started
    - name: Restart nginx
      service:
        name: nginx
        state: restarted
```
