#!/bin/bash

# Filename: generate_sys_report.sh
# Purpose : Generate a detailed system report and save it with timestamp
# Author  : kush68
# License : MIT

report_dir="./reports"
timestamp=$(date '+%Y-%m-%d_%H-%M-%S')
output_file="$report_dir/system_report_$timestamp.txt"

mkdir -p "$report_dir"

{
    echo "================= SYSTEM REPORT ================="
    echo "Generated on: $(date)"
    echo "Hostname: $(hostname)"
    echo

    echo "---------- OS INFORMATION ----------"
    [ -f /etc/os-release ] && cat /etc/os-release
    echo

    echo "---------- KERNEL & ARCHITECTURE ----------"
    uname -r && uname -m
    echo

    echo "---------- UPTIME ----------"
    uptime
    echo

    echo "---------- CPU INFORMATION ----------"
    lscpu
    echo

    echo "---------- MEMORY USAGE ----------"
    free -h
    echo

    echo "---------- DISK USAGE ----------"
    df -h --total
    echo

    echo "---------- NETWORK INTERFACES ----------"
    ip -brief addr
    echo

    echo "---------- IP ADDRESSES ----------"
    hostname -I
    echo

    echo "---------- TOP 10 PROCESSES BY MEMORY ----------"
    ps aux --sort=-%mem | head -n 11
    echo

    echo "---------- LOGGED-IN USERS ----------"
    who
    echo

    echo "---------- LAST 5 SYSTEM LOGINS ----------"
    last -n 5
    echo

    echo "Report saved to: $output_file"
} > "$output_file"

echo "System report generated: $output_file"
