#!/bin/bash

###############################################################################
#                     Central Orchestration Script
#
# Usage:
#   ./main.sh
#   ./main.sh --full-run
#   ./main.sh --backup-only
###############################################################################

set -u

# Configuration

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULES_DIR="${SCRIPT_DIR}/modules"

LOG_FILE="/var/log/maintenance.log"

# Logging

log() {
    local level="$1"
    local message="$2"

    echo "$(date '+%Y-%m-%d %H:%M:%S') [${level}] ${message}" \
        | tee -a "${LOG_FILE}"
}

# Initialization

if ! touch "${LOG_FILE}" 2>/dev/null; then
    echo "ERROR: Cannot write to ${LOG_FILE}"
    exit 1
fi

if [[ ! -d "${MODULES_DIR}" ]]; then
    log "ERROR" "Modules directory not found: ${MODULES_DIR}"
    exit 1
fi

# Run Module

run_module() {
    local module="$1"
    local module_name="$2"

    log "INFO" "Starting ${module_name}"

    if [[ ! -f "${module}" ]]; then
        log "ERROR" "Module not found: ${module}"
        return 1
    fi

    if ! chmod +x "${module}"; then
        log "ERROR" "Failed to make module executable: ${module}"
        return 1
    fi

    case "${module}" in
        *.py)
            python3 "${module}"
            ;;
        *.sh)
            "${module}"
            ;;
        *)
            log "ERROR" "Unsupported module type: ${module}"
            return 1
            ;;
    esac

    local exit_code=$?

    if [[ ${exit_code} -ne 0 ]]; then
        log "ERROR" "${module_name} failed with exit code ${exit_code}"
    else
        log "INFO" "${module_name} completed successfully"
    fi

    return "${exit_code}"
}

# CLI Parsing

MODE="full"

while [[ $# -gt 0 ]]; do

    case "$1" in

        --backup-only)
            MODE="backup"
            shift
            ;;

        --full-run)
            MODE="full"
            shift
            ;;

        -h|--help)
            echo "Usage:"
            echo "  $0                  Run all modules"
            echo "  $0 --full-run       Run all modules"
            echo "  $0 --backup-only    Run backup module only"
            echo "  $0 --help           Show this help"
            exit 0
            ;;

        *)
            log "ERROR" "Unknown option: $1"
            echo "Usage: $0 [--full-run|--backup-only]"
            exit 1
            ;;

    esac

done

# Module Paths

LOG_ANALYZER="${MODULES_DIR}/log_analyzer.py"
BACKUP_MODULE="${MODULES_DIR}/backup.sh"

# Execution

FAILED_MODULES=()

if [[ "${MODE}" == "full" ]]; then

    if ! run_module "${LOG_ANALYZER}" "Nginx Log Analyzer Module"; then
        FAILED_MODULES+=("Nginx Log Analyzer")
    fi

fi

if [[ "${MODE}" == "backup" || "${MODE}" == "full" ]]; then

    if ! run_module "${BACKUP_MODULE}" "Backup & Retention Module"; then
        FAILED_MODULES+=("Backup & Retention")
    fi

fi

# Final Status

if [[ ${#FAILED_MODULES[@]} -gt 0 ]]; then

    log "ERROR" "The following modules failed: ${FAILED_MODULES[*]}"
    log "INFO" "Maintenance operation completed with errors"
    exit 1
fi

log "INFO" "All requested operations completed successfully"

exit 0
