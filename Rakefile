require 'rubygems'
require 'rake'
require 'echoe'
#require 'ns-gems-devtools'
require 'spec/rake/spectask'
require 'rake/rake.rb'

namespace 'gems' do
  namespace GEM_NAME do
      #include NS::Build::GemSpecConstants
      Echoe.new(GEM_NAME) do |p|
        p.description    = GEM_DESC
        p.url            = GEM_URL
        p.author         = GEM_AUTHOR
        p.email          = GEM_EMAIL
        p.ignore_pattern = GEM_IGNORE
        p.development_dependencies = GEM_DEV_DEPENDS_ON
        p.runtime_dependencies = GEM_RT_DEPENDS_ON
      end
    end
end

CLEAN.add(FileList["pkg/**/*"])


desc 'dev shortucut for reinstall'
task :reinstall => [ "gems:#{GEM_NAME}:install"]

desc "dev shortcut for running all the tests"
task :tests => [ "gems:#{GEM_NAME}:tests:banana-form" ]

desc "dev shortcut for creating gem doc"
task :doc => [ "gems:#{GEM_NAME}:doc" ]


desc 'clean all'
task :clean 



