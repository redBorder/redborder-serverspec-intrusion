# frozen_string_literal: true

require 'spec_helper'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

describe user('snort') do
  it { should exist }
  it { should have_login_shell('/bin/false') }
  describe command('su - snort') do
    its('exit_status') { should eq 1 }
  end
end
