# Declare the Terraform Module for Cloud Adoption Framework
# Enterprise-scale and provide a base configuration.
module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "3.2.0"

  providers = {
    azurerm              = azurerm
    azurerm.management   = azurerm.management
    azurerm.connectivity = azurerm.connectivity
  }

  # Base module configuration settings.
  root_parent_id   = data.azurerm_client_config.current.tenant_id
  root_id          = local.root_id
  root_name        = local.root_name
  default_location = local.default_location

  # Control deployment of the core landing zone hierachy.
  deploy_core_landing_zones   = true
  deploy_corp_landing_zones   = local.deploy_corp_landing_zones
  deploy_online_landing_zones = local.deploy_online_landing_zones
  deploy_sap_landing_zones    = local.deploy_sap_landing_zones
  # Define an additional "LearnTerraform" Management Group.
  custom_landing_zones = {
    "${local.root_id}-learn-tf" = {
      display_name               = "MorpheusTerraform"
      parent_management_group_id = "${local.root_id}-landing-zones"
      subscription_ids           = []
      archetype_config = {
        archetype_id   = "default_empty"
        parameters     = {}
        access_control = {}
      }
    }
  }
  deploy_management_resources    = true
  configure_management_resources = local.configure_management_resources
  subscription_id_management     = data.azurerm_client_config.management.subscription_id
  deploy_connectivity_resources = true
  subscription_id_connectivity  = data.azurerm_client_config.connectivity.subscription_id
  # deploy_management_resources    = true
  # configure_management_resources = local.configure_management_resources
  # subscription_id_management     = "47f36dd9-76ae-4fb7-80aa-adb7a38b3131"
  # deploy_connectivity_resources = true
  # subscription_id_connectivity  = "47f36dd9-76ae-4fb7-80aa-adb7a38b3131"
}
