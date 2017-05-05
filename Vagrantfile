# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Base box

  config.vm.box = "ubuntu/xenial64"

  # VM configuration

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.customize ['modifyvm', :id, '--natnet1', '192.168.222.0/24']
  end

  # Take proxy configuration from environment, if present

  if Vagrant.has_plugin?("vagrant-proxyconf")
    config.proxy.http     = ENV['http_proxy']
    config.proxy.https    = ENV['https_proxy']
    config.proxy.no_proxy = "127.0.0.1,localhost,192.168.222.15,#ENV['no_proxy']"
  end 

  # Run provisioners

  environment = {}

  config.vm.provision "shell", path: "provision.sh", env: environment, privileged: false
  config.vm.provision "shell", path: "setup_basebox.sh"

end
