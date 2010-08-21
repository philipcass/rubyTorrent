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
			<% subTitles.each{
				|info2| %>
				    <div class="accordion" style="display:none;">
					<% info2.each{
						|titles| 
							if titles[1] == 1 
								status = "Active"
							else 
								status = "Inactive"
							end
							percentComplete = 100-(((titles[2]).to_f/titles[3])*100);
							%>
						    <div id="header">
							<a href="#" style="float:left;width:25%;overflow: hidden;white-space: nowrap;"> <%= titles[0] %> </a>
							<span class="torrent-info" id="peers"> <%= titles[8] %> </span>
							<span class="torrent-info" id="ratio"> <%= ratioAdjust(titles[7]) %> </span>
							<span class="torrent-info" id="seeded"> <%= titles[6] %> </span>
							<span class="torrent-info" id="up"> <%= sprintf('%.2f', titles[5].to_f/1024) %> </span>
							<span class="torrent-info" id="down"> <%= sprintf('%.2f', titles[4].to_f/1024) %> </span>
							<span class="torrent-info" id="size"> <%= titles[3]/1024 %> </span>
							<span class="torrent-info" id="remain"> <%= titles[2]/1024 %> </span>
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

		tempArray = Array.new
		i = 0
		subTitles = Array.new
		
		while tempArray!=nil do
			tempArray = info.slice(i..(i+7))
			if tempArray == nil then
				break
			end
			i+=20

			subTitles << tempArray
		end

		#puts subTitles

		message = Erubis::Eruby.new(template)

		return [200, {"Content-Type" => "text/html"}, [message.result(binding)] ]

	end

end
