mkdir -p certs
# Generate a private key
openssl genpkey -algorithm RSA -out certs/openbao.key
# Generate a self-signed certificate
openssl req -new -x509 -key certs/openbao.key -out certs/openbao.crt -days 365 -subj "/CN=openbao"