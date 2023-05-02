# Subscriptions module

## Parameters
### location (optional)
Location of the deployment.\
Type: string\
Default: westeurope

### subscription_name (mandatory)
Name of the subscription.\
Type: string

### subscription_id (optional)
Subscription Id. Only needed for importing existing subscription.\
Type: string\
Default: null

### billing_scope_id (optional)
Id of the billing scople. Only required for new subscriptions (without subscription_id parameter)\
Type: string\
Default: null

### subscription_tags (mandatory)
Tags to be assigned to the subscription.\
Type: map(string)

### mgmt_group_name (mandatory)
Name (id) of an existing management group. Subscription will be added to this managment group.\
Type: string

### owner_users (optional)
UPNs (Azure AD email addresses) of users that should be assigned owner permissions to the subscription\
Type: list(string)\
Default: []

### automanage (optional)
True or false value for automanage to be enabled or disabled\
Type: bool

### resource_providers (optional)
List of resource providers to be registered.\
Type: list(string)\
Default: [\
    "Microsoft.PolicyInsights",\
    "Microsoft.AlertsManagement",\
    "Microsoft.Automation",\
    "Microsoft.ChangeAnalysis",\
    "Microsoft.Compute",\
    "Microsoft.ContainerService",\
    "Microsoft.GuestConfiguration",\
    "Microsoft.Insights",\
    "Microsoft.Logic",\
    "Microsoft.ManagedIdentity",\
    "Microsoft.ManagedServices",\
    "Microsoft.Management",\
    "Microsoft.Network",\
    "Microsoft.RecoveryServices",\
    "Microsoft.Security",\
    "Microsoft.Storage"\
  ]

## Outputs
### subscription_id
Subscription Id.\
Type: string
