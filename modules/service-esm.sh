# shellcheck disable=SC2039

ESM_SUPPORTED_SERIES="precise"
ESM_SUPPORTED_ARCHS=""

ESM_REPO_URL="esm.ubuntu.com"
ESM_REPO_KEY_FILE="ubuntu-esm-keyring.gpg"
ESM_REPO_LIST=${ESM_REPO_LIST:-"/etc/apt/sources.list.d/ubuntu-esm-${SERIES}.list"}

esm_enable() {
    local token="$1"

    check_token "$ESM_REPO_URL" "$token"
    write_apt_list_file "$ESM_REPO_LIST" "$ESM_REPO_URL" "$token"
    cp "${KEYRINGS_DIR}/${ESM_REPO_KEY_FILE}" "$APT_KEYS_DIR"
    install_package_if_missing_file "$APT_METHOD_HTTPS" apt-transport-https
    install_package_if_missing_file "$CA_CERTIFICATES" ca-certificates
    echo -n 'Running apt-get update... '
    check_result apt_get update
    echo 'Ubuntu ESM repository enabled.'
}

esm_disable() {
    if [ -f "$ESM_REPO_LIST" ]; then
        mv "$ESM_REPO_LIST" "${ESM_REPO_LIST}.save"
        rm -f "$APT_KEYS_DIR/$ESM_REPO_KEY_FILE"
        echo -n 'Running apt-get update... '
        check_result apt_get update
        echo 'Ubuntu ESM repository disabled.'
    else
        echo 'Ubuntu ESM repository was not enabled.'
    fi
}

esm_is_enabled() {
    apt-cache policy | grep -Fq "$ESM_REPO_URL"
}

esm_check_support() {
    check_service_support \
        "Extended Security Maintenance" "$ESM_SUPPORTED_SERIES" \
        "$ESM_SUPPORTED_ARCHS"
}
