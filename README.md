# Get USER and KEYS from AWS

## Goal:
This Ansible-Playbook has the goal to retrieve authorized user keys from AWS,
create users in the instances and populate their authorized_key file with
their own SSH key.

---

## Warning:
Every user will have sudo rights.

---

## Instructions:

1) Git clone this repo and cd into it.
    ```
    git clone https://github.com/abacao/ansible-aws_ssh_publickeys && cd ansible-aws_ssh_publickeys
    ```

2) Populate your .inventory with your target hosts
    ```
    vim .inventory
    ```

3) Populate the folder **`.pubkeys`** with username.publickey
    ```
    bash get_pub_keys.sh sre
    ```

4) Run the Ansilbe-Playbook and enjoy
    ```
    ansible-playbook server.yaml
    ```

---

## File structure is like this:
```
tree -a
.
├── ansible.cfg
├── get_pub_keys.sh
├── .gitignore
├── .pubkeys
│   └── andre.bacao.pub
├── README.md
├── roles
│   ├── os_hardening
│   │   └── tasks
│   │       └── main.yaml
│   └── users
│       └── tasks
│           └── main.yaml
└── server.yaml

6 directories, 8 files
```
