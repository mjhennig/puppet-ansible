# vi: set fenc=utf-8 ft=ruby ts=8 sw=2 sts=2 et:
# coding: utf-8

# https://en.wikipedia.org/wiki/Vagrant_(software)
require 'vagrant'

# https://www.vagrantup.com/docs/vagrantfile/version.html
VAGRANT_API_VERSION = '2'

# All Vagrant configuration is done here. The most common configuration
# options are documented and commented below. For a complete reference,
# please see the online documentation at: https://www.vagrantup.com/
Vagrant.configure(VAGRANT_API_VERSION) do |vagrant|

  # https://www.debian.org/releases/jessie/
  vagrant.vm.define('jessie') do |config|
    config.vm.box = 'debian/contrib-jessie64'
    config.vm.hostname = 'jessie.test'
    config.vm.post_up_message = nil
    config.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'playbook.yml'
      ansible.verbose = true
    end
  end

  # https://www.debian.org/releases/stretch/
  vagrant.vm.define('stretch') do |config|
    config.vm.box = 'debian/stretch64'
    config.vm.hostname = 'stretch.test'
    config.vm.post_up_message = nil
    config.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'playbook.yml'
      ansible.verbose = true
    end
  end

  # http://releases.ubuntu.com/16.04/
  vagrant.vm.define('xenial') do |config|
    config.vm.box = 'ubuntu/xenial64'
    config.vm.hostname = 'xenial.test'
    config.vm.provision 'shell', inline: <<-end
      which python >/dev/null \
      || apt-get -y update \
      && apt-get -y install python
    end
    config.vm.provision 'ansible' do |ansible|
      ansible.playbook = 'playbook.yml'
      ansible.verbose = true
    end
  end

end
