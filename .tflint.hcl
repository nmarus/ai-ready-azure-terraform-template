config {
  call_module_type    = "all"
  force               = false
  disabled_by_default = false
}

tflint {
  required_version = ">= 0.54"
}

#
# plugins
#

plugin "terraform" {
  enabled = true
  preset  = "recommended"
}

plugin "azurerm" {
    enabled = true
    version = "0.31.1"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

#
# rules
#

# disallow // comments in favor of #
rule "terraform_comment_syntax" {
  enabled = true
}

# disallow legacy dot index syntax
rule "terraform_deprecated_index" {
  enabled = true
}

# disallow deprecated (0.11-style) interpolation
rule "terraform_deprecated_interpolation" {
  enabled = true
}

# disallow output declarations without description
rule "terraform_documented_outputs" {
  enabled = true
}

# disallow variable declarations without description
rule "terraform_documented_variables" {
  enabled = true
}

# disallow specifying a repository as a module source without pinning to a version
rule "terraform_module_pinned_source" {
  enabled = false
}

# ensure that all modules sourced from a terraform registry specify a version
rule "terraform_module_version" {
  enabled = false
}

# enforces naming conventions for the following blocks:
# input variables
# output values
# local values
# modules
# data sources
# https://www.terraform.io/docs/extend/best-practices/naming.html
rule "terraform_naming_convention" {
  enabled = true
  format = "snake_case"
}

# require that all providers have version constraints through required_providers
rule "terraform_required_providers" {
  enabled = true
}

# disallow terraform declarations without required_version
rule "terraform_required_version" {
  enabled = true
}

# ensure that a module complies with:
# https://www.terraform.io/language/modules/develop#standard-module-structure
rule "terraform_standard_module_structure" {
  enabled = true
}

# disallow variable declarations without type
rule "terraform_typed_variables" {
  enabled = true
}

# disallow variables, data sources, and locals that are declared but never used
rule "terraform_unused_declarations" {
  enabled = true
}

# check that all required_providers are used in the module
rule "terraform_unused_required_providers" {
  enabled = true
}

# terraform.workspace should not be used with a "remote" backend with remote execution
rule "terraform_workspace_remote" {
  enabled = true
}
