#!/usr/bin/env bash


HEADER_CONTENT_TYPE="Content-Type: application/xml"
HEADER_ACCEPT="Accept: application/xml"

function waitForStatus {
    local uri=$1
    local xPathStatusTest=$2
    local xPathStatusValue=$3
    local timeoutIntervalSec=$4

    local status="0"
    for i in $(seq 1 10); do
        callGETService "${uri}"
        local c=`getXPathCount "${xPathStatusTest}"`
        local val=`getXPathValue "${xPathStatusValue}"`

        if [[ "$c" > "0" ]]; then
            echo "Target status ${val} reached. Done."
            status="1"
            break;
        else
            echo "Waiting for ${timeoutIntervalSec} s...(${i}, value=${val})"
            sleep ${timeoutIntervalSec}
        fi
    done;

    if [[ "$status" == "0" ]]; then
        echo "Timeout, waiting interrupted."
    fi
}


function callGETService {
    local uri=$1
    local certAtt=""

    if [[ -n "$CA_CERT_PATH" ]]; then
        certAtt="--cacert $CA_CERT_PATH"
    fi

    echo "Calling URI (GET): " ${uri}
    curl -X GET -H "${HEADER_ACCEPT}" -H "${HEADER_CONTENT_TYPE}" -u "${USER_NAME}:${USER_PASSW}" "$certAtt" "${ENGINE_URL}${uri}" --output "${COMM_FILE}" 2> /dev/null > "${COMM_FILE}"
}

function callPOSTService {
    local uri=$1
    local xml=$2
    local certAtt=""

    if [[ -n "$CA_CERT_PATH" ]]; then
        certAtt="--cacert $CA_CERT_PATH"
    fi

    echo "Calling URI (POST): " ${uri}
    curl -X POST -H "${HEADER_ACCEPT}" -H "${HEADER_CONTENT_TYPE}" -u "${USER_NAME}:${USER_PASSW}" "$certAtt" "${ENGINE_URL}${uri}" -d "${xml}" 2> /dev/null > "${COMM_FILE}"
}