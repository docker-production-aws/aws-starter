# AWS CloudFormation Starter Playbook

## Introduction

This repository provides a starter template for getting started creating AWS infrastructure using Ansible and CloudFormation.

## Prerequisites

To run this playbook on your local machine, you must install the following prerequisites:

- Ansible 2.2 or higher
- Python PIP package manager
- The following PIP packages:
  - awscli
  - boto
  - netaddr
  - ndg-httpsclient
- jq

You must also configure your local environment with your AWS credentials and you will also need to specify the ARN of the IAM role that your playbook will use to run provisioning tasks.  Your credentials must have permissions to assume this role.

### macOS Environments

On macOS environments, `boto` must be installed as follows:

```bash
$ sudo -H /usr/bin/python -m easy_install pip
...
...
$ sudo -H /usr/bin/python -m pip install boto
...
...
```

## Getting Started

1. Fork this repository to your own new repository
2. Review [`roles/requirements.yml`](./roles/requirements.yml) and modify if required
3. Install roles by running `ansible-galaxy install -r roles/requirements.yml`
4. Define environments in the [`inventory`](./inventory) file and [`group_vars`](./group_vars) folder
5. Define a CloudFormation stack name in [`group_vars/all/vars.yml`](./group_vars/all/vars.yml) using the `cf_stack_name` variable
6. Add the ARN of the IAM role to assume in each environment by configuring the `sts_role_arn` variable in `group_vars/<environment>/vars.yml`
7. Define your CloudFormation template in [`templates/stack.yml.j2`](./templates/stack.yml.j2).  Alternatively you can reference a template included with the `aws-cloudformation` role by setting the `cf_stack_template` variable to the path of the template relative to the `aws-cloudformation` role folder (e.g. `cf_stack_name: "templates/network.yml.j2"`)
8. Define environment-specific configuration settings as required in `group_vars/<environment>/vars.yml`
9. If you have stack inputs, define them in using the `cf_stack_inputs` dictionary in [`group_vars/all/vars.yml`](./group_vars/all/vars.yml).  A common pattern is to then reference environment specific settings for each stack input.
10. Deploy your stack by running `ansible-playbook site.yml -e env=<environment>`

## Conventions

- Environment specific settings should always be prefixed with `config_`, unless you have environment specific settings for variables related to the [`aws-sts`](https://github.com/docker-production-aws/aws-sts) or [`aws-cloudformation`](https://github.com/docker-production-aws/aws-cloudformation) roles as defined below

- Variables related to configuring the [`aws-sts`](https://github.com/docker-production-aws/aws-sts) role are prefixed with `sts_`

- Variables related to configuring the [`aws-cloudformation`](https://github.com/docker-production-aws/aws-cloudformation) role are prefixed with `cf_`
