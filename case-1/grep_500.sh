#!/bin/bash

LOG_DIR="/var/log/nginx"

NOW=$(date -u +%s)
TEN_MIN_AGO=$(($NOW - 600)) # 600 seconds = 10 minutes

grep -E 'HTTP/1.[01]" 500 ' "$LOG_DIR"/Http-*.log | \
awk -v now=$NOW -v ten_min_ago=$TEN_MIN_AGO '
{
    # Extract timestamp from the log entry
    match($0, /\[([0-9]{2}\/[A-Za-z]+\/[0-9]{4}:[0-9]{2}:[0-9]{2}:[0-9]{2})/, ts)
    log_epoch = mktime(gensub(/(..)\/(...)\/(....):(..):(..):(..)/, "\\3 \\2 \\1 \\4 \\5 \\6", "1", ts[1]))

    # Count only logs within the last 10 minutes
    if (log_epoch >= ten_min_ago && log_epoch <= now) {
        count++
    }
}
END { print "HTTP 500 errors in the last 10 minutes:", count }
'
