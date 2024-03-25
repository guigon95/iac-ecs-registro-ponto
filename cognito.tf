resource "aws_cognito_user_pool" "pool" {
 name = "registro_ponto_user_pool"
}

resource "aws_cognito_user_pool_client" "client" {
 name = "registro_ponto_external_api"
 user_pool_id = aws_cognito_user_pool.pool.id
 explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
 ]
}