require 'rake'
require 'rspec/core/rake_task'

task :default => :spec

task :spec => "spec:all"
namespace :spec do
  host = ENV['TARGET_HOST'] || '10.0.209.31'

  task all: %i[services configuration users]

  desc 'run configuration tests'
  RSpec::Core::RakeTask.new(:configuration) do |t|
    puts "Running configuration tests on #{host} ..."
    t.pattern = "spec/configuration/*_spec.rb"
    t.rspec_opts = "--format documentation"  # O "--format progress"
  end

  desc 'run service tests'
  RSpec::Core::RakeTask.new(:services) do |t|
    puts "Running service tests on #{host} ..."
    t.pattern = "spec/services/*_spec.rb"
    t.rspec_opts = "--format documentation"  # O "--format progress"
  end

  desc 'run user tests'
  RSpec::Core::RakeTask.new(:users) do |t|
    puts "Running user tests on #{host} ..."
    t.pattern = 'spec/users/*_spec.rb'
    t.rspec_opts = '--format documentation'  # O "--format progress"
  end
end