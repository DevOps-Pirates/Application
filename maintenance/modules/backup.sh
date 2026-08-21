#!/bin/bash

###############################################################################
#                 Backup & Retention Management Module
#
# Backup:
#   /etc/nginx/
#   /var/www/html/
#
# Format:
#   backup_YYYY-MM-DD_HHMM.tar.gz
#
# Retention:
#   Delete backups older than 3 days
###############################################################################

set -u

# Configuration

BACKUP_DIR="/backups"

CURRENT_TS="$(date '+%Y-%m-%d_%H%M')"

BACKUP_FILE="${BACKUP_DIR}/backup_${CURRENT_TS}.tar.gz"

SRC_DIR=(
    "/etc/nginx/"
    "/var/www/html/"
)

# Create Backup Directory

if ! mkdir -p "${BACKUP_DIR}"; then
    echo "ERROR: Failed to create backup directory: ${BACKUP_DIR}"
    exit 1
fi

# Verify Source Directories

for dir in "${SRC_DIR[@]}"; do

    if [[ ! -d "${dir}" ]]; then
        echo "ERROR: Source directory not found: ${dir}"
        exit 1
    fi

done

# Create Backup

echo "Creating backup: ${BACKUP_FILE}"

if ! tar -czf "${BACKUP_FILE}" "${SRC_DIR[@]}"; then
    echo "ERROR: Backup creation failed"
    exit 1
fi

# Retention

echo "Removing backups older than 3 days..."

if ! find "${BACKUP_DIR}" \
    -maxdepth 1 \
    -type f \
    -name 'backup_*.tar.gz' \
    -mtime +3 \
    -delete; then

    echo "ERROR: Failed to remove old backups"
    exit 1
fi

# Final

echo "Backup successful: ${BACKUP_FILE}"

exit 0
