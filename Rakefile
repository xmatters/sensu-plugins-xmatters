require 'bundler/gem_tasks'
require 'github/markup'
require 'redcarpet'
require 'rspec'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'yard'
require 'yard/rake/yardoc_task'
require 'colorize'

args = [:spec, :make_bin_executable, :yard, :rubocop, :check_binstubs]

YARD::Rake::YardocTask.new do |t|
  OTHER_PATHS = %w().freeze
  t.files = ['lib/**/*.rb', 'bin/**/*.rb', OTHER_PATHS]
  t.options = %w(--markup-provider=redcarpet --markup=markdown
                 --main=README.md)
end

RuboCop::RakeTask.new(:rubocop)

RSpec::Core::RakeTask.new(:spec)

desc 'Make all plugins executable'
task :make_bin_executable do
  puts "make plugins executable\n\n"
  `chmod -R +x bin/*`
end

desc 'Test for binstubs'
task :check_binstubs do
  puts "\nTest for binstubs"
  spec = Gem::Specification.load('sensu-plugins-xmatters.gemspec')
  bin_list = spec.executables
  bin_list.each do |b|
    `which #{ b }`
    unless $CHILD_STATUS.success?
      puts "#{b} was not a binstub"
      exit
    end
  end
  puts "binstub check passes\n".green
end

task default: args
