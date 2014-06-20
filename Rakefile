# encoding: utf-8
require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'erb'
require 'ostruct'
require 'chef/cookbook/metadata'
require 'octokit'

# Provides a basic Readme class so we can use a erb template.
class Readme < OpenStruct
  def render(template)
    ERB.new(template).result(binding)
  end
end

desc 'Run RuboCop style and lint checks'
Rubocop::RakeTask.new(:rubocop)

desc 'Run Foodcritic lint checks'
FoodCritic::Rake::LintTask.new(:foodcritic)

description = 'Run ChefSpec examples. Specify OS to test either with rake '
description << '"spec[rhel]" (Redhat,centos etc) or rake "spec[ubuntu]". '
description << 'Defaults to both'
desc description
task :spec, :os do |os, args|
  os = args[:os]
  case os
  when 'rhel'
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = '--tag rhel'
    end
  when 'ubuntu'
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = '--tag ubuntu'
    end
  else
    puts "Unknown rspec operating system #{os}. Running all tests."
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.rspec_opts = '--tag rhel --tag ubuntu'
    end
  end
end

# TODO: this seriously needs to be refactored and cleaned up.
def credit # rubocop:disable MethodLength
  logs = `git log`.split('commit ')
  logs.shift

  authors = {}
  credit = {}

  logs.map do |log|
    l = log.split("\n")
    commit = l.shift
    author = l.shift.to_s.split('Author: ')[1]
    unless author.nil?
      if authors[author].nil?
        commit_detail = Octokit.commit('newmediadenver/nmdbase', commit)
        authors[author] = commit_detail[:author][:html_url]
        if credit[commit_detail[:author][:html_url]].nil?
          credit[commit_detail[:author][:html_url]] = {}
        end
        html_url = commit_detail[:author][:html_url]
        credit[html_url][author.split(' <')[0]] = author.split(' <')[1][0..-2]
      end
    end
  end
  credit.each do |key, names|
    clean_names = []
    names.each do |name, _email|
      clean_names.push(name)
    end
    credit[key] = clean_names.join(', ')
  end
  credit
end

desc 'Generate the Readme.md file.'
task :readme do
  metadata = Chef::Cookbook::Metadata.new
  metadata.from_file('metadata.rb')
  authors = credit
  markdown = Readme.new(
                        metadata: metadata,
                        attributes: attributes,
                        recipes: recipes,
                        rake_tasks: rake_tasks,
                        authors: authors)
  new_readme = markdown.render(File.read('templates/default/readme.md.erb'))
  File.open('README.md', 'w') { |file| file.write(new_readme) }
end

desc 'Run all tests'
task test: [:rubocop, :foodcritic, :spec]
task default: :test

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new

  desc 'Alias for kitchen:all'
  task integration: 'kitchen:all'

  task test: :integration
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end
