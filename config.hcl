# config.hcl
storage "postgresql" {
  connection_url = "postgres://admin:adminpassword@postgres:5432/mydatabase?sslmode=disable"
}

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/vault/config/certs/openbao.crt"
  tls_key_file  = "/vault/config/certs/openbao.key"
}

ui = true