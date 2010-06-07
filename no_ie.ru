require 'lib/hello_world.rb'
require 'lib/no_ie.rb'

use Rack::NoIE, :redirect => '/noieplease.html'
use Rack::Static, :urls => ["/noieplease.html"], :root => "public"
run HelloWorld.new
