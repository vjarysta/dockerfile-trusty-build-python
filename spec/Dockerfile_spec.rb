require 'docker'
require 'infopen-docker'
require 'serverspec'

describe 'Dockerfile' do

    # Build Dockerfile
    before(:all) do
        @image = Docker::Image.build_from_dir('.')

        set :os, family: :debian
        set :backend, :docker
        set :docker_image, @image.id
    end

    # Once tests done, remove image
    after(:all) do
        Infopen::Docker::Lifecycle.remove_image_and_its_containers(@image)
    end


    # Tests
    #------

    it 'installs the right version of Ubuntu' do
        expect(get_os_version()).to include('Ubuntu 14.04')
    end

    it 'installs ssh server package' do
        expect(package('openssh-server')).to be_installed
    end

    it 'runs ssh server service' do
        expect(service('sshd')).to be_running
        expect(process('sshd')).to be_running
        expect(port(22)).to be_listening.with('tcp')
    end

    it 'install base packages package' do
        expect(package('git')).to be_installed
        expect(package('openjdk-7-jdk')).to be_installed
    end

    describe command('java -version') do
        its(:stderr) { should match( /java version "1.7/) }
        its(:exit_status) { should eql 0 }
    end

    describe user('jenkins') do
        it { should exist }
        it { should have_home_directory '/home/jenkins' }
        it { should belong_to_group 'jenkins' }
        its(:encrypted_password) { should match(/^\$6\$.{8}\$.{86}$/) }
    end

    it 'install require packages to build .deb' do
        expect(package('build-essential')).to be_installed
        expect(package('cdbs')).to be_installed
        expect(package('curl')).to be_installed
        expect(package('debhelper')).to be_installed
        expect(package('debootstrap')).to be_installed
        expect(package('devscripts')).to be_installed
        expect(package('dh-make')).to be_installed
        expect(package('fakeroot')).to be_installed
        expect(package('lintian')).to be_installed
        expect(package('pbuilder')).to be_installed
    end

    describe user('build-user') do
        it { should exist }
        it { should have_home_directory '/home/build-user' }
        it { should belong_to_group 'build-user' }
        its(:encrypted_password) { should match(/^\$6\$.{8}\$.{86}$/) }
    end

    describe file('/usr/local/bin/gosu') do
        it { should be_file }
        it { should exist }
        it { should be_mode 4750 }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'jenkins' }
    end

    it 'install require packages to run python jobs' do
        expect(package('python3')).to be_installed
        expect(package('python-pip')).to be_installed
        expect(package('python-virtualenv')).to be_installed
        expect(package('libffi-dev')).to be_installed
        expect(package('libpython2.7-dev')).to be_installed
        expect(package('libpython3.4-dev')).to be_installed
        expect(package('libssl-dev')).to be_installed
        expect(package('libxml2-dev')).to be_installed
        expect(package('libxslt1-dev')).to be_installed
    end

    describe command('locale') do
        its(:stdout) { should match /LANG=en_US.UTF-8/ }
        its(:stdout) { should match /LC_ALL=en_US.UTF-8/ }
        its(:exit_status) { should eq 0 }
    end


    # Functions
    #----------

    # Get os version of container
    def get_os_version
        command('lsb_release -a').stdout
    end
end
