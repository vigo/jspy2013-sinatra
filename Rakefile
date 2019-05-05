require 'bundler/setup'

namespace :run do
  desc "Local sunucu (Shotgun)"
  task :shotgun do
    system "shotgun -o 0.0.0.0"
  end
  
  desc "Local sunucu (Rackup)"
  task :rackup do
    system "rackup -o 0.0.0.0"
  end
end