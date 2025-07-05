terraform {
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.1"  # pode ajustar para a versão que quiser
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
#baixar imagem https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img
resource "libvirt_volume" "ubuntu-qcow2" {
  name   = "ubuntu-qcow2"
  pool   = "default"
  source = "focal-server-cloudimg-amd64.img"
  format = "qcow2"
}

data "template_file" "user_data_vm1" {
  template = file("${path.module}/cloud_init.cfg")
}

resource "libvirt_cloudinit_disk" "cloudinit_vm1" {
  name      = "cloudinit-vm1.iso"
  pool      = "default"
  user_data = data.template_file.user_data_vm1.rendered
}

resource "libvirt_domain" "vm1" {
  name   = "vm1"
  memory = 1024
  vcpu   = 1

  disk {
    volume_id = libvirt_volume.ubuntu-qcow2.id
  }

  network_interface {
    network_name = "default"
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
