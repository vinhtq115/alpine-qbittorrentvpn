# shellcheck shell=bash

test_connection () {
    # Resolve HEALTH_CHECK_HOST if domain
    if (ipcalc -c "$HEALTH_CHECK_HOST" > /dev/null 2>&1); then
        health_check_ip=$HEALTH_CHECK_HOST
    else
        health_check_ip="$(dig +short "$HEALTH_CHECK_HOST" | head -n 1)"
        echo "$(date +'%Y-%m-%d %H:%M:%S') [DEBUG] $HEALTH_CHECK_HOST resolved to $health_check_ip"
    fi
    
    echo "$(date +'%Y-%m-%d %H:%M:%S') [DEBUG] Route: $(ip r get "$health_check_ip" | head -n 1)"

    if (ping -c 1 "$health_check_ip" > /dev/null 2>&1); then
        echo "$(date +'%Y-%m-%d %H:%M:%S') [DEBUG] Ping to $health_check_ip succeeded"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S') [DEBUG] Ping to $health_check_ip failed"
    fi

    # Resolve HEALTH_CHECK_HOST if domain
    if (ipcalc -c "$VPN_REMOTE" > /dev/null 2>&1); then
        vpn_remote_ip=$VPN_REMOTE
    else
        vpn_remote_ip="$(dig +short "$VPN_REMOTE" | head -n 1)"
        echo "$(date +'%Y-%m-%d %H:%M:%S') [DEBUG] $VPN_REMOTE resolved to $vpn_remote_ip"
    fi

    if (ping -c 1 -I "$DOCKER_INTERFACE" "$vpn_remote_ip" > /dev/null 2>&1); then
        echo "$(date +'%Y-%m-%d %H:%M:%S') [DEBUG] Ping to $vpn_remote_ip via $DOCKER_INTERFACE succeeded"
    else
        echo "$(date +'%Y-%m-%d %H:%M:%S') [DEBUG] Ping to $vpn_remote_ip via $DOCKER_INTERFACE failed"
    fi
}