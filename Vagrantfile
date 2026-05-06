# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

# Load user configuration (copy config.example.yaml → config.yaml and edit it).
settings = {}
if File.exist?(File.join(__dir__, "config.yaml"))
  settings = YAML.load_file(File.join(__dir__, "config.yaml"))
end

vm_cfg      = settings.fetch("vm", {})
cpus        = vm_cfg.fetch("cpus", 2)
memory      = vm_cfg.fetch("memory", 2048)
hostname    = vm_cfg.fetch("hostname", "ubuntu-vagrant")
ip          = vm_cfg.fetch("ip", "192.168.56.10")

synced_folders = settings.fetch("synced_folders", [])

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-24.04"
  config.vm.hostname = hostname
  config.ssh.forward_agent = true

  config.vm.provider "virtualbox" do |vb|
    vb.name = hostname
    vb.cpus = cpus
    vb.memory = memory
    vb.gui = false
  end

  config.vm.network "private_network", ip: ip

  synced_folders.each do |folder|
    config.vm.synced_folder folder["host_path"], folder["guest_path"]
  end

  config.vm.provision "shell", path: "provision.sh"
end
