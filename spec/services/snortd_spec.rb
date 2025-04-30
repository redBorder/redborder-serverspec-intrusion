# frozen_string_literal: true

require 'spec_helper'
require 'json'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

service = 'snortd'
packages = %w[
  snort
]

describe "Checking packages for #{service}..." do
  packages.each do |package|
    describe package(package) do
      it 'is expected to be installed' do
        expect(package(package).installed?).to be true
      end
    end
  end
end

# TODO: refactor
# Checking if the service is running has been omitted and is marked to be addressed in a future task,
# as it requires running snort/initd for verification.
# describe "Checking service_status service for #{service}..." do
#   describe service(service) do
#     it { should be_enabled }
#     skip 'You have to run snort/initd to check this. It needs to be solved in a task'
#     # it { should be_running }
#   end
# end
