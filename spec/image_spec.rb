require 'spec_helper'

describe 'image' do
  image = 'geth-aws:latest'
  extra = {
      'Entrypoint' => '/bin/sh',
  }

  before(:all) do
    set :backend, :docker
    set :docker_image, image
    set :docker_container_create_options, extra
  end

  after(:all, &:reset_docker_backend)

  it 'puts the geth user in the geth group' do
    expect(user('geth'))
        .to(belong_to_primary_group('geth'))
  end

  it 'has the correct ownership on the geth directory' do
    expect(file('/opt/geth')).to(be_owned_by('geth'))
    expect(file('/opt/geth')).to(be_grouped_into('geth'))
  end

  it 'has the correct ownership on the geth data directory' do
    expect(file('/var/opt/geth')).to(be_owned_by('geth'))
    expect(file('/var/opt/geth')).to(be_grouped_into('geth'))
  end

  def reset_docker_backend
    Specinfra::Backend::Docker.instance.send :cleanup_container
    Specinfra::Backend::Docker.clear
  end
end