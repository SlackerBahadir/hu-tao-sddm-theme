#!/bin/bash

# Hu Tao SDDM Theme Installation Script
# Author: SlackerBahadir
# Description: Installs the Hu Tao themed SDDM login manager theme

# NOTE: I did not test this script, but I think it works. But if you want to use it, it is your responsibility.

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Theme configuration
THEME_NAME="hu-tao-sddm-theme"
THEME_DIR="/usr/share/sddm/themes/$THEME_NAME"
SDDM_CONF="/etc/sddm.conf"
BACKUP_CONF="/etc/sddm.conf.backup"

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Function to check if SDDM is installed
check_sddm() {
    if ! command -v sddm &> /dev/null; then
        print_error "SDDM is not installed on this system"
        print_status "Please install SDDM first:"
        print_status "  Ubuntu/Debian: sudo apt install sddm"
        print_status "  Arch Linux: sudo pacman -S sddm"
        print_status "  Fedora: sudo dnf install sddm"
        exit 1
    fi
}

# Function to create backup of SDDM config
backup_config() {
    if [[ -f "$SDDM_CONF" ]]; then
        print_status "Creating backup of existing SDDM configuration..."
        cp "$SDDM_CONF" "$BACKUP_CONF"
        print_success "Backup created at $BACKUP_CONF"
    fi
}

# Function to install theme files
install_theme() {
    print_status "Installing Hu Tao theme files..."
    
    # Create theme directory
    mkdir -p "$THEME_DIR"
    
    # Copy theme files (assuming they're in the current directory)
    if [[ -d "./$THEME_NAME" ]]; then
        cp -r "./$THEME_NAME/"* "$THEME_DIR/"
    else
        # If theme files are in current directory
        cp -r ./* "$THEME_DIR/" 2>/dev/null || true
    fi
    
    # Set proper permissions
    chmod -R 755 "$THEME_DIR"
    chown -R root:root "$THEME_DIR"
    
    print_success "Theme files installed to $THEME_DIR"
}

# Function to configure SDDM
configure_sddm() {
    print_status "Configuring SDDM to use Hu Tao theme..."
    
    # Create SDDM config if it doesn't exist
    if [[ ! -f "$SDDM_CONF" ]]; then
        touch "$SDDM_CONF"
    fi
    
    # Check if [Theme] section exists
    if grep -q "^\[Theme\]" "$SDDM_CONF"; then
        # Update existing [Theme] section
        sed -i "/^\[Theme\]/,/^\[/ { /^Current=/ { s/^Current=.*/Current=$THEME_NAME/; t; }; /^\[/! { /^Current=/! { /^$/! a\\
Current=$THEME_NAME
; }; }; }" "$SDDM_CONF"
    else
        # Add [Theme] section
        echo "" >> "$SDDM_CONF"
        echo "[Theme]" >> "$SDDM_CONF"
        echo "Current=$THEME_NAME" >> "$SDDM_CONF"
    fi
    
    print_success "SDDM configured to use Hu Tao theme"
}

# Function to restart SDDM service
restart_sddm() {
    print_status "Restarting SDDM service..."
    
    if systemctl is-active --quiet sddm; then
        systemctl restart sddm
        print_success "SDDM service restarted"
    elif systemctl is-enabled --quiet sddm; then
        systemctl start sddm
        print_success "SDDM service started"
    else
        print_warning "SDDM service is not enabled. You may need to enable it manually:"
        print_warning "  sudo systemctl enable sddm"
        print_warning "  sudo systemctl start sddm"
    fi
}

# Function to show installation summary
show_summary() {
    echo ""
    print_success "Hu Tao SDDM Theme Installation Complete!"
    echo ""
    print_status "Theme Details:"
    print_status "  Theme Name: $THEME_NAME"
    print_status "  Installation Path: $THEME_DIR"
    print_status "  Configuration File: $SDDM_CONF"
    echo ""
    print_status "Next Steps:"
    print_status "  1. Log out or reboot to see the new theme"
    print_status "  2. If you encounter issues, check the backup: $BACKUP_CONF"
    print_status "  3. To uninstall, run: sudo rm -rf $THEME_DIR or ./setup.sh --uninstall"
    echo ""
}

# Function to handle uninstallation
uninstall_theme() {
    print_status "Uninstalling Hu Tao SDDM theme..."
    
    # Remove theme directory
    if [[ -d "$THEME_DIR" ]]; then
        rm -rf "$THEME_DIR"
        print_success "Theme files removed"
    fi
    
    # Restore backup configuration
    if [[ -f "$BACKUP_CONF" ]]; then
        cp "$BACKUP_CONF" "$SDDM_CONF"
        print_success "SDDM configuration restored from backup"
    fi
    
    print_success "Hu Tao theme uninstalled successfully"
}

# Main installation function
main() {
    echo "==========================================="
    echo "  Hu Tao SDDM Theme Installation Script"
    echo "==========================================="
    echo ""
    
    # Parse command line arguments
    case "${1:-}" in
        --uninstall|-u)
            check_root
            uninstall_theme
            exit 0
            ;;
        --help|-h)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --uninstall, -u    Uninstall the theme"
            echo "  --help, -h         Show this help message"
            echo ""
            echo "Default: Install the theme"
            exit 0
            ;;
    esac
    
    # Run installation steps
    check_root
    check_sddm
    backup_config
    install_theme
    configure_sddm
    restart_sddm
    show_summary
}

# Run main function with all arguments
main "$@"