# F5 VisitPay Azure Terraform Project
This project details the Professional Services Engagement with VisitPay for the development of a Terraform deployment.

## Project Overview
- Design Terraform Script for IaC Deployment to Azure
- Deploy 2 F5 BIG-IP Devices in an HA Pair with Auto-Sync Enabled
- License devices following a BYOL model
- Provision BIG-IPs with LTM and ASM
- Configure the BIG-IPs with base networking, and supplemental AS3 configurations for Application Configuration.

## Files Overview
The Terraform config files are broken into individual files to allow for easier readability and modification. The variables.tf file contains comments for the variables pointing to which files use the variables defined.
