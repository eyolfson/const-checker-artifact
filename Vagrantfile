Vagrant.configure("2") do |config|
  config.vm.box = "archlinux/archlinux"
  config.vm.box_version = "=2019.01.05"
  config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 4
    vb.memory = 4096
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.provision :shell do |shell|
    shell.path = 'provision.sh'
  end
end
