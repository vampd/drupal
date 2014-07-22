# encoding: utf-8

namespace :utility do
  begin
    require 'drud'
    desc 'Generate the Readme.md file.'
    task :readme do
      drud = Drud::Readme.new(File.dirname(__FILE__))
      drud.render
    end
  rescue LoadError
    puts '>>>>> Drud gem not loaded, omitting tasks' unless ENV['CI']
  end
end

namespace :style do
  begin
    require 'rubocop/rake_task'
    desc 'Run Ruby style checks'
    RuboCop::RakeTask.new(:ruby)
  rescue LoadError
    puts '>>>>> Rubocop gem not loaded, omitting tasks' unless ENV['CI']
  end

  begin
    require 'foodcritic'
    desc 'Run Chef style checks'
    FoodCritic::Rake::LintTask.new(:chef) do |t|
      t.options = {
        fail_tags: ['any']
      }
    end
  rescue LoadError
    puts '>>>>> foodcritic gem not loaded, omitting tasks' unless ENV['CI']
  end

  begin
    require 'rspec/core/rake_task'
    desc 'Run rspec tests.'
    RSpec::Core::RakeTask.new(:spec)
  rescue LoadError
    puts '>>>>> rspec gem not loaded, omitting tasks' unless ENV['CI']
  end
end

# Integration tests. Kitchen.ci
namespace :integration do
  begin
    require 'kitchen/rake_tasks'

    desc 'Run kitchen integration tests'
    Kitchen::RakeTasks.new
  rescue LoadError
    puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
  end
end

desc 'Run all style checks'
task style: ['style:chef', 'style:ruby', 'style:spec']

desc 'Generate README.md'
task readme: ['utility:readme']

desc 'Run rspec tests.'
task spec: ['style:spec']

desc 'Run all tests on Travis'
task travis: ['style']

# Default
task default: ['style', 'integration:kitchen:all']
