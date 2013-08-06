#!/usr/bin/env rake
require 'bundler'
Bundler::GemHelper.install_tasks

Rake::TestTask.new do |t|
  t.libs << 'lib/ApiWrapperFor8x8'
  t.test_files = FileList['spec/lib/ApiWrapperFor8x8/*_test.rb']
  t.verbose = true
end

task :default => :test
