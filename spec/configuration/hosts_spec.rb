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

# THIS TEST ONLY PASSES IF REGISTERED
describe 'Self awareness of the hostname' do
  hostname = command('hostname').stdout.strip
  describe file('/etc/hosts') do
  # Check hostname entry
    # its(:content) { should match(/^127\.0\.0\.1\s+#{hostname}\s+/) }
    before do
      skip('Node is not registered yet, skipping...') unless hostname != 'localhost'
    end
    its(:content) { should match(/^(?!127\.0\.0\.1)(?!::1).*\s+#{hostname}\.node\s*/) }
  end
end
