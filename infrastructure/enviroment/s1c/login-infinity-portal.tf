# This Terraform configuration defines HTTP data sources to interact with an external API for authentication and publishing changes.

# Define local variables to store the authentication token obtained from the login data source.
locals {
  token = jsondecode(data.http.login.response_body)["data"]["token"]
  url = "https://cloudinfra-gw.portal.checkpoint.com"
}

# Define a data source to authenticate with the external API.
data "http" "login" {
  url            = "https://cloudinfra-gw.portal.checkpoint.com/auth/external"
  method         = "POST"
  request_body   = jsonencode({
    clientId  = var.CHECKPOINT_CI_CLIENTID
    accessKey = var.CHECKPOINT_CI_SECRET_KEY
  })
  request_headers = {
    "content-type" = "application/json"
  }
}

/*# Define a data source to publish changes to the external API.
data "http" "publishChanges" {
  # Ensure this data source depends on the login data source and another resource named "inext_kubernetes_profile.appsec-k8s-profile".
  depends_on       = [data.http.login, inext_kubernetes_profile.appsec-k8s-profile]
  url              = "https://cloudinfra-gw.portal.checkpoint.com/app/i2/graphql/V1"
  method           = "POST"
  request_headers  = {
    "authorization" = "Bearer ${local.token}"
    "content-type"  = "application/json"
  }
  request_body     = <<EOT
{ "query": "mutation {\n publishChanges {\n isValid\n errors {\n id type subType name message \n }\n warnings {\n id type subType name message\n }\n }\n }" }
EOT
}*/

# Define a data source to add infinity tenant via the external API.
data "http" "addTenant" {
  # Ensure this data source depends on the login data source and another resource named "inext_kubernetes_profile.appsec-k8s-profile".
  depends_on       = data.http.login
  url              = "${local.url}/api/v1/tenant"
  method           = "POST"
  request_headers  = {
    "authorization" = "Bearer ${local.token}"
    "content-type"  = "application/json"
  }
  request_body   = jsonencode({
    clientId  = var.CHECKPOINT_CI_CLIENTID
    accessKey = var.CHECKPOINT_CI_SECRET_KEY
  })
}

# Output the response body from the addTenant data source.
output "addTenant" {
  value = jsondecode(data.http.addTenant.body)
}
