require 'lib/hello_world.rb'
require 'lib/response_timer.rb'

use ResponseTimer

run HelloWorld.new