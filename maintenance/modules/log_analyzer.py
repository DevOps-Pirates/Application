#!/usr/bin/env python3

###############################################################################
#                         Nginx Log Analyzer
#
# Features:
#   1. Find top 5 client IP addresses
#   2. Aggregate HTTP status codes
#   3. Detect IPs with a high number of 401/403 responses
#   4. Generate JSON report
###############################################################################

import json
import re
import sys
from collections import Counter
from datetime import datetime
from pathlib import Path


# Configuration

FILE_PATH = Path("test.log")

REPORT_DIR = Path("/tmp")

SECURITY_THRESHOLD = 20

IP_PATTERN = re.compile(
    r"(?P<IP>\d{1,3}(?:\.\d{1,3}){3})"
)

STATUS_PATTERN = re.compile(
    r"\s(?P<CODE>[1-5]\d{2})\s"
)


# Read Log File

def read_file(path: Path):
    if not path.exists():
        raise FileNotFoundError(f"Log file not found: {path}")

    if not path.is_file():
        raise ValueError(f"Path is not a file: {path}")

    with path.open("r", encoding="utf-8", errors="replace") as file:
        return file.readlines()


# Top IP Addresses

def top_ip(lines, n=5):

    ips = []

    for line in lines:

        match = IP_PATTERN.search(line)

        if match:
            ips.append(match.group("IP"))

    return Counter(ips).most_common(n)


# Aggregate HTTP Status Codes

def aggregate_status_code(lines):

    counts = {
        "2xx": 0,
        "3xx": 0,
        "4xx": 0,
        "5xx": 0,
    }

    for line in lines:

        match = STATUS_PATTERN.search(line)

        if not match:
            continue

        code = int(match.group("CODE"))

        category = f"{code // 100}xx"

        if category in counts:
            counts[category] += 1

    return counts


# Security Check

def sec_check(lines, threshold=SECURITY_THRESHOLD):

    failed_requests = Counter()

    for line in lines:

        ip_match = IP_PATTERN.search(line)
        code_match = STATUS_PATTERN.search(line)

        if not ip_match or not code_match:
            continue

        ip = ip_match.group("IP")
        code = int(code_match.group("CODE"))

        if code in (401, 403):
            failed_requests[ip] += 1

    alerts = []

    for ip, count in failed_requests.items():

        if count >= threshold:

            alerts.append({
                "ip": ip,
                "failed_requests": count,
                "message": (
                    f"High number of 401/403 responses "
                    f"from {ip}"
                )
            })

    return alerts


# Generate Report

def generate_report(lines):

    return {
        "generated_at": datetime.now().isoformat(),
        "log_file": str(FILE_PATH),
        "top_ips": top_ip(lines),
        "status_codes": aggregate_status_code(lines),
        "security_check": sec_check(lines),
    }


# Main

def main():

    try:

        lines = read_file(FILE_PATH)

        report = generate_report(lines)

        timestamp = datetime.now().strftime(
            "%Y-%m-%d_%H%M%S"
        )

        result_file = REPORT_DIR / f"nginx_report_{timestamp}.json"

        with result_file.open("w", encoding="utf-8") as file:

            json.dump(
                report,
                file,
                indent=4
            )

        print(f"Report generated successfully: {result_file}")

        return 0

    except Exception as exc:

        print(
            f"ERROR: Nginx log analysis failed: {exc}",
            file=sys.stderr
        )

        return 1


if __name__ == "__main__":
    sys.exit(main())
