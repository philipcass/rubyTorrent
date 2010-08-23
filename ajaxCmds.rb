require 'erubis'
require 'xmlrpc'
require 'base64'
class AjaxCmds

	def call(env)
		req = Rack::Request.new(env)
		#Check for login
		env['warden'].authenticate!(:password)

		case req['cmd']
		when "loadTorrent"
			loadTorrent(env)
		when "stopTorrent"
			server = XmlrpcClient.new
			id = req['id'].chop
			server.stopTorrent(id)
		else
			puts "JE SUIS DO NOT UNDERSTAND"
		end

		return [200, {"Content-Type" => "text/plain"}, [env.inspect]]

	end
	
	def loadTorrent(env)
		#get the file name and post data from the env the postdata is stored in the rack but is not accessable via POST() method, probably due to the way I'm sending the data
		filename = env['HTTP_X_FILE_NAME']
		#remove this hardcoded value
		dir = "/home/weh/"+filename
		data =  env['rack.input'].read()
		aFile = File.new(dir, "w+")
		if aFile
		   aFile.syswrite(data)
		else
		   puts "Unable to open file!"
		end
		server = XmlrpcClient.new

		server.addTorrent(dir)
	end
end