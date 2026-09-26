variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
}

variable "required_tag_name" {
  description = "Tag name required by the subscription guardrail"
  type        = string
  default     = "Project"
}

variable "required_tag_value" {
  description = "Required value for the subscription guardrail tag"
  type        = string
  default     = "TerraformBaseline"
}