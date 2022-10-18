#################################################################################
# F5 BUILD
#################################################################################

# Create F5 BIGIP VMs
resource "azurerm_linux_virtual_machine" "f5bigip" {
  count                           = var.spec[terraform.workspace]["ltm_instance_count"]
  name                            = "${var.f5_name}-${count.index}"
  location                        = var.spec[terraform.workspace]["location"]
  resource_group_name             = azurerm_resource_group.rg.name
  size                            = var.spec[terraform.workspace]["instance_type"]
  admin_username                  = var.uname
  admin_password                  = random_password.bigippassword.result
  network_interface_ids           = [azurerm_network_interface.mgmt[count.index].id, azurerm_network_interface.external[count.index].id, azurerm_network_interface.internal[count.index].id]
  zone                            = element(local.azs, count.index % length(local.azs))
  disable_password_authentication = false

  custom_data = base64encode(data.template_file.vm_onboard[count.index].rendered)

  source_image_reference {
    publisher = var.spec[terraform.workspace]["publisher"]
    offer     = var.image_name
    sku       = var.spec[terraform.workspace]["sku"]
    version   = var.bigip_version
  }

  os_disk {
    name                 = "LTM_disk-${count.index}"
    caching              = "ReadWrite"
    storage_account_type = var.spec[terraform.workspace]["storage_type"]
    disk_size_gb         = var.spec[terraform.workspace]["disk"]
  }

  plan {
    publisher = var.spec[terraform.workspace]["publisher"]
    name      = var.spec[terraform.workspace]["plan_name"]
    product   = var.spec[terraform.workspace]["product"]
  }
}

# Setup Onboarding scripts (onboard.tpl DO)
data "template_file" "vm_onboard" {
  count    = var.spec[terraform.workspace]["ltm_instance_count"]
  template = file("${path.module}/onboard.tpl")
  vars = {
    DO_URL               = var.DO_URL
    AS3_URL              = var.AS3_URL
    TS_URL               = var.TS_URL
    FAST_URL             = var.FAST_URL
    onboard_log          = var.onboard_log
    bigip_hostname       = "${var.spec[terraform.workspace]["fqdn"]}${count.index}.${var.spec[terraform.workspace]["d_name"]}"
    extselfip            = azurerm_network_interface.external[count.index].private_ip_address
    intselfip            = azurerm_network_interface.internal[count.index].private_ip_address
    dscip                = [count.index] == 0 ? azurerm_network_interface.internal[1].private_ip_address : azurerm_network_interface.internal[0].private_ip_address
    host1                = azurerm_network_interface.internal[0].private_ip_address
    host2                = azurerm_network_interface.internal[1].private_ip_address
    name_servers         = var.dnsresolvers
    search_domain        = var.searchdomain
    bigipuser            = var.uname
    bigippass            = random_password.bigippassword.result
    license              = var.lics[count.index]
  }
}