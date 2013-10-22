Vagrant.configure("2") do |config|
  ## Choose your base box
  config.vm.box = "precise64"

  # maintain /etc/hosts on the host, requires https://github.com/smdahlen/vagrant-hostmanager
  # config.hostmanager.manage_host = true

  # maintain /etc/hosts in each guest, requires https://github.com/smdahlen/vagrant-hostmanager
  config.hostmanager.enabled = true
  config.vm.provision :hostmanager

  ## For masterless, mount your salt file root
  config.vm.synced_folder ".", "/srv/salt/"
  config.vm.synced_folder "vagrant/pillar", "/srv/pillar/"

  ## Use all the defaults:
  config.vm.provision :salt do |salt|
    salt.verbose = true

    salt.minion_config = "vagrant/minion"

    # pillar data is in vagrant/pillar/top.sls|elasticsearch.sls

    salt.run_highstate = true
  end

  config.vm.define "es01" do |box|
    box.vm.hostname = "es01"
    box.vm.network :private_network, ip: "192.168.35.31"
    box.vm.network "forwarded_port", guest: 9201, host: 9200
  end

  config.vm.define "es02" do |box|
    box.vm.hostname = "es02"
    box.vm.network :private_network, ip: "192.168.35.32"
    box.vm.network "forwarded_port", guest: 9202, host: 9200
  end

end
