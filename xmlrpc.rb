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
		result = @server.call_async("d.multicall", view, "d.get_name=", "d.is_active=" ,"d.get_left_bytes=" ,"d.get_size_bytes=" ,"d.get_down_rate=" ,"d.get_up_rate=" ,"d.get_connection_seed=" ,"d.get_ratio=" ,"d.get_peers_accounted=")
		#puts result
		return result
	end

end
