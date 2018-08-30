require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :run do
  system %Q{ruby -I "#{File.join(File.dirname(__FILE__), "lib")}" "#{File.join(File.dirname(__FILE__), "exe", "termquickrpg")}"}
end

task :default => :run
