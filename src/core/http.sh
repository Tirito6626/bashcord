#!/bin/bash
function fiction.400 {
    FictionResponseHeaders['content-type']="application/json"
    fiction.respond 401 '{ "error": "invalid request" }'
}

function fiction.401 {
    FictionResponseHeaders['content-type']="text/plain"
    fiction.respond 401 'invalid request signature'
}

function fiction.403 {
    FictionResponseHeaders['content-type']="application/json"
        fiction.respond 403 '{"error":"forbidden"}'
}

function fiction.404 {
    FictionResponseHeaders['content-type']="application/json"
    fiction.respond 404 '{"error":"not found"}'
}


function fiction.500 {
    FictionResponseHeaders['content-type']="application/json"
    fiction.respond 500 '{"error":"server error"}'
}



function verifyRequest {
    readonly rand="$RANDOM"
    local sig="${FictionRequestHeaders[x-signature-ed25519]}" timestamp="${FictionRequestHeaders[x-signature-timestamp]}"
    if [[ -z "$sig" || -z "$timestamp" ]]; then
        return 1
    fi
    to_hex "$sig"
    printf "%b" "$result" > "${tmp_path}/.sig_$rand"
    printf "%s" "${timestamp}${FictionRequestBodyRaw}" > "${tmp_path}/.msg_$rand"
   # set -x
    printf "%s" "[bashcord/http/openssl] " >&2
    if openssl pkeyutl -verify \
        -pubin -inkey "$__key"  -rawin -in "${tmp_path}/.msg_$rand" \
        -sigfile "${tmp_path}/.sig_$rand" 1>&2
    then
        rm "${tmp_path}/.msg_$rand" "${tmp_path}/.sig_$rand"
        return 0
    else
        rm "${tmp_path}/.msg_$rand" "${tmp_path}/.sig_$rand"
        return 1
        #set +x
    fi

}

function handleEvent {
    #echo "${FictionRequestBody[type]}" >&2
    case "${FictionRequest[method]}" in
        POST)
            if verifyRequest; then
                case "${FictionRequestBody[type]}" in
                1)
                    echo "[bashcord/http] acknowledged PING" >&2
                    FictionResponseHeaders['content-type']="application/json"
                    fiction.respond 200 '{"type": 1}'
                    #set -x
                    #interaction_reply 1 "${FictionRequestBody[id]}" "${FictionRequestBody[token]}"
                    #set +x
                    ;;
                2)
                    declare -n Interaction=FictionRequestBody;
                    echo "[bashcord/http] received application command" >&2
                    event emit applicationCommand
                    fiction.respond 204
                    ;;
                *)
                    echo "[bashcord/http] received unsupported type" >&2
                    FictionResponseHeaders['Content-Type']="application/json"
                    fiction.respond 204
                ;;
                esac
            else
                echo "[bashcord/http] failed to verify the signature" >&2
                fiction.401
            fi
            ;;
        *)
            fiction.404
        ;;
    esac
}