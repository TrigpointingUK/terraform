'''bash
terraform output -json | jq -r '.server_ca.value' > server-ca.pem
terraform output -json | jq -r '.client_cert.value' > client-cert.pem
terraform output -json | jq -r '.client_key.value' > client-key.pem
chmod 600 *.pem

psql "sslmode=verify-ca sslrootcert=server-ca.pem sslcert=client-cert.pem sslkey=client-key.pem hostaddr=34.79.249.153 user=ian dbname=tme"