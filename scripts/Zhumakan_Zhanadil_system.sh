#!/bin/bash
# Zhumakan_Zhanadil_system.sh
# Shows student information and basic information about the system.

NAME="Zhanadil"
SURNAME="Zhumakan"
GROUP="IT2-2304"
STUDENT_ID="38093"

# project folder is one level above the scripts/ folder
PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
INFO_FILE="$PROJECT_DIR/Zhumakan_Zhanadil_info.txt"

LINE="=============================="

echo "$LINE"
echo "Student Information"
echo "$LINE"
echo "Name: $NAME"
echo "Surname: $SURNAME"
echo "Group: $GROUP"
echo "Student ID: $STUDENT_ID"

echo "$LINE"
echo "System Information"
echo "$LINE"
echo "Username: $(whoami)"
echo "Hostname: $(hostname)"
echo "Current Date: $(date '+%d.%m.%Y %H:%M:%S')"

# uname gives the kernel, /etc/os-release gives the distribution name
DISTRO=""
if [ -f /etc/os-release ]; then
    DISTRO=$(grep '^PRETTY_NAME=' /etc/os-release | cut -d'"' -f2)
fi
echo "Operating System: $(uname -s) $(uname -r) $DISTRO"

# second line of df output is the root partition: used, size, percent
echo "Disk Usage: $(df -h / | awk 'NR==2 {print $3 " used of " $2 " (" $5 ")"}')"
echo "Memory Usage: $(free -h | awk '/^Mem:/ {print $3 " used of " $2}')"
echo "$LINE"

if [ -f "$INFO_FILE" ]; then
    echo "Student information file exists."
else
    echo "Student information file does not exist."
fi
