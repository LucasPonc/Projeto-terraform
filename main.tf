terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "ubuntu_base" {
  name   = "ubuntu-base.qcow2"
  pool   = "default"
  source = "focal-server-cloudimg-amd64.img"
  format = "qcow2"
}

resource "libvirt_volume" "ubuntu_vm1" {
  name           = "ubuntu-vm1.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  pool           = "default"
  format         = "qcow2"
}

resource "libvirt_volume" "ubuntu_vm2" {
  name           = "ubuntu-vm2.qcow2"
  base_volume_id = libvirt_volume.ubuntu_base.id
  pool           = "default"
  format         = "qcow2"
}

data "template_file" "user_data_vm1" {
  template = file("${path.module}/cloudinit/vm1.yaml")
}

resource "libvirt_cloudinit_disk" "cloudinit_vm1" {
  name      = "cloudinit-vm1.iso"
  pool      = "default"
  user_data = data.template_file.user_data_vm1.rendered
}

data "template_file" "user_data_vm2" {
  template = file("${path.module}/cloudinit/vm2.yaml")
}

resource "libvirt_cloudinit_disk" "cloudinit_vm2" {
  name      = "cloudinit-vm2.iso"
  pool      = "default"
  user_data = data.template_file.user_data_vm2.rendered
}

resource "libvirt_domain" "vm1" {
  name   = "vm1"
  memory = 1024
  vcpu   = 1

  disk {
    volume_id = libvirt_volume.ubuntu_vm1.id
  }

  network_interface {
    network_name = "custom-net"
    mac          = "52:54:00:00:00:10"
  }

  console {
    type        = "pty"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit_vm1.id
}

resource "libvirt_domain" "vm2" {
  name   = "vm2"
  memory = 1024
  vcpu   = 1

  disk {
    volume_id = libvirt_volume.ubuntu_vm2.id
  }

  network_interface {
    network_name = "custom-net"
  }

  console {
    type        = "pty"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "none"
  }

  cloudinit = libvirt_cloudinit_disk.cloudinit_vm2.id
}
