require 'xmlrpc/client'
require 'rack/response'
require 'erb'
require 'home'


class Xmlrpctest
	attr_accessor :server
	
	def initialize
		@server = XMLRPC::Client.new("localhost", "/RPC2", 81)
	end

	def getTorrentHashes(view)
	  # Call the remote server and get our result
	  result = server.call("download_list",view)
	  return result
	end
	
	def getInfo()
		result = server.call("d.multicall", "started", "d.get_completed_bytes=")
		return result
	end


	def multiRPC(requests,hashes)
		getCode = "result = server.multicall( \n"
		requests.each{
			|request|
			hashes.each{
				|hash|
				getCode << "[\""+requst+"\", \""+hash+"\"],\n"
			}
		}
		hashes.each{
			|hash|
			getCode << "[\"d.get_name\", \""+hash+"\"],\n"
		}
		finalcode = getCode.chop.chop
		finalcode << ")\n return result"
		eval finalcode
	end
		
	def call(env)

		template = %q{
			<title>XMLRPC Test</title>
			<ul>
				<% info.each{
					|titles|
					titles.each{
						|title| %>
						<li> <%= title %> </li>
					<% }
				} %>
			</ul>
		}
    	for i in 1..100 do
			info = getInfo
		end
		
		message = ERB.new(template, 0, "%<>")
  
  


		[
			200,
      			{"Content-Type" => "text/html"},
      			[message.result(binding)]
    		]
	end

	def call2(env)
		#hashes = getTorrentHashes "started"
		res = Rack::Response.new
      		res.write "<title>XMLRPC Test</title>"
      		res.write "<ul>"

		info = getInfo
		
		info.each{
			|titles|
			titles.each{
				|title|
				res.write "<li>"<<title<<"</li>"
			}
		}
      		res.write "</ul>"
      		res.finish
	end

end

if $0 == __FILE__
  require 'rack'
  require 'rack/showexceptions'
  Rack::Handler::WEBrick.run \
    Rack::ShowExceptions.new(Rack::Lint.new(Xmlrpctest.new)),
    :Port => 9292
end

