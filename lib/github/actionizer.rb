#!/usr/bin/env ruby

require 'erb'
require 'optparse'
require 'tempfile'
require 'yaml'

module Github
  class Actionizer
    VERSION = "0.0.2"
    HELP_DIALOG = <<-EOHELP
\nGithub Actionizer - The missing wrapper around Github Actions.
Usage: github-actionizer [OPTIONS]

  OPTIONS
    build   : Build the base image (automatically ran with start)
    logs    : Prints logs
    start   : Start the service
    stop    : Stop the service
    version : Current version of this gem

  CONFIGURATION
    By default, the configuration file is located at `~/actionizer.yaml`. This can be
    overwritten by using using the `--config-path` parameter

    EXAMPLE
      access_token: <github_access_token>
      services:
        <service_name>:
          repo: <github_user>/<repo_name>
          replicas: <number_of_instances>
          labels: <optional: comma_seperated_string_of_labels>
          cpu_limit: <optional: cpu_limit>
          cpu_reservation: <optional: minimum_cpu_reservation>
          memory_limit: <optional: memory_limit>
          memory_reservation: <optional: minimum_memory_reservation>
    EOHELP

    class << self
      def perform(command:, sub_command:, config_path:)
        @command = command
        @sub_command = sub_command
        @config_path = config_path
        @access_token = config['access_token']

        case command
        when "build"
          run_command("build base #{sub_command}")
        when "start"
          run_command("build base")
          run_command("up #{sub_command}")
        when "stop"
          run_command("down --remove-orphans")
        when "logs"
          run_command("logs #{sub_command}")
        when "help"
          help_and_exit
        when "version"
          puts "v#{Github::Actionizer::VERSION}"
        else
          puts "Invalid command given"
          help_and_exit(status: 1)
        end
      end

      def run_command(command)
        full_command = "ACCESS_TOKEN=#{config["access_token"]} docker-compose -p gitub_actionizer -f \"#{compose_file.path}\" #{command}"

        begin
          IO.popen(full_command) do |io|
            while (line = io.gets) do
              puts line
            end
          end
        rescue Interrupt
          # nothing to do, task was exited
        end
      end

      def config
        @config ||= begin
                      YAML.load_file(@config_path)
                    rescue
                      puts "Missing configuration"
                      help_and_exit(status: 1)
                    end
      end

      def docker_dir
        @docker_dir ||= "#{File.dirname(__dir__)}/../docker"
      end

      def compose_file
        @compose_file ||= begin
                            results = ERB.new(File.read("#{docker_dir}/docker-compose.yaml.erb")).result_with_hash(
                              docker_dir: docker_dir,
                              platform: config["platform"],
                              runner_version: config["runner_version"],
                              services: config["services"]
                            )

                            compose_file = Tempfile.new("#{docker_dir}/docker-compose.yaml", Dir.pwd)
                            compose_file.write(results)
                            compose_file.flush
                            compose_file.close
                            compose_file
                          end
      end

      def help_and_exit(status: 0)
        print HELP_DIALOG
        exit(status)
      end
    end
  end
end

