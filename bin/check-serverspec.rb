#! /usr/bin/env ruby
#
#   check-serverspec
#
# DESCRIPTION:
#   Runs http://serverspec.org/ spec tests against your servers.
#   Fails with a critical if tests are failing.
#
# OUTPUT:
#   plain text
#
# PLATFORMS:
#   Linux
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: serverspec
#
# USAGE:
#   Run entire suite of testd
#   check-serverspec -d /etc/my_tests_dir
#
#   Run only one set of tests
#   check-serverspec -d /etc/my_tests_dir -t spec/test_one
#
# NOTES:
#   Does it behave differently on specific platforms, specific use cases, etc
#
# LICENSE:
#   Copyright 2014 Sonian, Inc. and contributors. <support@sensuapp.org>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'json'
require 'socket'
require 'serverspec'
require 'sensu-plugin/check/cli'

#
#
#
class CheckServerspec < Sensu::Plugin::Check::CLI
  option :tests_dir,
         short: '-d /tmp/dir',
         long: '--tests-dir /tmp/dir',
         required: true

  option :spec_tests,
         short: '-t spec/test',
         long: '--spec-tests spec/test',
         default: nil

  option :handler,
         short: '-l HANDLER',
         long: '--handler HANDLER',
         default: 'default'

  option :index_results,
         description: 'Append extra index value to rspec results',
         long: '--index-results',
         default: false

  def sensu_client_socket(msg)
    u = UDPSocket.new
    u.send(msg + "\n", 0, '127.0.0.1', 3030)
  end

  # http://stackoverflow.com/questions/11784109/detecting-operating-systems-in-ruby
  def os
    @os ||= (
      host_os = RbConfig::CONFIG['host_os']
      case host_os
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        :windows
      when /darwin|mac os/
        :macosx
      when /linux/
        :linux
      when /solaris|bsd/
        :unix
      else
        raise NotImplementedError, "unknown os: #{host_os.inspect}"
      end
    )
  end

  def send_ok(check_name, msg)
    d = { 'name' => check_name, 'status' => 0, 'output' => 'OK: ' + msg, 'handler' => config[:handler] }
    sensu_client_socket d.to_json
  end

  def send_warning(check_name, msg)
    d = { 'name' => check_name, 'status' => 1, 'output' => 'WARNING: ' + msg, 'handler' => config[:handler] }
    sensu_client_socket d.to_json
  end

  def send_critical(check_name, msg)
    d = { 'name' => check_name, 'status' => 2, 'output' => 'CRITICAL: ' + msg, 'handler' => config[:handler] }
    sensu_client_socket d.to_json
  end

  def run
    operating_system = os
    # require fully qualified path as embedded ruby may not be on the system path
    ruby_exec = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name']).sub(/.*\s.*/m, '"\&"')
    # requires for '-S' option to search for scripts
    ENV['RUBYPATH'] = RbConfig::CONFIG['bindir']
    if operating_system == (:linux || :macosx || :unix)
      serverspec_results = `cd #{config[:tests_dir]} ; #{ruby_exec} -S rspec #{config[:spec_tests]} --format json`
    elsif operating_system == :windows
      serverspec_results = `cd #{config[:tests_dir]} & #{ruby_exec} -S rspec #{config[:spec_tests]} --format json`
    end
    parsed = JSON.parse(serverspec_results)

    parsed['examples'].each_with_index do |serverspec_test, index|
      test_name = case config[:index_results]
                  when true
                    serverspec_test['file_path'].split('/')[-1] + '_' + serverspec_test['line_number'].to_s + '_' + index.to_s
                  else
                    serverspec_test['file_path'].split('/')[-1] + '_' + serverspec_test['line_number'].to_s
      output = serverspec_test['full_description'].delete!('"')

      if serverspec_test['status'] == 'passed'
        send_ok(
          test_name,
          output
        )
      else
        send_warning(
          test_name,
          output
        )
      end
    end

    puts parsed['summary_line']
    failures = parsed['summary_line'].split[2]
    if failures != '0'
      exit_with(
        :critical,
        parsed['summary_line']
      )
    else
      exit_with(
        :ok,
        parsed['summary_line']
      )
    end
  end

  def exit_with(sym, message)
    case sym
    when :ok
      ok message
    when :critical
      critical message
    else
      unknown message
    end
  end
end
