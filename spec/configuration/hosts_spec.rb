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

hostname = `hostname`.strip
describe 'Self awareness of the hostname' do
  describe file('/etc/hosts') do
    # Check hostname entry
    its(:content) { should match(/^127\.0\.0\.1\s+#{hostname}\s+/) }
  end
end

# TODO: Check manager-node info is present in /etc/hosts after registration
