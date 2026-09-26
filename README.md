# Bash Server Monitor

A modular Bash CLI utility for Linux server health monitoring.

The project demonstrates practical DevOps skills in Bash scripting, Linux monitoring, service health checks, logging, alerting, testing, and CI.

Tested on Ubuntu Server 24.04 LTS ARM64.

## Features

The monitor performs the following checks:

- CPU utilization
- RAM utilization
- Swap utilization
- Disk utilization
- Inode utilization
- 1-minute load average
- Network connectivity
- DNS resolution
- Configured processes
- systemd services
- Docker daemon status if Docker is installed
- HTTP endpoint availability

Additional functionality:

- Configurable thresholds
- External configuration file
- `--help`
- `--version`
- `--quiet`
- Exit codes for automation
- Local logging
- Generic webhook alerting
- Modular Bash libraries
- Smoke tests
- ShellCheck
- GitHub Actions CI
- Documented failure scenario

## Architecture

```text
                    +----------------------+
                    |    server-monitor    |
                    |      Bash CLI        |
                    +----------+-----------+
                               |
             +-----------------+-----------------+
             |                 |                 |
             v                 v                 v
       System metrics      Connectivity      Applications
             |                 |                 |
       CPU / RAM           Network / DNS     Processes
       Swap / Load         HTTP endpoint     systemd
       Disk / Inodes                         Docker
             |                 |                 |
             +-----------------+-----------------+
                               |
                               v
                    +----------------------+
                    |    Overall status    |
                    | OK/WARNING/CRITICAL  |
                    +----------+-----------+
                               |
                    +----------+----------+
                    |                     |
                    v                     v
                 Log file          Optional webhook
```

## Project Structure

```text
bash-server-monitor/
├── bin/
│   └── server-monitor
├── config/
│   └── config.example
├── lib/
│   ├── cpu.sh
│   ├── memory.sh
│   ├── disk.sh
│   ├── system.sh
│   ├── network.sh
│   └── services.sh
├── tests/
│   └── smoke-test.sh
├── docs/
│   └── failure-demo.md
├── .github/
│   └── workflows/
│       └── shellcheck.yml
├── .gitignore
├── LICENSE
└── README.md
```

## Requirements

The monitor is designed for Linux.

Tested environment:

- Ubuntu Server 24.04 LTS
- ARM64

It uses standard Linux utilities including:

- Bash
- awk
- df
- free
- top
- ping
- getent
- pgrep
- systemctl
- curl

Docker is optional. If Docker is not installed, its check is skipped.

The monitor should be executed on the Linux server being monitored, not directly on macOS.

## Installation

Clone the repository:

```bash
git clone https://github.com/atalabaev/bash-server-monitor.git
cd bash-server-monitor
```

Make the monitor executable:

```bash
chmod +x bin/server-monitor
```

Create a local configuration:

```bash
cp config/config.example config/config.conf
```

The local `config/config.conf` file is ignored by Git.

## Configuration

Example:

```bash
CPU_WARNING=80
RAM_WARNING=85
DISK_WARNING=90
SWAP_WARNING=90
INODE_WARNING=90
LOAD_WARNING=2

NETWORK_HOST=1.1.1.1
DNS_HOST=example.com
CHECK_URL=http://localhost

PROCESSES="nginx"
SERVICES="nginx"

LOG_FILE=/tmp/server-monitor.log
WEBHOOK_URL=""
```

Do not commit webhook URLs, tokens, passwords, or other credentials.

## Usage

Run the monitor:

```bash
./bin/server-monitor
```

Use a configuration file:

```bash
./bin/server-monitor --config config/config.conf
```

Display help:

```bash
./bin/server-monitor --help
```

Display version:

```bash
./bin/server-monitor --version
```

Quiet mode:

```bash
./bin/server-monitor --quiet
```

## Example Output

Real output from the test server:

```text
SERVER HEALTH REPORT
Host: web01
Timestamp: 2026-09-26T10:05:56Z

CPU          OK         4%
RAM          OK         10%
DISK         OK         35%
SWAP         OK         0%
INODES       OK         23%
LOAD         OK         0.00
NETWORK      OK         1.1.1.1
DNS          OK         example.com
PROCESS      OK         nginx
SERVICE      OK         nginx
DOCKER       SKIPPED
HTTP         OK (200)   http://localhost

Overall status: OK
```

The healthy test returned exit code `0`.

## Exit Codes

| Code | Status |
|---|---|
| `0` | OK |
| `1` | WARNING |
| `2` | CRITICAL |

The exit codes allow the monitor to be integrated with automation, systemd timers, CI jobs, and external monitoring systems.

Example:

```bash
./bin/server-monitor
echo $?
```

## Logging

Each monitoring run records its final state.

Default log:

```text
/tmp/server-monitor.log
```

Example entries:

```text
2026-09-26T10:05:57Z host=web01 status=OK exit_code=0
2026-09-26T10:06:27Z host=web01 status=CRITICAL exit_code=2
```

The log path can be configured using `LOG_FILE`.

## Webhook Alerting

An optional generic webhook can be configured using `WEBHOOK_URL`.

Example:

```bash
export WEBHOOK_URL="https://your-webhook.example/endpoint"
```

When the overall state is not OK, the monitor can send a JSON notification to the configured webhook.

Secrets and real webhook URLs must not be committed to Git.

## Failure Demonstration

A controlled failure was tested by changing:

```text
CHECK_URL=http://localhost
```

to an unused local port:

```text
CHECK_URL=http://127.0.0.1:59999
```

The monitor detected the unavailable endpoint:

```text
HTTP         CRITICAL   http://127.0.0.1:59999

Overall status: CRITICAL
FAILURE EXIT CODE: 2
```

The failure was also recorded in the log:

```text
2026-09-26T10:06:27Z host=web01 status=CRITICAL exit_code=2
```

See `docs/failure-demo.md` for the complete failure demonstration.

## Testing

Run the smoke tests:

```bash
bash tests/smoke-test.sh
```

Current result:

```text
Passed: 16
Failed: 0
All static smoke tests passed.
```

Run ShellCheck:

```bash
shellcheck bin/server-monitor lib/*.sh tests/*.sh
```

A successful ShellCheck run exits with code `0`.

## Continuous Integration

GitHub Actions automatically runs ShellCheck on:

- pushes to `main`
- pull requests

Workflow file:

```text
.github/workflows/shellcheck.yml
```

This provides automatic static analysis for the Bash code in the repository.

## Security

`config/config.conf` is excluded from Git.

The repository must never contain:

- webhook secrets
- API tokens
- passwords
- SSH private keys
- `.env` files containing credentials

The configuration file is sourced as Bash code and must only come from a trusted source.

## Troubleshooting

### HTTP check is CRITICAL

```bash
curl -I http://localhost
```

### DNS check is CRITICAL

```bash
getent hosts example.com
```

### Network check is CRITICAL

```bash
ping -c 2 1.1.1.1
```

### Service check is CRITICAL

```bash
systemctl status nginx
```

### Process check is CRITICAL

```bash
pgrep -a nginx
```

### The monitor does not work correctly on macOS

This project targets Linux and uses Linux-specific utilities and interfaces including `/proc`, `free`, and `systemctl`.

Run the monitor on the Linux server being monitored.

## What I Learned

This project provided practical experience with:

- Bash scripting
- modular shell architecture
- Linux system metrics
- process monitoring
- systemd service monitoring
- network diagnostics
- DNS diagnostics
- HTTP health checks
- configurable thresholds
- exit-code based automation
- logging
- webhook alerting
- failure simulation
- ShellCheck
- automated testing
- GitHub Actions
- Git workflow

## Future Improvements

Possible future improvements:

- JSON output
- Prometheus textfile exporter
- SSL certificate expiration monitoring
- systemd timer installation
- Docker image packaging
- multiple HTTP endpoints
- additional notification integrations

## License

See `LICENSE`.
