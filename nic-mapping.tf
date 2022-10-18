#################################################################################
# Azure NIC Associations
#################################################################################

# ASSOCIATE NSGs to NICs
resource "azurerm_network_interface_security_group_association" "internal" {
  count                     = var.spec[terraform.workspace]["ltm_instance_count"]
  depends_on                = [azurerm_network_security_group.internal]
  network_interface_id      = azurerm_network_interface.internal[count.index].id
  network_security_group_id = azurerm_network_security_group.internal[count.index].id
}

resource "azurerm_network_interface_security_group_association" "mgmt" {
  count                     = var.spec[terraform.workspace]["ltm_instance_count"]
  depends_on                = [azurerm_network_security_group.mgmt]
  network_interface_id      = azurerm_network_interface.mgmt[count.index].id
  network_security_group_id = azurerm_network_security_group.mgmt[count.index].id
}

resource "azurerm_network_interface_security_group_association" "external" {
  count                     = var.spec[terraform.workspace]["ltm_instance_count"]
  depends_on                = [azurerm_network_security_group.external]
  network_interface_id      = azurerm_network_interface.external[count.index].id
  network_security_group_id = azurerm_network_security_group.external[count.index].id
}
