# Instructions for using this repo

Things need and steps to follow:
* A modern distribution of linux (Centos7+, Ubuntu 18.04+, RHEL7+, or derivatives of them)
* QEMU/KVM installed - Lots of tutorials on how to install this software around the internet. Specific instructions will vary from distro to distro.
* Packer installed - Easiest to add the repository for the host system's version of linux (ignore that the URL has docker in it).
	* https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli
* Vagrant installed - If the hashicorp repo was added in the previous step, this will be as easy as installing via the repo.
	* https://developer.hashicorp.com/vagrant/downloads
* Download the latest centos7 image from one of the available mirrors. Also grab the sha256sum of the file. It's recommended to use the minimal ISO image.
	* Mirror list - http://isoredirect.centos.org/centos/7/isos/x86_64/
* Clone the git repository
* Change iso_url and iso_checksum in the `centos.pkr.hcl` file as needed to match with the ones downloaded.
* cd into the repository and run `packer init`, this will download the most recent version of the qemu plugin. An empty response implies that the plugin is already present.
* Run `packer build centos.pkv.hcl` and wait. Alternatively, connect to the VNC port packer provides and watch the build.

In the repository are 3  main files for the build
* `centos.pkr.hcl` - This file is the core packer build file.
* `ks.cfg` - This is the kickstart file that allows packer to build the os unattended.
* `vagrant.rb.j2` - This is the base Vagrantfile that will be stored in the box image.

The full run took about 25-30 minutes from packer build command to vagrant box ready for usage on an Intel i5-7200 laptop.

Once the build has completed, a file name `packer-centos-kvm.box` will be in the build directory (unless the `var.system` variable is altered). Add the box to vagrant with `vagrant box add --name packer-centos-kvm packer-centos-kvm.box`. Change the name and box file as desired/needed. Then navigate to an empty directory and run `vagrant init packer-centos-kvm` (or use whatever the box was named when adding it). Edit the generated Vagrantfile to add the below somewhere before the `end` stanza at the bottom of the file and after the `config.vm.box` line at the top of the file.

	  config.vm.provider "libvirt" do |lv|
	    # Customize the amount of memory and CPUs on the VM:
	    lv.memory = "4096"
	    lv.cpus = "2"
	  end

This will ensure that the VM is brought up with 4g of ram, and 2 CPUs. Without, the system will have only 1 CPU, and 512M of ram.