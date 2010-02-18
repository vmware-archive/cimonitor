# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

module Rake
  module TaskManager
    def clean_task(name)
      @tasks[name] = nil
    end
  end
end

Rake.application.options.trace = true

Rails::Application.load_tasks
