run lambda { |env| [200, {"Content-Type"=>"text/html"}, ["Hello World by Lambda!"]] }

# require 'lib/hello_world.rb'
#run HelloWorld.new