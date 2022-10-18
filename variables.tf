#################################################################################
# VARIABLES CREATION - DO NOT UPDATE THIS FILE
#       ---------------> Please update terraform.tfvars or accept defaults
#################################################################################

# Error Logging; bigip.tf
variable "onboard_log" {
  default = ".error.log"
}

# Subnet Variables; networks.tf
variable "subnets" {
  default = [
    {
      name   = "internal"
      number = 1
    },
    {
      name   = "external"
      number = 2
    },
    {
      name   = "mgmt"
      number = 3
    },
  ]
}

# Configured for a BYOL License model. This is an array and the terraform iterates throught the strings below; bigip.tf
# "Allow Move" F5 Support Call required for license moves (destroy/apply)
variable "lics" {
  default = [
    "xxxxx-xxxxx-xxxxx-xxxxx-xxxxx",
    "xxxxx-xxxxx-xxxxx-xxxxx-xxxxx"
  ]
}


#Default Azure DNS; bigip.tf
variable "dnsresolvers" {
  default = "168.63.129.16"
}

#search domain; bigip.tf
variable "searchdomain" {
  default = "f5.com"
}

# MAIN - resource group, network
variable "spec" {
  default = {
    default = {
      location           = "westus2"
      azs                = ["1"]
      rg_name            = "test_vp_demo_westus2"
      instance_type      = "Standard_DS5_v2"
      f5version          = "latest"
      plan_name          = "f5-big-all-1slot-byol"
      offer              = "f5-big-ip-byol"
      product            = "f5-big-ip-byol"
      publisher          = "f5-networks"
      sku                = "f5-big-all-1slot-byol"
      skukey1            = "LTM"
      skukey2            = "10G"
      unitofMeasure      = "yearly"
      d_name             = "westus2.cloudapp.azure.com"
      cidr_block         = "10.0.0.0/16"
      disk               = "250"
      storage_type       = "Premium_LRS"
      fqdn_name          = "vp.westus2.cloudapp.azure.com"
      fqdn               = "vp"
      ltm_instance_count = 2
      publisher          = "f5-networks"

    }
  }
}

# security_rules variables; security_rules.tf
variable "allowed_ranges" {
  default = ["0.0.0.0/0"]
}

# F5 Variables
# F5 Azure Resource Name; bigip.tf
variable "f5_name" {
  description = "Name of F5 device"
  default     = "EXOTEST-LTM"
}

#Username; bigip.tf
variable "uname" {
  description = "name of admin user account"
  default     = "f5admin"
}

# F5 Azure image name from Azure Image List; bigip.tf
variable "image_name" {
  description = "F5 image to use: (offer from az image list)"
  default     = "f5-big-ip-byol"
}

# F5 TMOS Version; bigip.tf
variable "bigip_version" {
  description = "F5 version to use"
  default     = "latest"
}

## Please check and update the latest DO URL from https://github.com/F5Networks/f5-declarative-onboarding/releases
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable "DO_URL" {
  description = "URL to download the BIG-IP Declarative Onboarding module"
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.20.0/f5-declarative-onboarding-1.20.0-2.noarch.rpm"
}
## Please check and update the latest AS3 URL from https://github.com/F5Networks/f5-appsvcs-extension/releases/latest
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable "AS3_URL" {
  description = "URL to download the BIG-IP Application Service Extension 3 (AS3) module"
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.27.0/f5-appsvcs-3.27.0-3.noarch.rpm"
}
## Please check and update the latest TS URL from https://github.com/F5Networks/f5-telemetry-streaming/releases/latest
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable "TS_URL" {
  description = "URL to download the BIG-IP Telemetry Streaming Extension (TS) module"
  default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.19.0/f5-telemetry-1.19.0-3.noarch.rpm"
}
## Please check and update the latest FAST URL from https://github.com/F5networks/f5-appsvcs-templates/releases
# always point to a specific version in order to avoid inadvertent configuration inconsistency
variable "FAST_URL" {
  description = "F5 Application Services Templates (FAST) are an easy and effective way to deploy applications on the BIG-IP system using AS3."
  default     = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.8.0/f5-appsvcs-templates-1.8.0-1.noarch.rpm"
}
