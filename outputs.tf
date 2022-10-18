#################################################################################
# Terraform Output Values to CLI
#################################################################################

# F5 BIG-IP Public IP
output "bigip_pip" {
  value = azurerm_public_ip.mgmt_pip[*].ip_address
}

# F5 BIG-IP Password
output "bigip_password" {
  value = random_password.bigippassword[*].result
}

# F5 BIG-IP Hostname
output "fqdn" {
  value = azurerm_public_ip.mgmt_pip.*.fqdn
}