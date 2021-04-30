# Configure Azure Provider
provider "azurerm" {
  features {}  
}

# Create Resource Group
resource "azurerm_resource_group" "main" {
  name                   ="${var.prefix}-rg"
  location               = var.location   
}

# Create Virtual Network 
resource "azurerm_virtual_network" "main" {
  name                   = "${var.prefix}-network"
  address_space   = [ "10.0.0.0/16" ] 
  location               = azurerm_resource_group.main.location
  resource_group_name    = azurerm_resource_group.main.name
  tags = {
      environment = var.environment 
  }
}

# Create Virtual Network Subnet
resource "azurerm_subnet" "main" {
  name                  = "${var.prefix}-subnet"
  resource_group_name   = azurerm_resource_group.main.name
  virtual_network_name  = azurerm_virtual_network.main.name
  address_prefixes = [ "10.0.0.0/24" ]
}

# Create Network Security Group
resource "azurerm_network_security_group" "main" {
  name                 = "${var.prefix}-nsg"
  location             = azurerm_resource_group.main.location 
  resource_group_name  = azurerm_resource_group.main.name

  security_rule {
    access             = "Allow"
    description        = "Allow access to other Virtual Machines on the subnet"
    destination_address_prefix   = "VirtualNetwork"
    destination_address_prefixes = [ "VirtualNetwork" ]
    destination_port_range       = "*"
    destination_port_ranges      = [ "*" ]
    direction                    = "Inbound"
    name                         = "AllowVirtualNetworkInbound"
    priority                     = 101
    protocol                     = "*"
    source_address_prefix        = "VirtualNetwork"
    source_address_prefixes      = [ "VirtualNetwork" ]
    source_port_range            = "*"
    source_port_ranges           = [ "*" ]
  }

  security_rule { 
    access            = "Deny"
    description       = "Deny all inbound traffic outside of the virtual network from the Internet"
    destination_address_prefix   = "VirtualNetwork"
    destination_address_prefixes = [ "VirtualNetwork" ]
    destination_port_range       = "*"
    destination_port_ranges      = [ "*" ]
    direction                    = "Inbound"
    name                         = "AllowVirtualNetworkInbound"
    priority                     = 100
    protocol                     = "*"
    source_address_prefix        = "VirtualNetwork"
    source_address_prefixes      = [ "VirtualNetwork" ]
    source_port_range            = "*"
    source_port_ranges           = [ "*" ]
}
  tags = {
      environment = var.environment
  }

}

#Create Load Balancer
resource "azurerm_lb" "main" {
    name                 = "${var.prefix}-lb"  
    location             = azurerm_resource_group.main.location
    resource_group_name  = azurerm_resource_group.main.name

    frontend_ip_configuration {
      name              = azurerm_public_ip.main.id
    }

    tags = {
      "environment" = var.environment
    }
}

# Create Load Balancer Backend Address Pool
resource "azurerm_lb_backend_address_pool" "main" {
    loadbalancer_id      = azurerm_lb.main.id
    name                 = "${var.prefix}-BackEndAddressPool"
  
}

# Create Network Interface
resource "azurerm_network_interface" "main" {
    count                = var.vm_count
    name                 = azurerm_resource_group_name.main.name 
    location             = azurerm_resource_group_name.location 

    ip_configuration {
      name               = "Development"
      subnet_id          = azurerm_subnet.main.id
      private_ip_address = "Dynamic"
    }

    tags = {
        environment = var.environment 
    }
}

# Create Network Interface Backend Address Pool
resource "azurerm_network_interface_backend_address_pool_association" "main" {
    count                 = var.vm_count
    network_interface_id  = azurerm_network_interface.main[count.index].id
    ip_configuration_name = azurerm_lb_backend_address_pool.main.id  
}

# Create Availibility Set 
resource "azurerm_availability_set" "main" {
    name                   = "${var.prefix}-availset"
    location               = azurerm_resource_group.main.location 
    resource_group_name    = azurerm_resource_group.main.name
    platform_fault_domain_count = 2

    tags = {
        environment = var.environment 
    }
}

# Create Public IP
resource "azurerm_public_ip" "main" {
    name                   = "${var.prefix}-publicIp"
    resource_group_name    = "azurerm_resource_group.main.name"
    location               = "azurerm_resource_group.main.location"
    allocation_method      = "Static"

    tags = {
    environment = var.environment
    }  
}

# Create Virtual Machine 
resource "azurerm_linux_virtual_machine" "main" {
  count                   = var.vm_count 
  name                    = "${var.prefix}-vm-${count.index}"
  location                = azurerm_resource_group.main.name
  size                    = "Standard_D2s_vs"
  admin_username          = var.admin_username
  admin_password          = var.admin_password
  disable_password_authentication = false
  availability_set_id     = azurerm_availability_set.main.id
  source_image_id         = var.PackerImage
  network_interface_ids   = [ azurerm_network_interface.main[count.index].id ] 
  
  os_disk {
      storage_account_type = "Standard_LRS"
      caching              = "ReadWrite"
  }

  tags = {
      environment = var.environment
  }
}

# Create Managed diskfor Virtual Machines
resource "azurerm_managed_disk" "main" {
    name = "${var.prefix}-md"
    resource_group_name   = azurerm_resource_group.main.location
    location                = azurerm_resource_group.main.name
    storage_account_type  = "Standard_LRS"
    create_option         = "Empty"
    disk_size_gb          = "1" 
}