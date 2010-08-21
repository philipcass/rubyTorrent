require 'erubis'

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
					</script>
				</head>

				<body style="font-size: 60%;min-width:1200px"> 
					<div class="main">
						<div class="menu">
							<div style="float:left;" class="controls">						
								<h1>WEHBAPP</h1>
							</div>
							<div style="float:right;" class="controls">						
								<button onclick="window.location='/?logout=true'" type="button">Logout</button>
							</div>
						</div>
						
						<div style="clear:both;" class="tabs">
							<ul>
								<li><a href="/public/torrenttabs.html?user=user">*Users* torrents</a></li>
								<li><a href="/public/torrenttabs.html?user=public">Public Torrents</a></li>
								<li><a href="subtabs.html">Info</a></li>
								<li><a href="subtabs.html">Settings</a></li>

							</ul>
						</div>
					</div>
				</body> 
			</html> 
	 
		}
		req = Rack::Request.new(env)
		puts req['logout']
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
