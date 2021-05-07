variable "prefix" {
    description = " The prefix which should be used for all resources in this project"
    default = "azure_devOps"
}

variable "location" {
    description = "The Azure Regin that all resources in the project should be created"
    default = "eastus"
}

variable "environment" {
    description = "The environment should be used for all resources in this project"
    default = "Development"
}

variable "admin_username" {
    default = "adminn1"
}

variable "admin_password" {
    default = "1passWord"
}

variable "PackerImageId" {
    default = "/subscriptions/681cd7c8-7ad2-48d8-9f87-9af1d8236321/resourceGroups/azure_devOps/providers/Microsoft.Compute/images/myPackerImage"
}

variable "vm_count" {
    default = "2"
  
}

variable "server_name" {
  type = list
  default = ["int", "uat"]
}

