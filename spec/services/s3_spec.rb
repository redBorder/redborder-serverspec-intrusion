# frozen_string_literal: true

require 'spec_helper'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

describe 'Checking if should be registered to s3 in the manager' do
  hostname = command('hostname').stdout.strip
  describe file('/etc/hosts') do
    before do
      skip('Node is not registered yet, skipping...') unless hostname != 'localhost'
    end
    remote_ip_regex = /^(?!127\.0\.0\.1)(?!::1).*/
    its(:content) { should match(/#{remote_ip_regex}\s+s3.service\s*/) }
  end
end
