#!/bin/bash

# Function to list running services
list_services() {
    systemctl list-units --type=service --state=running
}

# Function to show system load averages
system_load() {
    uptime
}

# Function to start a service
start_service() {
    service_name=$1
    if [ -z "$service_name" ]; then
        echo "Please provide a service name."
        exit 1
    fi
    sudo systemctl start $service_name
    echo "Service $service_name started."
}

# Function to stop a service
stop_service() {
    service_name=$1
    if [ -z "$service_name" ]; then
        echo "Please provide a service name."
        exit 1
    fi
    sudo systemctl stop $service_name
    echo "Service $service_name stopped."
}

# Function to check disk usage
disk_usage() {
    df -h
}

# Function to monitor system processes in real-time
process_monitor() {
    # Use top in batch mode or htop (if installed)
    if command -v htop &> /dev/null; then
        htop
    else
        top
    fi
}

# Function to analyze system logs (recent critical entries)
logs_analyze() {
    # Check journal logs for critical entries
    sudo journalctl -p 2 -n 50 --no-pager
}

# Function to backup system files
backup_files() {
    path=$1
    if [ -z "$path" ]; then
        echo "Please provide a path to backup."
        exit 1
    fi
    backup_dir="/tmp/backup_$(basename $path)_$(date +%Y%m%d%H%M%S)"
    echo "Starting backup of $path to $backup_dir..."
    
    # Using rsync to backup the directory
    sudo rsync -av --progress $path $backup_dir
    
    if [ $? -eq 0 ]; then
        echo "Backup completed successfully: $backup_dir"
    else
        echo "Backup failed."
    fi
}

# Command dispatcher
case $1 in
    service)
        case $2 in
            list)
                list_services
                ;;
            start)
                start_service $3
                ;;
            stop)
                stop_service $3
                ;;
            *)
                echo "Invalid option for service. Use list, start, or stop."
                ;;
        esac
        ;;
    system)
        case $2 in
            load)
                system_load
                ;;
            *)
                echo "Invalid option for system. Use load."
                ;;
        esac
        ;;
    disk)
        case $2 in
            usage)
                disk_usage
                ;;
            *)
                echo "Invalid option for disk. Use usage."
                ;;
        esac
        ;;
    process)
        case $2 in
            monitor)
                process_monitor
                ;;
            *)
                echo "Invalid option for process. Use monitor."
                ;;
        esac
        ;;
    logs)
        case $2 in
            analyze)
                logs_analyze
                ;;
            *)
                echo "Invalid option for logs. Use analyze."
                ;;
        esac
        ;;
    backup)
        case $2 in
            "")
                echo "Please specify a path to backup."
                ;;
            *)
                backup_files $2
                ;;
        esac
        ;;
    *)
        echo "Invalid command. Usage: sysopctl <service|system|disk|process|logs|backup> <options>"
        ;;
esac