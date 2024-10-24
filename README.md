# Inception-of-things-42sp
Study on Kubernetes delivered to you by means of Vagrant and Kubernetes.

## Table of Contents
1. [Introduction](#introduction)
2. [Requirements](#requirements)
3. [Installation](#installation)
4. [Usage](#usage)
5. [Contributing](#contributing)
6. [Exercises](#exercises)

# Introduction
This project consists of a series of exercises in virtualization with increasing complexity. There are 3 exercises in total, and they are meant to be implemented inside a Virtual Machine using **Vagrant** and **Kubernetes**.

In this project we need to start virtual machines, create kubernetes clusters, deploy applications (sometimes with replicas) in these clusters and interact with the internet outside the VM. All sources of dependencies or configurations are pulled from external repositories such as **Dockerhub** and **Github**, and run on Kubernetes clusters set up either by Kubernetes itself or its lightweight flavours: **K3s** and **K3d**.

> **Vagrant** is an open-source tool that helps you create and manage virtualized development environments. It simplifies the setup process by providing a consistent environment across different machines, making it easier to share your development environment with team members.

> **Kubernetes** is a powerful container orchestration platform that automates the deployment, scaling, and management of containerized applications. It allows you to manage applications running in a distributed environment and provides features for load balancing, service discovery, and scaling.

> **K3s** is a lightweight Kubernetes distribution designed for resource-constrained environments and edge computing, simplifying the deployment of Kubernetes clusters.

> K3d is a utility for running K3s in Docker, enabling the quick creation and management of K3s clusters in local development environments.

### Exercises
The following exercises take place inside one hosting Virtual Machine:
- ex00 - set up 2 VMs (managed by Vagrant), both with K3s installed (each in different modes: controller and agent).
- ex01 - 1 VM (managed by Vagrant), K3s installed (server mode). Inside K3s, there must be 3 web applications, one of which must have 3 replicas.
- ex02 - install Docker and K3d on the host VM, setup a Kubernetes cluster and deploy ArgoCD watching an external Github repo configurations and pulling from a Dockerhub image to deploy an application inside the cluster.

# Installation
As mentioned, this project runs inside a Virtual Machine. In order to see project running (or even implement your own!), you will need to install a VM under certain specifications to make sure this project behaves the same across multiple OS's and deployment contexts. Bellow we provide a guide for setting up said VM in the bat of an eye.

# Requirements

- [VirtualBox](https://www.virtualbox.org/) installed and configured.
- A valid Ubuntu ISO file. **[TBD]**

## host-vm-manage.sh

This script allows you to create, rebuild, and delete an Ubuntu virtual machine using `VBoxManage` (VirtualBox's CLI), to host the project. It automates the process of setting up a virtual machine with specified resources, attaching an Ubuntu ISO, and managing the VM lifecycle.

# Usage

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
