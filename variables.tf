variable "location" {
  description = "Location for Azure deployment"
  type        = string
  default     = "westeurope"
}

variable "subscription_name" {
  description = "Subscription name"
  type        = string
}

variable "subscription_id" {
  description = "Subscription ID"
  type        = string
  default     = null
}

variable "billing_scope_id" {
  description = "Billing scope ID"
  type        = string
  default     = null
}

variable "subscription_tags" {
  description = "Subscription tags"
  type        = map(string)
}

variable "mgmt_group_name" {
  description = "Management Group Name"
  type        = string
  default     = null
}

variable "owner_users" {
  description = "Owner user UPNs"
  type        = list(string)
  default     = []
}

variable "resource_providers" {
  type = list(string)
  default = [
    "Microsoft.PolicyInsights",
    "Microsoft.AlertsManagement",
    "Microsoft.Automation",
    "Microsoft.ChangeAnalysis",
    "Microsoft.Compute",
    "Microsoft.ContainerService",
    "Microsoft.GuestConfiguration",
    "Microsoft.Insights",
    "Microsoft.Logic",
    "Microsoft.ManagedIdentity",
    "Microsoft.ManagedServices",
    "Microsoft.Management",
    "Microsoft.Network",
    "Microsoft.RecoveryServices",
    "Microsoft.Security",
    "Microsoft.Storage"
  ]
}

variable "automanage" {
  default = ""
}