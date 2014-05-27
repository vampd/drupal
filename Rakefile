# encoding: utf-8
require 'foodcritic'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'erb'
require 'ostruct'
require 'chef/cookbook/metadata'

# Provides a basic Readme class so we can use a erb template.
class Readme < OpenStruct
  def render(template)
    ERB.new(template).result(binding)
  end
end

# rubocop:disable AssignmentInCondition, MethodLength
def recipes(content = '')
  Dir.glob('spec/*_spec.rb').sort.each do |f|
    File.open(f, 'r') do |spec|
      while line = spec.gets
        recipe = line.match(/^describe.+['|"](\w+::\w+)/i)
        content << "### #{recipe[1]}\n" unless recipe.nil?
        describes = line.match(/ +it '([^']+)/)
        content << "    #{describes[1]}\n" unless describes.nil?
      end
    end
  end
  content
end

def attributes(content = '')
  File.open('attributes/default.rb', 'r') do |f|
    output = false
    while line = f.gets #
      output = true if line =~ /^###/
      if output
        content << "#{line}" if line =~ /^###/
        content << "    #{line}" unless line =~ /^###/
      end
    end
  end
  content
end
# rubocop:enable AssignmentInCondition, MethodLength

def rake_tasks
  documentation = ''
  s = `rake -T`.split("\n")
  s.each do |l|
    documentation << "    #{l}\n" if l =~ /^rake/
  end
  documentation
end

desc 'Run RuboCop style and lint checks'
Rubocop::RakeTask.new(:rubocop)

desc 'Run Foodcritic lint checks'
FoodCritic::Rake::LintTask.new(:foodcritic) do |t|
  t.options = { fail_tags: ['any'] }
end

desc 'Run ChefSpec examples'
RSpec::Core::RakeTask.new(:spec)

desc 'Generate the Readme.md file.'
task :readme do
  authors = `git shortlog -sn`.b.scan(/[^\d\s].*/).map do |a|
    a == 'Making GitHub Delicious.' ? nil : a
  end

  metadata = Chef::Cookbook::Metadata.new
  metadata.from_file('metadata.rb')
  markdown = Readme.new(
                        metadata: metadata,
                        attributes: attributes,
                        recipes: recipes,
                        rake_tasks: rake_tasks,
                        authors: authors)
  new_readme = markdown.render(File.read('templates/default/readme.md.erb'))
  File.open('README.md', 'w') { |file| file.write(new_readme) }
  puts new_readme
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
