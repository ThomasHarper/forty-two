# -*- encoding : utf-8 -*-

Vagrant::Config.run do |config|
  config.vm.box = 'precise32'
  config.vm.box_url = 'http://files.vagrantup.com/precise32.box'
  config.vm.host_name = 'ker-o-zen'

  # Forward port to access web server from local machine
  config.vm.forward_port 5000, 5001

  # Increase virtual machine memory
  config.vm.customize ["modifyvm", :id, "--memory", 1024]

  # Enable NFS for shared folder. Purpose is to increase performances
  # Warning : disable this configuration if running your VM under Windows
  # Prerequesite : The host machine must have nfsd installed, the NFS server daemon.
  # This comes pre-installed on Mac OS X 10.5+ (Leopard and higher), and is typically a simple package install away on Linux systems.
  config.vm.network :hostonly, "100.0.0.2"
  config.vm.share_folder("v-root", "/vagrant", ".", :nfs => true)

  # Configure puppet provisionning
  config.vm.provision :puppet,
    :manifests_path => 'puppet/manifests',
    :module_path => 'puppet/modules'
end