# Failure Demonstration

This document demonstrates that `bash-server-monitor` correctly detects a failed HTTP endpoint and returns a critical exit code.

## Environment

- Host: `web01`
- OS: Ubuntu Server
- Web service: Nginx
- Monitor: `bash-server-monitor`

## Healthy Run

The normal configuration used:

    CHECK_URL=http://localhost

Observed result:

    HTTP         OK (200)   http://localhost
    Overall status: OK
    EXIT CODE: 0

The result was written to the monitor log:

    2026-09-26T10:05:57Z host=web01 status=OK exit_code=0

## Simulated Failure

The HTTP endpoint was deliberately changed to an unused local port:

    CHECK_URL=http://127.0.0.1:59999

Observed result:

    HTTP         CRITICAL   http://127.0.0.1:59999
    Overall status: CRITICAL
    FAILURE EXIT CODE: 2

The critical state was also recorded in the log:

    2026-09-26T10:06:27Z host=web01 status=CRITICAL exit_code=2

## Conclusion

The test confirms that the monitor detects an unavailable HTTP endpoint, changes the overall server state to `CRITICAL`, records the event in the log, and returns exit code `2`.
