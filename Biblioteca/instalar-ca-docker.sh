#!/usr/bin/env bash
set -Eeuo pipefail
# ============================================================
# Docker Engine + CA corporativa (Ubuntu)
#
# Objetivos:
#   - Instalar Docker Engine pelo repositório oficial.
#   - Detectar problemas de certificado corporativo.
#   - Obter a CA por:
#       1. URL institucional;
#       2. arquivo local;
#       3. descoberta no handshake TLS.
#   - NUNCA confiar em uma CA apenas pelo nome ou posição.
#   - Validar o SHA-256 antes de instalar qualquer CA.
#
# Uso:
#   bash instalar-docker.sh
#
#   bash instalar-docker.sh \
#       --ca-file ~/Downloads/senac-ca.crt
#
#   bash instalar-docker.sh \
#       --ca-url https://servidor-interno/ca/senac-ca.crt
#
# ============================================================

# ------------------------------------------------------------
# CONFIGURAÇÃO DA INSTITUIÇÃO
# ------------------------------------------------------------

# SHA-256 da CA atualmente utilizada.
#
# Corresponde ao certificado:
#   CN = senac.check
#
EXPECTED_CA_SHA256="F38DCECB5F1E04F33676699830A9A1E0659245DC3BE31540B69E141EA481EEFF"

# Nome com o qual a CA será instalada no Ubuntu.
CA_NAME="senac-check-ca.crt"

# Caminhos
SYSTEM_CA="/usr/local/share/ca-certificates/${CA_NAME}"
REGISTRY_HOST="registry-1.docker.io"
DOCKER_CA_DIR="/etc/docker/certs.d/${REGISTRY_HOST}"
DOCKER_CA="${DOCKER_CA_DIR}/ca.crt"


# ------------------------------------------------------------
# RECOMENDADO
# ------------------------------------------------------------
#
# Se o TI disponibilizar a CA em algum servidor institucional,
# coloque aqui.
#
# Exemplo:
#
# DEFAULT_CA_URL="https://infra.senac.local/certs/senac-ca.crt"
#
# Pode ficar vazio.
#
# Também pode ser informado em tempo de execução:
#
# SENAC_CA_URL="https://..." bash instalar-docker.sh
#
DEFAULT_CA_URL="${SENAC_CA_URL:-}"


# ------------------------------------------------------------
# ARGUMENTOS
# ------------------------------------------------------------

CA_FILE=""
CA_URL=""

ADD_USER="ask"


# ------------------------------------------------------------
# TEMPORÁRIOS
# ------------------------------------------------------------

TMP="$(mktemp -d)"

trap 'rm -rf "$TMP"' EXIT


# ------------------------------------------------------------
# LOG
# ------------------------------------------------------------

log() {
    printf '[INFO] %s\n' "$*"
}

ok() {
    printf '[ OK ] %s\n' "$*"
}

warn() {
    printf '[AVISO] %s\n' "$*" >&2
}

die() {
    printf '[ERRO] %s\n' "$*" >&2
    exit 1
}


usage() {

cat <<'EOF'

Instalador Docker + CA corporativa

Uso:

    bash instalar-docker.sh [opções]


Opções:

    --ca-file ARQUIVO

        Utiliza um certificado .crt local.

        Exemplo:

        bash instalar-docker.sh \
            --ca-file ~/Downloads/senac-ca.crt


    --ca-url URL

        Obtém o certificado de uma URL.

        Exemplo:

        bash instalar-docker.sh \
            --ca-url https://servidor/ca/senac-ca.crt


    --add-user

        Adiciona automaticamente o usuário atual ao grupo docker.


    --no-add-user

        Não adiciona o usuário ao grupo docker.


    -h
    --help

        Exibe esta ajuda.


Também é possível definir:

    SENAC_CA_URL=https://servidor/ca/senac-ca.crt

EOF
}


while [[ $# -gt 0 ]]; do

    case "$1" in

        --ca-file)

            [[ $# -ge 2 ]] \
                || die "--ca-file exige um caminho"

            CA_FILE="$2"

            shift 2
            ;;


        --ca-url)

            [[ $# -ge 2 ]] \
                || die "--ca-url exige uma URL"

            CA_URL="$2"

            shift 2
            ;;


        --add-user)

            ADD_USER="yes"

            shift
            ;;


        --no-add-user)

            ADD_USER="no"

            shift
            ;;


        -h|--help)

            usage

            exit 0
            ;;


        *)

            die "Opção desconhecida: $1"
            ;;

    esac

done


# ============================================================
# SUDO
# ============================================================

if [[ $EUID -eq 0 ]]; then

    SUDO=()

else

    command -v sudo >/dev/null 2>&1 \
        || die "sudo não encontrado."

    log "Solicitando privilégios administrativos..."

    sudo -v

    SUDO=(sudo)

fi


# ============================================================
# SISTEMA OPERACIONAL
# ============================================================

[[ -r /etc/os-release ]] \
    || die "Não foi possível identificar o sistema operacional."


# shellcheck disable=SC1091
. /etc/os-release


[[ "${ID:-}" == "ubuntu" ]] \
    || die \
        "Este script foi desenvolvido para Ubuntu.
Sistema detectado: ${PRETTY_NAME:-desconhecido}"


command -v systemctl >/dev/null 2>&1 \
    || die "systemd/systemctl não encontrado."


command -v dpkg >/dev/null 2>&1 \
    || die "dpkg não encontrado."


log "Sistema detectado: ${PRETTY_NAME:-Ubuntu}"

log "Arquitetura: $(dpkg --print-architecture)"


# ============================================================
# OPENSSL
# ============================================================

if ! command -v openssl >/dev/null 2>&1; then

    warn "OpenSSL não está instalado."

    log "Tentando instalar..."

    "${SUDO[@]}" apt-get update \
        || die \
            "apt update falhou antes da instalação do OpenSSL.

Se a própria rede Ubuntu estiver apresentando erro de certificado,
será necessário obter a CA corporativa manualmente."

    "${SUDO[@]}" apt-get install -y \
        openssl \
        ca-certificates \
        || die "Não foi possível instalar OpenSSL."

fi


# ============================================================
# CERTIFICADOS
# ============================================================

normalize_fp() {

    tr -d ':\r\n[:space:]' \
        | tr '[:lower:]' '[:upper:]'

}


fingerprint() {

    openssl x509 \
        -in "$1" \
        -noout \
        -fingerprint \
        -sha256 \
        2>/dev/null \
        | sed 's/^[^=]*=//' \
        | normalize_fp

}


valid_expected_ca() {

    local file="$1"

    [[ -r "$file" ]] \
        || return 1


    # Certificado X.509 válido?
    openssl x509 \
        -in "$file" \
        -noout \
        >/dev/null 2>&1 \
        || return 1


    # Fingerprint exato?
    local fp

    fp="$(fingerprint "$file" || true)"


    [[ "$fp" == "$EXPECTED_CA_SHA256" ]] \
        || return 1


    # Ainda está dentro da validade?
    openssl x509 \
        -in "$file" \
        -checkend 0 \
        -noout \
        >/dev/null 2>&1 \
        || return 1


    # É realmente CA?
    openssl x509 \
        -in "$file" \
        -noout \
        -text \
        2>/dev/null \
        | grep -q 'CA:TRUE' \
        || return 1


    # A CA esperada é autoassinada.
    openssl verify \
        -CAfile "$file" \
        "$file" \
        >/dev/null 2>&1 \
        || return 1


    return 0

}


show_ca() {

    openssl x509 \
        -in "$1" \
        -noout \
        -subject \
        -issuer \
        -dates \
        -fingerprint \
        -sha256 \
        2>/dev/null \
        | sed 's/^/    /'

}


# ============================================================
# DOWNLOAD DA CA
# ============================================================

download_ca() {

    local url="$1"

    local output="$2"


    log "Tentando obter a CA de:"

    echo "    $url"


    # --------------------------------------------------------
    # CURL
    # --------------------------------------------------------

    if command -v curl >/dev/null 2>&1; then


        # Primeiro tenta TLS normal.

        if curl \
            -fsSL \
            --connect-timeout 10 \
            --max-time 30 \
            "$url" \
            -o "$output"; then

            return 0

        fi


        # ----------------------------------------------------
        # Bootstrap TLS
        # ----------------------------------------------------
        #
        # Aqui usamos -k APENAS para obter o arquivo da CA.
        #
        # O certificado ainda NÃO é confiável.
        #
        # Ele somente será instalado se o SHA-256 corresponder
        # exatamente ao fingerprint fixado no script.
        #
        # Portanto um MITM não consegue fornecer outra CA
        # arbitrária e fazê-la ser instalada.
        #

        warn \
            "TLS normal falhou ao obter a CA."

        warn \
            "Tentando baixar somente o arquivo para validar o SHA-256..."


        curl \
            -k \
            -fsSL \
            --connect-timeout 10 \
            --max-time 30 \
            "$url" \
            -o "$output"

        return $?

    fi


    # --------------------------------------------------------
    # WGET
    # --------------------------------------------------------

    if command -v wget >/dev/null 2>&1; then


        if wget \
            -q \
            --timeout=30 \
            -O "$output" \
            "$url"; then

            return 0

        fi


        warn \
            "TLS normal falhou ao obter a CA."


        wget \
            -q \
            --no-check-certificate \
            --timeout=30 \
            -O "$output" \
            "$url"

        return $?

    fi


    return 1

}


# ============================================================
# DESCOBERTA SEGURA DA CA PELO HANDSHAKE
# ============================================================

discover_ca() {

    local output="$1"


    # Detecta proxy configurado no terminal.

    local proxy="${HTTPS_PROXY:-${https_proxy:-${HTTP_PROXY:-${http_proxy:-}}}}"


    local -a proxy_args=()


    if [[ -n "$proxy" ]]; then


        local p="$proxy"


        p="${p#http://}"

        p="${p#https://}"

        p="${p%%/*}"


        # OpenSSL exige tratamento adicional para autenticação
        # de proxy. Não vamos tentar automatizar credenciais.

        if [[ "$p" == *"@"* ]]; then

            warn \
                "Proxy autenticado detectado."

            warn \
                "A descoberta automática da CA será ignorada."

            warn \
                "Use --ca-file ou --ca-url."

            return 1

        fi


        proxy_args=(
            -proxy "$p"
        )


        log \
            "Proxy detectado para diagnóstico TLS: $p"

    fi


    # --------------------------------------------------------
    # Vários endpoints relacionados ao Docker
    # --------------------------------------------------------

    local hosts=(

        "download.docker.com"

        "registry-1.docker.io"

        "auth.docker.io"

    )


    local host
    local raw
    local dir
    local cert


    for host in "${hosts[@]}"; do


        log \
            "Inspecionando handshake TLS de ${host}..."


        raw="${TMP}/${host}.txt"

        dir="${TMP}/${host}.d"


        mkdir -p "$dir"


        timeout 15 \
            openssl s_client \
            -servername "$host" \
            -showcerts \
            "${proxy_args[@]}" \
            -connect "${host}:443" \
            </dev/null \
            >"$raw" \
            2>/dev/null \
            || true


        # ----------------------------------------------------
        # Extrai TODOS os certificados.
        #
        # Não assumimos que:
        #
        # último certificado = CA raiz
        #
        # ----------------------------------------------------

        awk \
            -v directory="$dir" '

            /-----BEGIN CERTIFICATE-----/ {

                number++

                file=sprintf(
                    "%s/cert-%03d.pem",
                    directory,
                    number
                )

                inside=1
            }


            inside {

                print > file

            }


            /-----END CERTIFICATE-----/ {

                close(file)

                inside=0

            }

        ' "$raw"


        shopt -s nullglob


        for cert in "$dir"/*.pem; do


            if valid_expected_ca "$cert"; then


                cp "$cert" "$output"


                shopt -u nullglob


                ok \
                    "CA corporativa correta encontrada no handshake de ${host}."


                return 0

            fi

        done


        shopt -u nullglob

    done


    return 1

}


# ============================================================
# INSTALAÇÃO DA CA
# ============================================================

install_ca() {

    local file="$1"


    valid_expected_ca "$file" \
        || die \
            "O certificado candidato NÃO corresponde à CA esperada.

Nenhuma alteração foi realizada."


    log "CA validada criptograficamente:"


    show_ca "$file"


    # --------------------------------------------------------
    # Ubuntu
    # --------------------------------------------------------

    log \
        "Instalando CA no trust store do Ubuntu..."


    "${SUDO[@]}" install \
        -m 0644 \
        "$file" \
        "$SYSTEM_CA"


    "${SUDO[@]}" update-ca-certificates


    # --------------------------------------------------------
    # Docker Hub
    # --------------------------------------------------------

    log \
        "Configurando CA explicitamente para ${REGISTRY_HOST}..."


    "${SUDO[@]}" install \
        -d \
        -m 0755 \
        "$DOCKER_CA_DIR"


    "${SUDO[@]}" install \
        -m 0644 \
        "$file" \
        "$DOCKER_CA"


    # Docker já existe?
    if "${SUDO[@]}" systemctl \
        is-active \
        --quiet \
        docker \
        2>/dev/null; then


        "${SUDO[@]}" systemctl \
            restart docker

    fi


    ok "CA instalada."

}


# ============================================================
# TESTE HTTPS DO REPOSITÓRIO DOCKER
# ============================================================

https_docker_ok() {

    command -v curl >/dev/null 2>&1 \
        || return 1


    curl \
        -fsS \
        --connect-timeout 10 \
        --max-time 20 \
        -o /dev/null \
        https://download.docker.com/linux/ubuntu/gpg

}


# ============================================================
# TENTATIVA DE OBTER A CA
# ============================================================

CANDIDATE="${TMP}/senac-ca.crt"

CA_READY=0


# ------------------------------------------------------------
# 1. Arquivo informado explicitamente
# ------------------------------------------------------------

if [[ -n "$CA_FILE" ]]; then


    log \
        "Usando CA fornecida por arquivo: $CA_FILE"


    cp "$CA_FILE" "$CANDIDATE"


    valid_expected_ca "$CANDIDATE" \
        || die \
            "O arquivo informado não corresponde à CA esperada."


    install_ca "$CANDIDATE"


    CA_READY=1


# ------------------------------------------------------------
# 2. URL
# ------------------------------------------------------------

elif [[ -n "$CA_URL" || -n "$DEFAULT_CA_URL" ]]; then


    URL="${CA_URL:-$DEFAULT_CA_URL}"


    download_ca \
        "$URL" \
        "$CANDIDATE" \
        || die \
            "Não foi possível obter a CA pela URL."


    valid_expected_ca "$CANDIDATE" \
        || die \
            "A CA baixada NÃO corresponde ao SHA-256 esperado.

Ela NÃO foi instalada."


    install_ca "$CANDIDATE"


    CA_READY=1


# ------------------------------------------------------------
# 3. Já instalada
# ------------------------------------------------------------

elif [[ -f "$SYSTEM_CA" ]] \
    && valid_expected_ca "$SYSTEM_CA"; then


    ok \
        "CA corporativa já instalada."


    CA_READY=1


    "${SUDO[@]}" install \
        -d \
        -m 0755 \
        "$DOCKER_CA_DIR"


    "${SUDO[@]}" install \
        -m 0644 \
        "$SYSTEM_CA" \
        "$DOCKER_CA"


# ------------------------------------------------------------
# 4. Descoberta pela rede
# ------------------------------------------------------------

elif discover_ca "$CANDIDATE"; then


    install_ca "$CANDIDATE"


    CA_READY=1


else


    log \
        "A CA corporativa esperada não apareceu no handshake TLS."


    log \
        "Isso NÃO significa necessariamente que ela não esteja sendo usada."


    log \
        "CAs raiz não precisam ser enviadas durante o handshake TLS."

fi


# ============================================================
# PREPARAÇÃO DO UBUNTU
# ============================================================

log \
    "Atualizando índices do Ubuntu..."


if ! "${SUDO[@]}" apt-get update; then


    if [[ "$CA_READY" -eq 0 ]]; then

        die \
            "apt update falhou.

Possível problema de CA/proxy.

Obtenha a CA oficial e execute:

    bash instalar-docker.sh \
        --ca-file /caminho/senac-ca.crt

ou:

    bash instalar-docker.sh \
        --ca-url URL_DA_CA"

    fi


    die \
        "apt update falhou.

Verifique rede, DNS ou proxy."

fi


log \
    "Instalando dependências básicas..."


"${SUDO[@]}" apt-get install \
    -y \
    ca-certificates \
    curl \
    openssl


# ============================================================
# TESTA HTTPS DO DOCKER
# ============================================================

if ! https_docker_ok; then


    warn \
        "Falha TLS ao acessar o repositório oficial do Docker."


    # Pode ser que antes não houvesse curl ou que o endpoint
    # diferente apresente a CA.

    if [[ "$CA_READY" -eq 0 ]] \
        && discover_ca "$CANDIDATE"; then


        install_ca "$CANDIDATE"


        CA_READY=1

    fi


    if ! https_docker_ok; then


        cat >&2 <<EOF


============================================================
 NÃO É SEGURO CONTINUAR
============================================================

O sistema não consegue validar:

    https://download.docker.com


Não vamos utilizar curl -k para baixar Docker,
nem desabilitar verificação TLS do APT.


Possíveis causas:

    - CA corporativa não instalada
    - CA raiz não enviada no handshake
    - proxy explícito
    - proxy autenticado
    - bloqueio de rede
    - problema de DNS


Forneça a CA oficial:

    bash instalar-docker.sh \
        --ca-file /caminho/senac-ca.crt


ou:

    bash instalar-docker.sh \
        --ca-url URL_DA_CA


SHA-256 esperado:

    ${EXPECTED_CA_SHA256}


============================================================

EOF


        exit 1

    fi

fi


ok \
    "TLS para o repositório oficial do Docker validado."


# ============================================================
# VERIFICA SE DOCKER JÁ EXISTE
# ============================================================

if command -v docker >/dev/null 2>&1 \
    && "${SUDO[@]}" docker info >/dev/null 2>&1; then


    ok \
        "Docker já está instalado e funcionando."


else


    # ========================================================
    # REMOVE PACOTES CONFLITANTES
    # ========================================================

    log \
        "Verificando pacotes conflitantes..."


    CONFLICTS=(

        docker.io

        docker-compose

        docker-compose-v2

        docker-doc

        podman-docker

        containerd

        runc

    )


    INSTALLED=()


    for package in "${CONFLICTS[@]}"; do


        if dpkg-query \
            -W \
            -f='${Status}' \
            "$package" \
            2>/dev/null \
            | grep -q 'ok installed'; then


            INSTALLED+=("$package")

        fi

    done


    if ((${#INSTALLED[@]})); then


        warn \
            "Removendo pacotes conflitantes: ${INSTALLED[*]}"


        "${SUDO[@]}" apt-get remove \
            -y \
            "${INSTALLED[@]}"

    fi


    # ========================================================
    # REPOSITÓRIO OFICIAL DOCKER
    # ========================================================

    log \
        "Configurando repositório oficial do Docker..."


    "${SUDO[@]}" install \
        -m 0755 \
        -d \
        /etc/apt/keyrings


    "${SUDO[@]}" curl \
        -fsSL \
        https://download.docker.com/linux/ubuntu/gpg \
        -o /etc/apt/keyrings/docker.asc


    "${SUDO[@]}" chmod \
        a+r \
        /etc/apt/keyrings/docker.asc


    CODENAME="${UBUNTU_CODENAME:-${VERSION_CODENAME:-}}"


    [[ -n "$CODENAME" ]] \
        || die \
            "Não foi possível determinar o codename do Ubuntu."


    ARCH="$(dpkg --print-architecture)"


    cat <<EOF \
        | "${SUDO[@]}" tee \
        /etc/apt/sources.list.d/docker.sources \
        >/dev/null

Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: ${CODENAME}
Components: stable
Architectures: ${ARCH}
Signed-By: /etc/apt/keyrings/docker.asc

EOF


    "${SUDO[@]}" apt-get update


    # ========================================================
    # INSTALAÇÃO
    # ========================================================

    log \
        "Instalando Docker Engine..."


    "${SUDO[@]}" apt-get install \
        -y \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        docker-buildx-plugin \
        docker-compose-plugin


    "${SUDO[@]}" systemctl \
        enable \
        --now \
        docker


    ok \
        "Docker Engine instalado."

fi


# ============================================================
# PROXY DO DOCKER DAEMON
# ============================================================

HTTP_PROXY_VALUE="${HTTP_PROXY:-${http_proxy:-}}"

HTTPS_PROXY_VALUE="${HTTPS_PROXY:-${https_proxy:-}}"

NO_PROXY_VALUE="${NO_PROXY:-${no_proxy:-}}"


escape_systemd() {

    local value="$1"


    value="${value//\\/\\\\}"

    value="${value//\"/\\\"}"

    value="${value//%/%%}"


    printf '%s' "$value"

}


if [[ -n "${HTTP_PROXY_VALUE}${HTTPS_PROXY_VALUE}" ]]; then


    # Não persistimos automaticamente proxy autenticado.

    if [[ "$HTTP_PROXY_VALUE" == *"@"* \
        || "$HTTPS_PROXY_VALUE" == *"@"* ]]; then


        warn \
            "Proxy com credenciais detectado."


        warn \
            "As credenciais NÃO serão gravadas automaticamente no serviço Docker."


    else


        log \
            "Aplicando ao Docker daemon o proxy já configurado no ambiente..."


        PROXY_CONF="${TMP}/docker-proxy.conf"


        {


            echo '[Service]'


            if [[ -n "$HTTP_PROXY_VALUE" ]]; then

                printf \
                    'Environment="HTTP_PROXY=%s"\n' \
                    "$(escape_systemd "$HTTP_PROXY_VALUE")"

            fi


            if [[ -n "$HTTPS_PROXY_VALUE" ]]; then

                printf \
                    'Environment="HTTPS_PROXY=%s"\n' \
                    "$(escape_systemd "$HTTPS_PROXY_VALUE")"

            fi


            if [[ -n "$NO_PROXY_VALUE" ]]; then

                printf \
                    'Environment="NO_PROXY=%s"\n' \
                    "$(escape_systemd "$NO_PROXY_VALUE")"

            fi


        } > "$PROXY_CONF"


        "${SUDO[@]}" install \
            -d \
            -m 0755 \
            /etc/systemd/system/docker.service.d


        "${SUDO[@]}" install \
            -m 0600 \
            "$PROXY_CONF" \
            /etc/systemd/system/docker.service.d/proxy.conf


        "${SUDO[@]}" systemctl daemon-reload


        "${SUDO[@]}" systemctl restart docker


        ok \
            "Proxy configurado para o daemon Docker."

    fi

fi


# ============================================================
# TESTE DOCKER
# ============================================================

TEST_LOG="${TMP}/docker-test.log"


log \
    "Executando teste hello-world..."


if ! "${SUDO[@]}" docker run \
    --rm \
    hello-world \
    >"$TEST_LOG" \
    2>&1; then


    cat "$TEST_LOG" >&2


    # ========================================================
    # ERRO DE CERTIFICADO
    # ========================================================

    if grep \
        -qiE \
        'x509|certificate signed by unknown authority|certificate verify failed' \
        "$TEST_LOG"; then


        warn \
            "Docker falhou por certificado TLS."


        # ----------------------------------------------------
        # Última tentativa de descoberta segura.
        # ----------------------------------------------------

        if [[ "$CA_READY" -eq 0 ]] \
            && discover_ca "$CANDIDATE"; then


            install_ca "$CANDIDATE"


            CA_READY=1


            "${SUDO[@]}" systemctl restart docker


            log \
                "Repetindo teste..."


            "${SUDO[@]}" docker run \
                --rm \
                hello-world \
                || die \
                    "Docker continua falhando após instalação da CA."


        else


            die \
                "Docker falhou por certificado.

A CA raiz provavelmente não está sendo enviada no handshake.

Execute novamente utilizando:

    --ca-file

ou:

    --ca-url"

        fi


    else


        die \
            "Docker foi instalado, mas hello-world falhou.

Verifique a mensagem exibida acima."

    fi


else


    cat "$TEST_LOG"

fi


ok \
    "Docker está funcional."


# ============================================================
# GRUPO DOCKER
# ============================================================

TARGET_USER="${SUDO_USER:-${USER:-}}"


if [[ -n "$TARGET_USER" \
    && "$TARGET_USER" != "root" ]] \
    && ! id -nG "$TARGET_USER" \
        | tr ' ' '\n' \
        | grep -qx docker; then


    WANT_ADD="no"


    case "$ADD_USER" in


        yes)

            WANT_ADD="yes"

            ;;


        no)

            WANT_ADD="no"

            ;;


        ask)


            if [[ -t 0 ]]; then


                echo


                warn \
                    "IMPORTANTE: membros do grupo docker possuem privilégios equivalentes a root."


                read \
                    -r \
                    -p \
                    "Adicionar '$TARGET_USER' ao grupo docker? [s/N] " \
                    answer


                if [[ "${answer,,}" =~ ^(s|sim|y|yes)$ ]]; then

                    WANT_ADD="yes"

                fi


            fi

            ;;

    esac


    if [[ "$WANT_ADD" == "yes" ]]; then


        "${SUDO[@]}" usermod \
            -aG docker \
            "$TARGET_USER"


        ok \
            "$TARGET_USER adicionado ao grupo docker."


        warn \
            "Encerre a sessão e entre novamente para aplicar o grupo."


        warn \
            "Alternativamente, execute: newgrp docker"

    fi

fi


# ============================================================
# RESULTADO
# ============================================================

echo

echo "============================================================"

echo " INSTALAÇÃO CONCLUÍDA"

echo "============================================================"

echo


docker --version


"${SUDO[@]}" docker compose version


echo


echo "CA esperada:"

echo "    ${EXPECTED_CA_SHA256}"


if [[ "$CA_READY" -eq 1 ]]; then

    echo
    echo "CA corporativa: instalada e validada."

else

    echo
    echo "CA corporativa: não foi necessária/detectada nesta rede."

fi


echo

echo "Teste adicional:"

echo

echo "    sudo docker run --rm hello-world"

echo
