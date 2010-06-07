require 'lib/karma_chameleon.rb'

app = lambda do |env|
  if env["PATH_INFO"] =~ /home\/$/
    [200, {"Content-Type" => "text/html"}, "This is the home page!"]
  else
    [404, {"Content-Type" => "text/html"}, "I only have home page."]
  end
end

  
use Rack::KarmaChameleon, :extension => "jsp"
# use Rack::KarmaChameleon, :extension => "aspx"
run app