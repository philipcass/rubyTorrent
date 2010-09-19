require 'erubis'

class Torrentlist
	def initialize(s)
		@xmlrpc = XmlrpcClient.new
	end
	
	def ratioAdjust(ratio)
		if ratio.to_s.length >=4 
			sprintf('%.2f',ratio.to_f/1000)
		elsif ratio.to_s.length ==3
			sprintf('%.2f',ratio.to_f/100)
		elsif ratio.to_s.length ==2
			sprintf('%.2f',ratio.to_f/10)
		else
			sprintf('%.2f',ratio.to_f)
		end
	end

	def call(env)
		template = %q{
			<script type="text/javascript">
				setupAccoridion();
			</script>
			<div>
    <div class="titleLine">
        <span class="torrent-info" style="border-color:transparent;float:left;width:250px;overflow: hidden;white-space: nowrap;">Torrent Name</span>
        <span class="torrent-info" style="border-color:transparent" >Peers</span>
        <span class="torrent-info" style="border-color:transparent" >Ratio</span>
        <span class="torrent-info" style="border-color:transparent" >Seeded</span>
        <span class="torrent-info" style="border-color:transparent" >Up</span>
        <span class="torrent-info" style="border-color:transparent" >Down</span>
        <span class="torrent-info" style="border-color:transparent" >Size</span>
        <span class="torrent-info" style="border-color:transparent" >Remain</span>
        <div class="ui-progressbar" style="border-color:transparent;padding:5px 0 0 2px;text-align:center;">Progress</div>
        <span class="torrent-info" style="border-color:transparent;width:100px;">Torrent Status</span>
    </div>
				<div id="accor-store">
			<% subtorrent.each{
				|info2| %>
				    <div class="accordion" style="display:none;">
					<% info2.each{
						|torrent| 
							status = ""
							if torrent["d.is_active="] == 0 
								status = "Stopped"
							end

							if torrent["d.is_active="] == 1  
								if torrent["d.get_connection_current="] =="leech"
									status = "Downloading"
								else
									status = "Seeding"
								end
							end

							percentComplete = 100-(((torrent["d.get_left_bytes="]).to_f/torrent["d.get_size_bytes="])*100);
							%>
						    <div class="header <%= sprintf(status) %>" id="<%= torrent["d.get_hash="] %> ">
								<img src='public/icon.png' id="stop" style="float:left;margin: 7px 2px 0px 2px;"/>
								<a href="#" style="float:left;width:25%;overflow: hidden;white-space: nowrap;"> <%= torrent["d.get_name="] %> </a>
								<span class="torrent-info" id="peers"> <%= torrent["d.get_peers_accounted="] %> </span>
								<span class="torrent-info" id="ratio"> <%= ratioAdjust(torrent["d.get_ratio="]) %> </span>
								<span class="torrent-info" id="seeded"> <%= torrent["d.get_connection_seed="] %> </span>
								<span class="torrent-info" id="up"> <%= sprintf('%.2f', torrent["d.get_up_rate="].to_f/1024) %> </span>
								<span class="torrent-info" id="down"> <%= sprintf('%.2f', torrent["d.get_down_rate="].to_f/1024) %> </span>
								<span class="torrent-info" id="size"> <%= torrent["d.get_size_bytes="]/1024 %> </span>
								<span class="torrent-info" id="remain"> <%= torrent["d.get_left_bytes="]/1024 %> </span>
								<div class="progressbar" ><span style="display:none;"> <%= sprintf(percentComplete.to_s) %> </span></div>
								<span class="torrent-info" style="width:100px;" id="status"> <%= sprintf(status) %> </span>
						    </div>                                 
							<div></div>
						<% } %>
				</div>
			<% } %>
				</div>
			</div>

 
		}


		req = Rack::Request.new(env)				#This gets the request env variable in a hash. So you can access the get n' post info. LIKE THE VIEW
		
		
		
		info = @xmlrpc.getInfo(req["view"])
		info.reverse!
		
		#only show user torrents
		puts req["user"]		

		if req["user"] == env['warden'].user
			info = info.select {|v| v["d.get_custom1="] == env['warden'].user}
		end


		#Sort by attribute
		#info.sort!{|a,b| a["d.get_size_bytes="]<=>b["d.get_size_bytes="]}


		tempArray = Array.new
		i = 0
		subtorrent = Array.new
		
		while tempArray!=nil do
			tempArray = info.slice(i..(i+7))
			if tempArray == nil then
				break
			end
			i+=8

			subtorrent << tempArray
		end

		#puts subtorrent

		message = Erubis::Eruby.new(template)

		return [200, {"Content-Type" => "text/html"}, [message.result(binding)] ]

	end

end
