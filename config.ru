require 'rubygems'
require 'rack'
require 'home'
require 'xmlrpc.rb'
require 'torrentlist'
require 'warden'
require 'ajaxCmds'


server = XmlrpcClient.new

  use Rack::Session::Cookie

  use Warden::Manager do |manager|
    manager.default_strategies :password, :basic
    manager.failure_app = lambda {|env| login(env)}
  end
  
Warden::Strategies.add(:password) do
  
	def authenticate!
		if request['username'] == "test" && request['password'] == "test" 
			success!(request['username'])
			#puts "succeeded"
		else
			fail!("Could not log in")
			#puts "fail"
		end
	end
end

def login(env)
	[200, {"Content-Type" => "text/html"}, ['
	<HTML>
   <HEAD>
     <TITLE>HTML form tutorial example</TITLE>
   </HEAD>
   <BODY>
    
    <H1>wehbApp login</H1>

    <FORM ACTION="/" METHOD="POST">

    Username: <INPUT TYPE="TEXT" NAME="username" VALUE="" SIZE="25" MAXLENGTH="50"> <BR>

    Password: <INPUT TYPE="TEXT" NAME="password" VALUE="" SIZE="25" MAXLENGTH="50"><BR>

    <INPUT TYPE="SUBMIT" NAME="submit" VALUE="Login!">

    </FORM>

   </BODY>
</HTML>']]

end

use Rack::CommonLogger

map '/' do
	run Home.new
end

map '/torrentlist' do
	run Torrentlist.new(server)
end

map '/ajaxcmd' do
	run AjaxCmds.new
end

