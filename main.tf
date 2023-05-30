# Configure the Azure provider
terraform {
  required_version = "~>1.4.0"
  required_providers {
    azurerm = "=3.58.0"
    azuread = {
      source  = "hashicorp/azuread"
      version = "=2.32.0"
    }
  }
}

data "azurerm_client_config" "current" {}

# Create Azure Subscription
resource "azurerm_subscription" "main" {
  subscription_id   = var.subscription_id
  subscription_name = var.subscription_name
  billing_scope_id  = var.billing_scope_id

  tags = var.subscription_tags

  lifecycle {
    ignore_changes = [
      subscription_name,
    ]
  }
}

# resource "azurerm_resource_group" "auto_manage" {
#   count                = lower(var.automanage) == "yes" ? 1 : 0
#   name     = "auto_manage"
#   location = "West Europe"
# }
# Register resource providers
resource "null_resource" "azurerm_providers" {
  provisioner "local-exec" {
    command = <<EOT
      sleep 60;
      az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID;
      %{for provider in var.resource_providers~}
      az provider register --namespace ${provider} --subscription ${azurerm_subscription.main.subscription_id};
      %{endfor~}
      sleep 180;
    EOT
  }
  depends_on = [azurerm_subscription.main]
  triggers = {
    version            = 1
    resource_providers = join(", ", var.resource_providers)
  }
}

# Read owner user account
data "azuread_user" "owner" {
  for_each = toset(var.owner_users)

  user_principal_name = each.key
}

# Add Owner permissions
resource "azurerm_role_assignment" "owner" {
  for_each = data.azuread_user.owner

  scope                = "/subscriptions/${azurerm_subscription.main.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = data.azuread_user.owner[each.key].id
}

data "azurerm_management_group" "main" {
  name = var.mgmt_group_name
}

resource "azurerm_management_group_subscription_association" "main" {
  management_group_id = data.azurerm_management_group.main.id
  subscription_id     = "/subscriptions/${azurerm_subscription.main.subscription_id}"
}

# data "azurerm_policy_definition" "ds-policy-automanage" {
#   display_name = "Configure virtual machines to be onboarded to Azure Automanage with Custom Configuration Profile"
# }

# resource "azurerm_resource_group_template_deployment" "automanage_update_only" {
#   count                = lower(var.automanage) == "yes" ? 1 : 0
#   name                = "automanage_update_only"
#   resource_group_name = azurerm_resource_group.auto_manage[0].name
#   deployment_mode     = "Incremental"
#   parameters_content = jsonencode({
#     "customProfileName" = { value = "update_management_only" },
#     "location"          = { value = "westeurope" }
#   })

#   template_content = <<TEMPLATE
#   {
#     "$schema": "http://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json",
#     "contentVersion": "1.0.0.0",
#     "parameters": {
#       "customProfileName": {
#         "type": "String"
#       },
#       "location": {
#         "type": "String"
#       }
#     },
#     "variables": {},
#     "resources": [
#       {
#         "type": "Microsoft.Automanage/configurationProfiles",
#         "apiVersion": "2022-05-04",
#         "name": "[parameters('customProfileName')]",
#         "location": "[parameters('location')]",
#         "properties": {
#             "configuration": {
#               "Antimalware/Enable": "false",
#               "Antimalware/EnableRealTimeProtection": "false",
#               "Antimalware/RunScheduledScan": "false",              
#               "AzureSecurityBaseline/Enable": false,
#               "AzureSecurityCenter/Enable": false,
#               "Backup/Enable": "false",
#               "BootDiagnostics/Enable": false,
#               "ChangeTrackingAndInventory/Enable": false,
#               "LogAnalytics/Enable": true,
#               "UpdateManagement/Enable": true,
#               "VMInsights/Enable": false              
#           }
#         }
#       }
#     ]
#   }
#   TEMPLATE
# }

# resource "azurerm_subscription_policy_assignment" "policy-automanage" {
#   count                = lower(var.automanage) == "yes" ? 1 : 0
#   name                 = "general-automanage"
#   policy_definition_id = data.azurerm_policy_definition.ds-policy-automanage.id
#   subscription_id      = "/subscriptions/${azurerm_subscription.main.subscription_id}"
#   location = "westeurope"
#   identity {
#         type = "SystemAssigned"
#   }
#   depends_on = [
#     azurerm_resource_group_template_deployment.automanage_update_only
#   ]

#   parameters = <<PARAMS
#     {
#       "configurationProfile" :{
#         "value": "update_management_only"
#       },
#       "effect": {
#         "value": "DeployIfNotExists"
#       },
#       "inclusionTagName": {
#         "value": "Automanage"
#       },
#       "inclusionTagValues": {
#         "value": ["True"]
#       }
#     }
# PARAMS
# }

