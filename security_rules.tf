#################################################################################
# Azure Security Configurations
#################################################################################

# Azure Network Security Groups (NSGs): internal/mgmt/external
# ConfigSync Requires: 443, 4353, 1026 (UDP), and 22 (recommended).
# BIG-IP AWAF requires the following additional Policy Sync TCP ports: 6123-6128.
# internal NSG
resource "azurerm_network_security_group" "internal" {
  count               = var.spec[terraform.workspace]["ltm_instance_count"]
  name                = "internal-nsg-${count.index}"
  depends_on          = [azurerm_route_table.internal]
  location            = var.spec[terraform.workspace]["location"]
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowHTTPS"
    description                = "allows port 443 inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow4353"
    description                = "allows port 4353 inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "4353"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow1026"
    description                = "allows port 1026 inbound"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "udp"
    source_port_range          = "*"
    destination_port_range     = "1026"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow22"
    description                = "allows port 22 inbound"
    priority                   = 102
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "udp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowASMSync"
    description                = "allows port 6123-6128 inbound"
    priority                   = 103
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "6123-6128"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowSMTP"
    description                = "allows port 25 inbound"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "25"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_1901_in"
    description                = "allows port 1901 inbound"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "1901"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_1701_in"
    description                = "allows port 1701 inbound"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "1701"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_1101_in"
    description                = "allows port 1101 inbound"
    priority                   = 1400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "1101"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_1102_in"
    description                = "allows port 1102 inbound"
    priority                   = 1500
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "1701"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_1501_in"
    description                = "allows port 1501 inbound"
    priority                   = 1600
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "1501"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_1022_in"
    description                = "allows port 1022 inbound"
    priority                   = 1700
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "1022"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_1023_in"
    description                = "allows port 1023 inbound"
    priority                   = 1800
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "1023"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow_ICMP"
    description                = "allows ICMP inbound"
    priority                   = 1900
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "ICMP"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
  }

  security_rule {
    name                       = "Deny_inbound_all"
    description                = "Deny all"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
    destination_address_prefix = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "internal"][0]
  }
}

# mgmt NSG
resource "azurerm_network_security_group" "mgmt" {
  count               = var.spec[terraform.workspace]["ltm_instance_count"]
  name                = "mgmt-nsg-${count.index}"
  depends_on          = [azurerm_route_table.outbound]
  location            = var.spec[terraform.workspace]["location"]
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowHTTPS_mgmt"
    description                = "allows port 443 inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = var.allowed_ranges
    destination_address_prefix = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "mgmt"][0]
  }

  security_rule {
    name                       = "AllowSSH_mgmt"
    description                = "allows port 22 inbound"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.allowed_ranges
    destination_address_prefix = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "mgmt"][0]
  }

  security_rule {
    name                       = "AllowICMP_mgmt"
    description                = "allows port 22 inbound"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "ICMP"
    source_port_range          = "*"
    destination_port_range     = "1"
    source_address_prefixes    = var.allowed_ranges
    destination_address_prefix = [for i in azurerm_virtual_network.vnet.subnet : i.address_prefix if i.name == "mgmt"][0]
  }

  security_rule {
    name                       = "AllowVnetIn_mgmt"
    description                = "allows vnet inbound"
    priority                   = 1300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowLBIn_mgmt"
    description                = "allows load balancer inbound"
    priority                   = 1400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyInbound_mgmt"
    description                = "Default deny all inbound"
    priority                   = 1500
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowVnetOut_mgmt"
    description                = "Allow vnet outbound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowInternetOut_mgmt"
    description                = "Allow Internet outbound"
    priority                   = 1100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.4"
  }
}

# external NSG
resource "azurerm_network_security_group" "external" {
  depends_on          = [azurerm_route_table.outbound]
  count               = var.spec[terraform.workspace]["ltm_instance_count"]
  name                = "external-nsg-${count.index}"
  location            = var.spec[terraform.workspace]["location"]
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowVnetInbound_external"
    description                = "allows vnet inbound"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowLBIn_external"
    description                = "allows load balaner inbound"
    priority                   = 1100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "DenyInbound_external"
    description                = "Default deny all inbound"
    priority                   = 1200
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SMTPOutbound_external"
    description                = "SMTP outbound"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "25"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/25"
    destination_address_prefix = "10.0.2.4"
  }

  security_rule {
    name                       = "HTTPSOutbound_external"
    description                = "443 outbound"
    priority                   = 1100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "TCP"
    source_port_range          = "443"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/25"
    destination_address_prefix = "10.0.2.4"
  }

  security_rule {
    name                       = "AllowVnetOut_external"
    description                = "Allow vnet outbound"
    priority                   = 1200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  security_rule {
    name                       = "AllowInternetOut_external"
    description                = "Allow Internet outbound"
    priority                   = 1300
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.2.4"
  }

  security_rule {
    name                       = "DenyOutbound_external"
    description                = "Default deny all outbound"
    priority                   = 1400
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
