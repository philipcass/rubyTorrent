require 'xmlrpc/client'

class XmlrpcClient

	def initialize
		@server = XMLRPC::Client.new("localhost", "/RPC2", 81)
	end

	def getTorrentHashes(view)
		# Call the remote server and get our result
		result = @server.call("download_list",view)
		return result
	end

	def getInfo(view)
		keys = ["d.get_name=", "d.is_active=","d.get_complete=" ,"d.get_connection_current=","d.get_left_bytes=" ,"d.get_size_bytes=" ,"d.get_down_rate=" ,"d.get_up_rate=" ,"d.get_connection_seed=" ,"d.get_ratio=" ,"d.get_peers_accounted=","d.get_hash=","d.get_custom1="]
		result = @server.call_async("d.multicall", view, *keys)
		result2 = []
		result.each{
			|r|
			hash = {}
			(0..keys.length).each{|i| hash[keys[i]] = r[i]}
			result2 << hash
		
		}
		#puts result2
		#puts result2[0]["d.get_complete="]
		return result2
	end
	
	def addTorrent(torrentLocation, downloadDir,user)
		#Store username in custom1
		puts @server.call("load_start_verbose",torrentLocation,"d.set_directory="+"\""+downloadDir+"\"","d.set_custom1="+"\""+user.to_s+"\"")

	end
	
	def stopTorrent(id)
		result = @server.call("d.close",id)
		
	end

end
