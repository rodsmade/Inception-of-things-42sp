# Inception-of-things-42sp
Study on Kubernetes delivered to you by means of Vagrant, K3s, K3d and ArgoCD

## host-vm-manage.sh

This script allows you to create, rebuild, and delete an Ubuntu virtual machine using `VBoxManage` to host the project. It automates the process of setting up a virtual machine with specified resources, attaching an Ubuntu ISO, and managing the VM lifecycle.

## Requirements

- [VirtualBox](https://www.virtualbox.org/) installed and configured.
- A valid Ubuntu ISO file.

## Usage

```bash
./host-vm-manage.sh {create|rebuild|delete} [ISO_PATH]
```

### Commands

- `create [ISO_PATH]`: Creates a new virtual machine. Requires the path to the Ubuntu ISO.
- `rebuild [ISO_PATH]`: Deletes the existing VM (if any) and creates a new one using the specified ISO.
- `delete`: Deletes the existing virtual machine.

### Examples

#### Create a VM

To create a new virtual machine using the specified ISO:

```bash
./host-vm-manage.sh create /path/to/ubuntu.iso
```

This will:
- Create a new VM named `UbuntuVM` with the default settings (2GB RAM, 10GB HDD, 2 CPU cores).
- Attach the specified Ubuntu ISO.
- Start the VM.

#### Rebuild a VM

To delete the current VM (if it exists) and create a new one:

```bash
./host-vm-manage.sh rebuild /path/to/ubuntu.iso
```

This will:
- Power off and delete the existing VM.
- Create a new VM using the specified ISO.
- Start the VM.

#### Delete a VM

To delete the virtual machine:

```bash
./host-vm-manage.sh delete
```

This will:
- Power off the VM (if it’s running).
- Unregister and delete the VM along with all associated files.

## Customizable Parameters

You can modify the script variables to customize the VM's specifications:

- `VM_NAME`: The name of the virtual machine (default: `UbuntuVM`).
- `HDD_SIZE`: The size of the virtual hard disk in MB (default: 20000 for 20GB).
- `RAM_SIZE`: The amount of RAM allocated to the VM in MB (default: 2048 for 2GB).
- `CPUS`: The number of CPU cores allocated to the VM (default: 2 cores).
- `VRAM_SIZE`: The amount of video memory in MB (default: 128MB).

## Notes

- Ensure that the path to the Ubuntu ISO file is correct and that the ISO exists on your system.
- If the VM already exists, the script will exit when using the `create` command unless you opt to `rebuild` the VM.
