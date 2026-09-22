cat << 'EOF' > instalar-ca-docker.sh
#!/usr/bin/env bash
set -e

CERT_PATH="/usr/local/share/ca-certificates/senac-ca.crt"
DOCKER_CERT_DIR="/etc/docker/certs.d/registry-1.docker.io"

echo "==> 1. Criando certificado em $CERT_PATH..."
sudo tee "$CERT_PATH" > /dev/null << 'CERT'
-----BEGIN CERTIFICATE-----
MIICyjCCAbKgAwIBAgIELtReAzANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDEwtz
ZW5hYy5jaGVjazAeFw0yNjAyMjQyMDM5MDdaFw0zMzAyMjQyMDM5MDdaMBYxFDAS
BgNVBAMTC3NlbmFjLmNoZWNrMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAw+RYUozD3Pi1IDFEinO3QOIRJvzIdIXUlMok3+/fItp4ndTAxqVjbuQx0Wh9
duA8yEzo+cafE/pTNB54pPVxTNawsazIfYBEQSm0K8TRsk8JW9jn3OpO6CyMgJ3v
f65sRfWuw5WL6aoSw/V5Kk2Ou7+1flYwo378ABbsbf7VD9eUqctUaE09w2INGWlm
pO9yDAaRuJpkIVsDW94bLIk/9sWWBtOvtFu9wBAKUQRM9FraDvR5Jh9MMkcQ+VdU
Ag7MkSqTTUeMu3gzmzL3lqbbpKZ9Y/gK3K/TZL64xQbq6mkm4QYerq9AOld/3C2C
p5bc2z7KOV7htkrqKEAOJmlXNQIDAQABoyAwHjAPBgNVHRMBAf8EBTADAQH/MAsG
A1UdDwQEAwIBhjANBgkqhkiG9w0BAQsFAAOCAQEAC3++yCiBQ71n8inMHLz59y0L
GS+rS9dZVBmcV2vGmY9X93SMJIBHV42z7myAnPWCOTyd5BU0C4DuqA0ARBan66c+
gjT0Q/MPtOTgFRLfJE3GxNUI2ea8e1/SqrDFULPISOpjjUDs8v6WGbQ65IeTKG8s
qT2kCZMzkcHGllgA92d8V6KvK4CRY097tTjHZ/XiFKMXPUsK4iVxqHkW8dKK9XFh
eNey2fUIgxxHXuVZjqaallAPswnuRtNSDxqJz0lNRnee0qiMY0I8cJQPTfzDyegH
TmVY7J97z3VfK8eZ6us89ht42s+B9XDGVYZiVf3i+7S+slMj+w0mcFmIfSxUgg==
-----END CERTIFICATE-----
CERT

echo "==> 2. Atualizando certificados do sistema Ubuntu..."
sudo update-ca-certificates

echo "==> 3. Configurando certificado para o Docker Hub..."
sudo mkdir -p "$DOCKER_CERT_DIR"
sudo cp "$CERT_PATH" "$DOCKER_CERT_DIR/ca.crt"

echo "==> 4. Reiniciando o daemon do Docker..."
sudo systemctl restart docker

echo "==> 5. Testando conexão com Docker..."
docker run --rm hello-world

echo "==> Concluído com sucesso!"
EOF