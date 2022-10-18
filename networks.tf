#################################################################################
# Azure Network Configurations
#################################################################################

# Create Azure Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.spec[terraform.workspace]["rg_name"]
  location = var.spec[terraform.workspace]["location"]
  tags = {
    environment = "dev"
  }
}

# Local variables to call in other blocks *(azurerm_resource_group.rg.name)
locals {
  base_cidr_block = var.spec[terraform.workspace]["cidr_block"]
  azs             = var.spec[terraform.workspace]["azs"]
}

# Create Azure vnet
resource "azurerm_virtual_network" "vnet" {
  depends_on          = [azurerm_resource_group.rg]
  name                = "${var.spec[terraform.workspace]["rg_name"]}_vnet"
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = [local.base_cidr_block]

  location = var.spec[terraform.workspace]["location"]
  dynamic "subnet" {
    for_each = [for s in var.subnets : {
      name   = s.name
      prefix = cidrsubnet(local.base_cidr_block, 8, s.number)
    }]
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.prefix
    }
  }
}

# # Create Azure route tables: internal/outbound
resource "azurerm_route_table" "internal" {
  depends_on          = [azurerm_network_interface.internal]
  name                = "route_table_internal"
  location            = var.spec[terraform.workspace]["location"]
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "internal"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = cidrhost([for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0], 4)
  }
}

resource "azurerm_route_table" "outbound" {
  depends_on          = [azurerm_network_interface.external]
  name                = "route_table_outbound"
  location            = var.spec[terraform.workspace]["location"]
  resource_group_name = azurerm_resource_group.rg.name

  route {
    name                   = "outbound"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = cidrhost([for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "external"][0], 4)
  }
}

# Associate route tables to subnets
resource "azurerm_subnet_route_table_association" "rta1" {
  depends_on     = [azurerm_route_table.internal]
  subnet_id      = [for i in azurerm_virtual_network.vnet.subnet : i.id if i.name == "internal"][0]
  route_table_id = azurerm_route_table.internal.id
}

resource "azurerm_subnet_route_table_association" "rta2" {
  depends_on     = [azurerm_route_table.outbound]
  subnet_id      = [for i in azurerm_virtual_network.vnet.subnet : i.id if i.name == "external"][0]
  route_table_id = azurerm_route_table.outbound.id
}

# PUBLIC IP (tagged IPs to come later) and DNS mapping for the PIP
resource "azurerm_public_ip" "mgmt_pip" {
  count               = var.spec[terraform.workspace]["ltm_instance_count"]
  depends_on          = [azurerm_resource_group.rg]
  name                = "mgmt-pip-${count.index}"
  location            = var.spec[terraform.workspace]["location"]
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = [element(local.azs, count.index)]
  domain_name_label   = "${var.spec[terraform.workspace]["fqdn"]}${count.index}"
}
