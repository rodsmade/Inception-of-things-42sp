#!/bin/bash

# Variables (change these as needed)
VM_NAME="inception-of-things"
VM_FOLDER="$HOME/VirtualBox VMs/$VM_NAME"
OVA_URL="https://cloud-images.ubuntu.com/oracular/current/oracular-server-cloudimg-amd64.ova"  # Update this URL
OVA_PATH="$VM_FOLDER/oracular-server-cloudimg-amd64.ova"       # Path to save the OVA
HDD_SIZE=10000    # HDD size in MB (10GB)
RAM_SIZE=2000     # RAM size in MB (2GB)
VRAM_SIZE=128     # Video memory in MB
CPUS=2            # Number of CPU cores
PRESEED_ISO="./host-pre-seeding/my-seed.iso"  # Path to the preseed ISO file

# Function to check if the OVA exists
check_ova() {
	if [ ! -f "$OVA_PATH" ]; then
		echo "OVA file '$OVA_PATH' does not exist. Downloading..."
		download_ova
	fi
}

# Function to download the OVA
download_ova() {
	# Create VM folder if it doesn't exist
	mkdir -p "$VM_FOLDER"

	# Download the OVA file
	wget -O "$OVA_PATH" "$OVA_URL"

	if [ $? -ne 0 ]; then
		echo "Error: Failed to download OVA from '$OVA_URL'."
		exit 1
	fi

	echo "Downloaded OVA file to '$OVA_PATH'."
}

# Detects platform and assigns correct VBoxManage command
detect_vboxmanage() {
		if command -v VBoxManage &>/dev/null; then
				VBOXMANAGE="VBoxManage"
		elif command -v VBoxManage.exe &>/dev/null; then
				VBOXMANAGE="VBoxManage.exe"
		elif [[ "$(uname -r)" == *"Microsoft"* ]]; then
				# Fallback for WSL if VBoxManage.exe isn't in PATH but might be in the Windows system
				VBOXMANAGE="/mnt/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"
				if [[ ! -f "$VBOXMANAGE" ]]; then
						echo "Error: VBoxManage.exe not found in PATH or default Windows install location."
						exit 1
				fi
		else
				echo "Error: VBoxManage not found. Please install VirtualBox or add VBoxManage to your PATH."
				exit 1
		fi

	echo "Using VBoxManage command: $VBOXMANAGE"
}

# Function to create or start the VM
create_vm() {
	check_ova

	# Check if VM already exists
	if $VBOXMANAGE showvminfo "$VM_NAME" &>/dev/null; then
		echo "VM '$VM_NAME' already exists. Starting the existing VM..."
		$VBOXMANAGE startvm "$VM_NAME" --type gui
		exit 0
	fi

	echo "Importing OVA file '$OVA_PATH'..."

	# Import the OVA
	$VBOXMANAGE import "$OVA_PATH" --vsys 0 --vmname "$VM_NAME"

	# Modify VM settings (if necessary)
	$VBOXMANAGE modifyvm "$VM_NAME" --cpus "$CPUS" --memory "$RAM_SIZE" --vram "$VRAM_SIZE" --nic1 nat

	# Attach preseed ISO
	if [ -f "$PRESEED_ISO" ]; then
		echo "Attaching preseed ISO '$PRESEED_ISO'..."
		$VBOXMANAGE storageattach "$VM_NAME" --storagectl "IDE" --port 1 --device 0 --type dvddrive --medium "$PRESEED_ISO"
	else
		echo "Preseed ISO '$PRESEED_ISO' not found. Please make sure the file exists."
	fi

	# Start the VM
	$VBOXMANAGE startvm "$VM_NAME" --type gui

	echo "Virtual machine '$VM_NAME' created and started."
}

# Function to delete the VM
delete_vm() {
	echo "Deleting virtual machine '$VM_NAME'..."

	# Power off the VM if running and handle errors
	if $VBOXMANAGE controlvm "$VM_NAME" poweroff &>/dev/null; then
		# Sleep for a few seconds to ensure the VM is fully powered off
		sleep 2
		echo "Successfully powered off '$VM_NAME'."
	else
		echo "Warn: Failed to power off '$VM_NAME'. It may not be running."
	fi

	# Unregister and delete the VM and associated files
	if $VBOXMANAGE unregistervm "$VM_NAME" --delete; then
		echo "Virtual machine '$VM_NAME' deleted."
	else
		echo "Error: Failed to delete '$VM_NAME'. It may not exist or have been corrupted."
		return 1  # Exit the function with a non-zero status
	fi
}

# Function to rebuild the VM
rebuild_vm() {
	echo "Rebuilding virtual machine '$VM_NAME'..."
	delete_vm
	create_vm
}

# Script usage instructions
usage() {
	echo "Usage: $0 {create|rebuild|delete}"
	echo "  create  - Create a new VM from OVA or start existing VM"
	echo "  rebuild - Rebuild the VM from OVA"
	echo "  delete  - Delete the VM"
}

# Main script logic
detect_vboxmanage

case "$1" in
	create)
		create_vm
		;;
	rebuild)
		rebuild_vm
		;;
	delete)
		delete_vm
		;;
	*)
		usage
		exit 1
		;;
esac
