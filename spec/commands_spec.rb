# frozen_string_literal: true

require 'spec_helper'

describe 'commands' do
  image = 'geth-aws:latest'
  extra = {
    'Entrypoint' => '/bin/sh'
  }

  before(:all) do
    set :backend, :docker
    set :docker_image, image
    set :docker_container_create_options, extra
  end

  after(:all, &:reset_docker_backend)

  it 'includes the geth command' do
    expect(command('/opt/geth/bin/geth version').stdout)
      .to(match(/1.9.25/))
  end

  def reset_docker_backend
    Specinfra::Backend::Docker.instance.send :cleanup_container
    Specinfra::Backend::Docker.clear
  end
end
