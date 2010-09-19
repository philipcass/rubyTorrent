require 'erubis'
require 'redis'

class Home

	def call(env)
		template = %q{
			<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
			<html>
				<head>
					<link type="text/css" href="/public/css/smoothness/jquery-ui-1.8.2.custom.css" rel="stylesheet" />
					<link type="text/css" href="/public/css/style.css" rel="stylesheet" />	
					<script type="text/javascript" src="/public/js/jquery-1.4.2.min.js"></script> 
					<script type="text/javascript" src="/public/js/jquery-ui-1.8.2.custom.min.js"></script> 
					<script type="text/javascript" src="/public/scripts.js"></script> 
					<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
					<title>Untitled Document</title>
					<script type="text/javascript">
						tabulateMain();
						tabulateSub();					
					</script>

				</head>

				<body style="font-size: 60%;min-width:1200px"> 
					<div id="dialog-form" title="Create new user">
						<p class="validateTips">All form fields are required.</p>
					
						File to upload: <input id="the-file" type=file name=upfile><br> 
					</div>
					<div class="main">
						<div class="menu ">					
							<h1 >WEHBAPP</h1>
							<div class="controls ui-corner-all">
								<p id="user"><%= env['warden'].user %></p>
								<p id="usage">Percentage Usage</p>
								<p id="activeTorrents">Active torrents</p>
								
								<button style="float:right" onclick="window.location='/?logout=true'">Logout</button>
								<button style="float:right" id="opener">Add Torrent</button>
							</div>
						</div>
						
						<div style="clear:both;" class="tabs">
							<ul>
								<li><a href="#tabs-1"><%= env['warden'].user %>s torrents</a></li>
								<li><a href="#tabs-2">Public Torrents</a></li>
								<li><a href="subtabs.html">Info</a></li>
								<li><a href="subtabs.html">Settings</a></li>
							</ul>
							<div id="tabs-1" class="tabs-container">
								<ul>
									<li><a href="/torrentlist/?user=<%= env['warden'].user %>&view="><span>All</span></a></li>
									<li><a href="/torrentlist/?user=<%= env['warden'].user %>&view=started"><span>started</span></a></li>
									<li><a href="/torrentlist/?user=<%= env['warden'].user %>&view=stopped"><span>stopped</span></a></li>
									<li><a href="/torrentlist/?user=<%= env['warden'].user %>&view=complete"><span>complete</span></a></li>
									<li><a href="/torrentlist/?user=<%= env['warden'].user %>&view=hashing"><span>hashing</span></a></li>
									<li><a href="/torrentlist/?user=<%= env['warden'].user %>&view=seeding"><span>seeding</span></a></li>
								</ul>
							</div>
							<div id="tabs-2" class="tabs-container">
								<ul>
									<li><a href="/torrentlist/?user=&view="><span>All</span></a></li>
									<li><a href="/torrentlist/?user=&view=started"><span>started</span></a></li>
									<li><a href="/torrentlist/?user=&view=stopped"><span>stopped</span></a></li>
									<li><a href="/torrentlist/?user=&view=complete"><span>complete</span></a></li>
									<li><a href="/torrentlist/?user=&view=hashing"><span>hashing</span></a></li>
									<li><a href="/torrentlist/?user=&view=seeding"><span>seeding</span></a></li>
								</ul>
							</div>

						</div>
					</div>
				</body> 
			</html> 
	 
		}
		req = Rack::Request.new(env)
		#puts req['logout']
		if req['logout'] == "true"
			env['warden'].logout
			puts "logout"
		end
		#Check for login
		env['warden'].authenticate!(:password)
		
		message = ERB.new(template, 0, "%<>")

		return [200, {"Content-Type" => "text/html"}, [message.result(binding)]]

	end
end
