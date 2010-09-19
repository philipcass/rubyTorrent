require 'erubis'
require 'xmlrpc'
require 'tempfile'
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
		tmp = Tempfile.new(filename)
		data =  env['rack.input'].read()
		tmp.syswrite(data)
		server = XmlrpcClient.new
		tmp.chmod 0644
		server.addTorrent(tmp.path,"/home/rtorrent/data/weh",env['warden'].user)
		tmp.close!

		#Add torrent to redis db userset, ided by the current warden user
		#r = Redis.new
		#r.sadd env['warden'].user, '########'
	end
end
