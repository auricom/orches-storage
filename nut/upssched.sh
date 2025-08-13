#!/bin/bash

UPS_USERNAME=upswired
UPS_LINK=eatonelite@localhost

set -a
source "/root/config/sops/nut.env"
set +a

log_message() {
    DATE=$(date '+%Y-%m-%d %H:%M:%S')
    echo "${DATE} - $1"
}

send_pushover_message() {
    local message="$1"
    local title="${2:-Notification}"
    local priority="${3:-0}"
    local device="${4:-}"

    curl -s \
        --form-string "token=${PUSHOVER_APP_TOKEN}" \
        --form-string "user=${PUSHOVER_USER_KEY}" \
        --form-string "message=${message}" \
        --form-string "title=${title}" \
        --form-string "priority=${priority}" \
        --form-string "device=${device}" \
        https://api.pushover.net/1/messages.json
}

case $1 in
    info_onbatt)
        upscmd -u ${UPS_USERNAME} -p ${UPS_PASSWORD} ${UPS_LINK} beeper.enable
        message="Power outage, on battery"
        log_message "$message"
        send_pushover_message "$message" "UPS Alert"
        ;;
    info_onpower)
        message="Power restored"
        log_message "$message"
        send_pushover_message "$message" "UPS Alert"
        ;;
    mute_beeper)
        message="(2) minute limit exceeded, muting beeper"
        log_message "$message"
        upscmd -u ${UPS_USERNAME} -p ${UPS_PASSWORD} ${UPS_LINK} beeper.mute
        ;;
    shutdown_lowbatt)
        message="Triggering shutdown as battery is low"
        log_message "$message"
        send_pushover_message "$message" "UPS Alert" 1
        /sbin/upsmon -c fsd
        ;;
    replace_batt)
        message="Quick self-test indicates battery requires replacement"
        log_message "$message"
        send_pushover_message "$message" "UPS Alert" 1
        ;;
    *)
        message="Unrecognized command: $1"
        log_message "$message"
        send_pushover_message "$message" "UPS Alert"
        ;;
esac
