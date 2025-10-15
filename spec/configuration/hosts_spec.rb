#!/usr/bin/env ruby
# frozen_string_literal: true

require 'spec_helper'

describe 'Check for duplicate IPs in /etc/hosts' do
  describe command("awk '{print $1}' /etc/hosts | sort | uniq -d | wc -l") do
    its(:stdout) { should match(/^0$/) }
  end
end

describe 'Default values of /etc/hosts' do
  describe file('/etc/hosts') do
    it { should exist }
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }

    # Self conscience of localhost
    its(:content) { should match(/127.0.0.1\s+localhost/) }
    its(:content) { should match(/::1\s+localhost/) }
  end
end

describe 'Self awareness of the hostname' do
  hostname = command('hostname').stdout.strip
  describe file('/etc/hosts') do
    before do
      skip('Node is not registered yet, skipping...') unless hostname != 'localhost'
    end
    remote_ip_regex = /^(?!127\.0\.0\.1)(?!::1).*/
    its(:content) { should match(/#{remote_ip_regex}\s+#{hostname}\.node\s*/) }
  end
end

describe 'Services defined in the registered manager' do
  describe file('/etc/hosts') do
    before do
      skip 'Cdomain not defined in /etc/redborder/cdomain' unless file('/etc/redborder/cdomain').exists?
    end
    it 'Checks DNS resolution from right domain' do
      hosts_content = subject.content
      # Find first no localhost line
      line = hosts_content.lines.find do |l|
        l_ip = l.split.first
        l_ip && !['127.0.0.1', '::1'].include?(l_ip) && !l.strip.start_with?('#')
      end
      skip 'No line with a dynamic IP found. Maybe the IPS is not registered yet.' unless line

      cdomain = file('/etc/redborder/cdomain').content.strip

      [
        "http2k.service.#{cdomain}",
        "erchef.service.#{cdomain}",
        "s3.service.#{cdomain}",
        "f2k.service.#{cdomain}",
        "kafka.service.#{cdomain}"
      ].each do |name|
        expect(line).to include(name)
      end
    end
  end
end
