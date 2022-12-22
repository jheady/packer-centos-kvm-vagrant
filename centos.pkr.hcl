packer {

    required_plugins {
        qemu = {
            source = "github.com/hashicorp/qemu"
            version = ">= 1.0.0"
        }
    }
}

variable "system" {
    default = "packer-centos-kvm"
}

variable "name" {
    default = "vagrant"
}

variable "user" {
    default = env("USER")
}

source "qemu" "centos" {
    accelerator = "kvm"
    boot_wait = "5s"
    http_directory = "http"
    cpus = 2
    disk_size = "10G"
    format = "qcow2"
    headless = true
    output_directory = "output"
    memory = 4096
    net_device = "virtio-net"
    ssh_username = var.name
    ssh_password = var.name
    ssh_timeout = "30m"
    iso_url = "/home/${var.user}/isoImages/CentOS-7-x86_64-Minimal-2207-02.iso"
    iso_checksum = "sha256:d68f92f41ab008f94bd89ec4e2403920538c19a7b35b731e770ce24d66be129a"
    vm_name = var.system
    boot_command = [
        "<esc><wait>linux ks=http://{{.HTTPIP}}:{{.HTTPPort}}/ks.cfg<enter><wait5>"
    ]
}

build {
    sources = [
        "source.qemu.centos"
    ]

    post-processor "vagrant" {
        compression_level = 6
        vagrantfile_template = "${path.root}/vagrant.rb.j2"
        output               = "${path.root}/${var.system}.box"
    }
}