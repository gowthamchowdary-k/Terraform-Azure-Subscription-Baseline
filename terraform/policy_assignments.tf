resource "azurerm_subscription_policy_assignment" "required_project_tag" {
  name                 = "terraform-required-project-tag"
  display_name         = "Terraform - Require Project Tag"
  subscription_id      = "/subscriptions/${var.subscription_id}"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/1e30110a-5ceb-460c-a204-c1c3969c6d62"

  parameters = jsonencode({
    tagName = {
      value = var.required_tag_name
    }
    tagValue = {
      value = var.required_tag_value
    }
  })
}