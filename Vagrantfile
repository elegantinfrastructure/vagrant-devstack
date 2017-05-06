# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Base box

  config.vm.box = "devstack-ocata"

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

  # Forward OS ports

  [35357, 5000, 8774, 8776, 9696, 9191, 9292, 6080, 8080].each do |port|
    config.vm.network "forwarded_port", guest: port, host: port, protocol: 'tcp'
  end

  # Ubuntu base box uses non-standard username

  config.ssh.username = "ubuntu"

end
