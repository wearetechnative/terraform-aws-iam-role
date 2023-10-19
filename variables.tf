variable "role_name" {
  description = "Role name for new role. Required value."
  type        = string
}

variable "role_path" {
  description = "Path for new role. Defaults to \"/\"."
  type        = string
  default     = "/"
}

variable "customer_managed_policies" {
  description = "Optional map of customer managed policy names. Key is policyname and value is policy object in HCL."
  type        = any # activate below when optional() is ready for GA
  # type = map(object({
  #   Version = string
  #   Sid = optional(string)
  #   Statement = list(object({
  #     Sid = optional(string)
  #     Effect = string
  #     Action = list(string)
  #     Resource = list(string)
  #     Condition = optional(any)
  #   }))
  # }))
  default = {}
}

variable "aws_managed_policies" {
  description = "Optional list of AWS managed policies. We assume that these policies already exist."
  type        = list(string)
  default     = []
}

variable "trust_relationship" {
  description = <<EOT
Defines trust relationships on this role.
About prevent_account_confuseddeputy see https://docs.aws.amazon.com/IAM/latest/UserGuide/confused-deputy.html .
TODO: It would be best to remove this parameter and have a list of affected principals within our terraform-aws-module-iam-policy-helper with an override to disable if necessary.
EOT
  type = map(object({
    identifier                     = string
    identifier_type                = string # either AWS or Service
    enforce_mfa                    = bool
    enforce_userprincipal          = bool
    external_id                    = string
    prevent_account_confuseddeputy = bool
  }))
  default = {}
}
