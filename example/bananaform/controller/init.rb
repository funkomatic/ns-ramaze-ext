

class Controller < Ramaze::Controller
  engine :Erubis
  layout :default
  helper :xhtml
end

# Here go your requires for subclasses of Controller:
require __DIR__('main')
require __DIR__('bananas')
