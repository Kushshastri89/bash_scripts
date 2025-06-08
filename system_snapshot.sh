#!/bin/bash

# ===== System Snapshot Generator =====
# Author: kush68
# Description: Generate a full snapshot of the current Linux system
# License: MIT

SNAPSHOT_DIR="snapshot_$(date '+%Y-%m-%d_%H-%M-%S')"
mkdir -p "$SNAPSHOT_DIR"

log() {
    echo "[+] $1"
}

capture() {
    log "$1"
    eval "$2" > "$SNAPSHOT_DIR/$3.txt" 2>/dev/null
}

log "Generating system snapshot in '$SNAPSHOT_DIR'..."

# Basic Info
capture "System Information" "uname -a" "system_info"
capture "OS Release Info" "cat /etc/os-release" "os_release"
capture "Hostname" "hostnamectl" "hostname"
capture "Uptime" "uptime" "uptime"

# Hardware Info
capture "CPU Info" "lscpu" "cpu"
capture "Memory Info" "free -h" "memory"
capture "Block Devices" "lsblk" "block_devices"
capture "Disk Usage" "df -h" "disk_usage"
capture "PCI Devices" "lspci" "pci_devices"
capture "USB Devices" "lsusb" "usb_devices"

# Services & Daemons
capture "Systemd Services (active)" "systemctl list-units --type=service --state=running" "running_services"
capture "Startup Services" "systemctl list-unit-files --type=service" "startup_services"

# Installed Packages
if command -v apt &>/dev/null; then
    capture "APT Packages" "dpkg -l" "installed_packages_apt"
elif command -v dnf &>/dev/null; then
    capture "DNF Packages" "dnf list installed" "installed_packages_dnf"
elif command -v pacman &>/dev/null; then
    capture "Pacman Packages" "pacman -Q" "installed_packages_pacman"
else
    echo "[-] Package manager not supported." > "$SNAPSHOT_DIR/installed_packages.txt"
fi

# Network Info
capture "IP Addresses" "ip addr show" "ip_address"
capture "Routing Table" "ip route" "routing_table"
capture "Open Ports" "ss -tuln" "open_ports"
capture "Hostname/IP" "hostname -I" "hostname_ip"

# Running Processes
capture "Top 20 Processes by Memory" "ps aux --sort=-%mem | head -n 21" "top_processes"

# Crontab Entries
capture "User Crontab" "crontab -l" "user_crontab"
capture "System Crontab" "cat /etc/crontab" "system_crontab"

log "System snapshot completed. All data saved in '$SNAPSHOT_DIR'."
