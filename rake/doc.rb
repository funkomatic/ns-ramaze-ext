require 'rake'
require 'rake/rdoctask'

namespace 'gems' do
  namespace GEM_NAME do
    Rake::RDocTask.new(:rdoc_dev) do |rd|
      #rd.main = "README.doc"
      rd.rdoc_files.include("lib/**/*.rb")
      rd.rdoc_dir="doc"
      rd.main ="Ramaze::Helper::RedFrom"
      #rd.options << "-diagram"
      rd.options << "--all"
    end
  end
end

## clean tasks
CLEAN.add(FileList["#{GEM_DOC_OUTPUT}/*"])
