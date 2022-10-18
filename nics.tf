#################################################################################
# Azure NIC Configurations
#################################################################################

# NICS: mgmt/external/internal
resource "azurerm_network_interface" "mgmt" {
  count               = var.spec[terraform.workspace]["ltm_instance_count"]
  depends_on          = [azurerm_virtual_network.vnet]
  name                = "mgmt-nic-${count.index}"
  location            = var.spec[terraform.workspace]["location"]
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = [for i in azurerm_virtual_network.vnet.subnet : i.id if i.name == "mgmt"][0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.mgmt_pip[count.index].id
  }
}

resource "azurerm_network_interface" "external" {
  depends_on          = [azurerm_virtual_network.vnet]
  count               = var.spec[terraform.workspace]["ltm_instance_count"]
  name                = "external-nic-${count.index}"
  location            = var.spec[terraform.workspace]["location"]
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = [for i in azurerm_virtual_network.vnet.subnet : i.id if i.name == "external"][0]
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "internal" {
  depends_on          = [azurerm_virtual_network.vnet]
  count               = var.spec[terraform.workspace]["ltm_instance_count"]
  name                = "internal-nic-${count.index}"
  location            = var.spec[terraform.workspace]["location"]
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                          = "primary"
    subnet_id                     = [for i in azurerm_virtual_network.vnet.subnet : i.id if i.name == "internal"][0]
    private_ip_address_allocation = "Dynamic"
  }
}


