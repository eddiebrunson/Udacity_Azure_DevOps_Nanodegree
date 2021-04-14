# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

### Introduction
For this project, I was required to write a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

### Getting Started
1. Clone this repository

2. Create your infrastructure as code

3. Update this README to reflect how someone would use your code.

### Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

### Instructions

#### Deploy a Policy 

1. Write a policy definition to deny the creation of resources that do not have tags. 
2. Apply the policy definition to the subscription with the name "tagging-policy" 
3. Use `az policy assignment list` and take a screenshot of your policy 

#### Packer Template 

1. Use an Ubuntu 18.04-LTS SKU as the base image
2. Ensure the following in your provisions:

```
"inline": ["echo 'Hello, World!' > index.html",
"nohub busybox httpd -f -p 80 &" ],
"inline_shebang": "/bin/sh -x", "type": "shell"
```
3. Ensure that the resource group you specify in Packer for the image is the same specified in Terraform 

#### Terraform Template

1. Create a Resource Group 
2. Create a Virtual network and a subnet on that virtual network 
3. Create a Network Security Group. Ensure that you explicitly allow access to other VMs on the subnet and deny direct access from the internet
4. Create a Network Interface 
5. Create a Public IP.
6. Create a Load Balancer. Your load balancer will need a backend address pool and address pool association for the network interface and the load balancer 
7. Create a virtual machine availability set 
8. Create virtual machines. Make sure you use the image you deployed using Packer! 
9. Create managed disks for your virtual machines 
10. Ensure a variables file allows for customers to configure the number of virtual machines and the deployment at a minimum. 

#### Document your work

1. Create a README file documenting the steps you took when implementing this project. 


### Output
**Your words here**

