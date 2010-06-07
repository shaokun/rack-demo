require 'lib/hello_world.rb'
require 'lib/response_timer.rb'

use ResponseTimer
#use ResponseTimer, "load time"

run HelloWorld.new