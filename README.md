users Cookbook
==============
Manage system users via a databag

Requirements
============
A databag named users must exist

databag example
===============
```json
{
  "id": "username",
  "comment": "User Name",
  "uid": 5001,
  "gid": 5001,
  "shell": "/bin/bash",
  "sudo": true,
  "ssh_keys": [],
  "groups": [],
  "action": "enable|remove",
  "email": "username@3rdparty.com",
  "phone": "000.000.0000"
}
```
