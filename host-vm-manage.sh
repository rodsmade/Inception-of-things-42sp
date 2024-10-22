#!/bin/bash

# Variables (change these as needed)
VM_NAME="inception-of-things"
VM_FOLDER="$HOME/VirtualBox VMs/$VM_NAME"
HDD_PATH="$VM_FOLDER/$VM_NAME.vdi"
HDD_SIZE=10000    # HDD size in MB (20GB)
RAM_SIZE=2000     # RAM size in MB (2GB)
VRAM_SIZE=128     # Video memory in MB
CPUS=2            # Number of CPU cores

# Function to check if the ISO exists
check_iso() {
	ISO_PATH=$1
	if [ ! -f "$ISO_PATH" ]; then
		echo "Error: ISO file '$ISO_PATH' does not exist."
		exit 1
	fi
}

# Function to create the VM
create_vm() {
	ISO_PATH=$1

	if [ -z "$ISO_PATH" ]; then
		echo "ISO path is required to create the VM."
		exit 1
	fi

	# Check if the ISO file exists
	check_iso "$ISO_PATH"

	# Check if VM already exists
	if VBoxManage showvminfo "$VM_NAME" &>/dev/null; then
		echo "VM '$VM_NAME' already exists."
		exit 1
	fi

	echo "Creating virtual machine '$VM_NAME'..."

	# Create VM
	VBoxManage createvm --name "$VM_NAME" --ostype Ubuntu_64 --register

	# Modify VM settings
	VBoxManage modifyvm "$VM_NAME" --cpus "$CPUS" --memory "$RAM_SIZE" --vram "$VRAM_SIZE" --nic1 nat

	# Create a virtual hard disk
	VBoxManage createhd --filename "$HDD_PATH" --size "$HDD_SIZE"

	# Set up the storage controller
	VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci
	VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$HDD_PATH"

	# Attach the Ubuntu ISO
	VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide
	VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$ISO_PATH"

	# Configure boot order
	VBoxManage modifyvm "$VM_NAME" --boot1 dvd --boot2 disk --boot3 none --boot4 none

	# Start the VM
	VBoxManage startvm "$VM_NAME" --type gui

	echo "Virtual machine '$VM_NAME' created and started."
}

# Function to delete the VM
delete_vm() {
	echo "Deleting virtual machine '$VM_NAME'..."

	# Power off the VM if running
	VBoxManage controlvm "$VM_NAME" poweroff &>/dev/null

	# Unregister and delete the VM and associated files
	VBoxManage unregistervm "$VM_NAME" --delete

	echo "Virtual machine '$VM_NAME' deleted."
}

# Function to rebuild the VM
rebuild_vm() {
	echo "Rebuilding virtual machine '$VM_NAME'..."
	delete_vm
	create_vm "$1"
}

# Script usage instructions
usage() {
	echo "Usage: $0 {create|rebuild|delete} [ISO_PATH]"
	echo "  create  - Create a new VM (requires ISO_PATH)"
	echo "  rebuild - Rebuild the VM (requires ISO_PATH)"
	echo "  delete  - Delete the VM"
}

# Main script logic
case "$1" in
	create)
		if [ -z "$2" ]; then
			echo "ISO path is required for create."
			usage
			exit 1
		fi
		create_vm "$2"
		;;
	rebuild)
		if [ -z "$2" ]; then
			echo "ISO path is required for rebuild."
			usage
			exit 1
		fi
		rebuild_vm "$2"
		;;
	delete)
		delete_vm
		;;
	*)
		usage
		exit 1
		;;
esac
