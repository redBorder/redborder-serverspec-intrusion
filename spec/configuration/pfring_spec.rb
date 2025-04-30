# frozen_string_literal: true

require 'set'
require 'spec_helper'
set :os, family: 'redhat', release: '9', arch: 'x86_64'

packages = Set.new(%w[pfring pfring-dkms])

describe 'Checking packages for pfring...' do
  packages.each do |package|
    describe package(package) do
      it 'is expected to be installed' do
        expect(package(package).installed?).to be true
      end
    end
  end
end
