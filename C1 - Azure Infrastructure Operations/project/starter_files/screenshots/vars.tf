variable "prefix" {
    description = " The prefix which should be used for all resources in this project"
    default = "Udacity101"
}

variable "location" {
    description = "The Azure Regin that all resources in the project should be created"
    default = "US East"
}

variable "environment" {
    description = "The environment should be used for all resources in this project"
    default = "Development"
}

variable "admin_username" {
    default = "adminn1"
}

variable "admin_password" {
    default = "1password"
}

variable "PackerImage" {
    default = ""
}

variable "vm_count" {
    default = "2"
  
}