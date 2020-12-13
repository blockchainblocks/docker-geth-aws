require 'spec_helper'

describe 'entrypoint' do
  metadata_service_url = 'http://metadata:1338'
  s3_endpoint_url = 'http://s3:4566'
  s3_bucket_region = 'us-east-1'
  s3_bucket_path = 's3://bucket'
  s3_env_file_object_path = 's3://bucket/env-file.env'

  environment = {
      'AWS_METADATA_SERVICE_URL' => metadata_service_url,
      'AWS_ACCESS_KEY_ID' => "...",
      'AWS_SECRET_ACCESS_KEY' => "...",
      'AWS_S3_ENDPOINT_URL' => s3_endpoint_url,
      'AWS_S3_BUCKET_REGION' => s3_bucket_region,
      'AWS_S3_ENV_FILE_OBJECT_PATH' => s3_env_file_object_path
  }
  image = 'geth-aws:latest'
  extra = {
      'Entrypoint' => '/bin/sh',
      'HostConfig' => {
          'NetworkMode' => 'docker_geth_aws_test_default'
      }
  }

  before(:all) do
    set :backend, :docker
    set :env, environment
    set :docker_image, image
    set :docker_container_create_options, extra
  end

  describe 'by default' do
    before(:all) do
      create_env_file(
          endpoint_url: s3_endpoint_url,
          region: s3_bucket_region,
          bucket_path: s3_bucket_path,
          object_path: s3_env_file_object_path)

      execute_docker_entrypoint(
          started_indicator: "New local node record")
    end

    after(:all, &:reset_docker_backend)

    it 'runs geth' do
      expect(process('/opt/geth/bin/geth')).to(be_running)
    end

    it 'uses a datadir of /var/opt/geth' do
      expect(process('/opt/geth/bin/geth').args)
          .to(match(/--datadir=\/var\/opt\/geth/))
    end

    it 'has no ancient datadir' do
      expect(process('/opt/geth/bin/geth').args)
          .not_to(match(/--datadir\.ancient/))
    end

    it 'has no keystore' do
      expect(process('/opt/geth/bin/geth').args)
          .not_to(match(/--keystore/))
    end

    it 'uses mainnet' do
      expect(process('/opt/geth/bin/geth').args)
          .not_to(match(/--goerli/))
      expect(process('/opt/geth/bin/geth').args)
          .not_to(match(/--rinkeby/))
      expect(process('/opt/geth/bin/geth').args)
          .not_to(match(/--yolov2/))
      expect(process('/opt/geth/bin/geth').args)
          .not_to(match(/--ropsten/))
    end

    it 'disables USB hardware wallets' do
      expect(process('/opt/geth/bin/geth').args)
          .to(match(/--nousb/))
    end
  end

  describe 'storage configuration' do
    before(:all) do
      create_env_file(
          endpoint_url: s3_endpoint_url,
          region: s3_bucket_region,
          bucket_path: s3_bucket_path,
          object_path: s3_env_file_object_path,
          env: {
              'GETH_DATADIR' => '/data',
              'GETH_DATADIR_ANCIENT' => '/data-ancient',
              'GETH_KEYSTORE' => '/keystore'
          })

      execute_command(
          'mkdir /data /data-ancient /keystore')
      execute_command(
          'chown -R geth:geth /data /data-ancient /keystore')

      execute_docker_entrypoint(
          started_indicator: "New local node record")
    end

    after(:all, &:reset_docker_backend)

    it 'uses the provided datadir' do
      expect(process('/opt/geth/bin/geth').args)
          .to(match(/--datadir=\/data/))
    end

    it 'uses the provided ancient datadir' do
      expect(process('/opt/geth/bin/geth').args)
          .to(match(/--datadir\.ancient=\/data-ancient/))
    end

    it 'uses the provided keystore' do
      expect(process('/opt/geth/bin/geth').args)
          .to(match(/--keystore=\/keystore/))
    end
  end

  describe 'network configuration' do
    describe 'for goerli' do
      before(:all) do
        create_env_file(
            endpoint_url: s3_endpoint_url,
            region: s3_bucket_region,
            bucket_path: s3_bucket_path,
            object_path: s3_env_file_object_path,
            env: {
                'GETH_NETWORK' => 'goerli'
            })

        execute_docker_entrypoint(
            started_indicator: "New local node record")
      end

      after(:all, &:reset_docker_backend)

      it 'uses the goerli network' do
        expect(process('/opt/geth/bin/geth').args)
            .to(match(/--goerli/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--rinkeby/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--yolov2/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--ropsten/))
      end
    end

    describe 'for rinkeby' do
      before(:all) do
        create_env_file(
            endpoint_url: s3_endpoint_url,
            region: s3_bucket_region,
            bucket_path: s3_bucket_path,
            object_path: s3_env_file_object_path,
            env: {
                'GETH_NETWORK' => 'rinkeby'
            })

        execute_docker_entrypoint(
            started_indicator: "New local node record")
      end

      after(:all, &:reset_docker_backend)

      it 'uses the rinkeby network' do
        expect(process('/opt/geth/bin/geth').args)
            .to(match(/--rinkeby/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--goerli/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--yolov2/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--ropsten/))
      end
    end

    describe 'for yolov2' do
      before(:all) do
        create_env_file(
            endpoint_url: s3_endpoint_url,
            region: s3_bucket_region,
            bucket_path: s3_bucket_path,
            object_path: s3_env_file_object_path,
            env: {
                'GETH_NETWORK' => 'yolov2'
            })

        execute_docker_entrypoint(
            started_indicator: "New local node record")
      end

      after(:all, &:reset_docker_backend)

      it 'uses the yolov2 network' do
        expect(process('/opt/geth/bin/geth').args)
            .to(match(/--yolov2/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--goerli/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--rinkeby/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--ropsten/))
      end
    end

    describe 'for ropsten' do
      before(:all) do
        create_env_file(
            endpoint_url: s3_endpoint_url,
            region: s3_bucket_region,
            bucket_path: s3_bucket_path,
            object_path: s3_env_file_object_path,
            env: {
                'GETH_NETWORK' => 'ropsten'
            })

        execute_docker_entrypoint(
            started_indicator: "New local node record")
      end

      after(:all, &:reset_docker_backend)

      it 'uses the ropsten network' do
        expect(process('/opt/geth/bin/geth').args)
            .to(match(/--ropsten/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--goerli/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--rinkeby/))
        expect(process('/opt/geth/bin/geth').args)
            .not_to(match(/--yolov2/))
      end
    end
  end

  def reset_docker_backend
    Specinfra::Backend::Docker.instance.send :cleanup_container
    Specinfra::Backend::Docker.clear
  end

  def create_env_file(opts)
    create_object(opts
        .merge(content: (opts[:env] || {})
            .to_a
            .collect { |item| " #{item[0]}=\"#{item[1]}\"" }
            .join("\n")))
  end

  def execute_command(command_string)
    command = command(command_string)
    exit_status = command.exit_status
    unless exit_status == 0
      raise RuntimeError,
          "\"#{command_string}\" failed with exit code: #{exit_status}"
    end
    command
  end

  def create_object(opts)
    execute_command('aws ' +
        "--endpoint-url #{opts[:endpoint_url]} " +
        's3 ' +
        'mb ' +
        "#{opts[:bucket_path]} " +
        "--region \"#{opts[:region]}\"")
    execute_command("echo -n #{Shellwords.escape(opts[:content])} | " +
        'aws ' +
        "--endpoint-url #{opts[:endpoint_url]} " +
        's3 ' +
        'cp ' +
        '- ' +
        "#{opts[:object_path]} " +
        "--region \"#{opts[:region]}\" " +
        '--sse AES256')
  end

  def execute_docker_entrypoint(opts)
    logfile_path = '/tmp/docker-entrypoint.log'
    args = (opts[:arguments] || []).join(' ')

    execute_command(
        "docker-entrypoint.sh #{args} > #{logfile_path} 2>&1 &")

    begin
      Octopoller.poll(timeout: 5) do
        docker_entrypoint_log = command("cat #{logfile_path}").stdout
        docker_entrypoint_log =~ /#{opts[:started_indicator]}/ ?
            docker_entrypoint_log :
            :re_poll
      end
    rescue Octopoller::TimeoutError => e
      puts command("cat #{logfile_path}").stdout
      raise e
    end
  end
end