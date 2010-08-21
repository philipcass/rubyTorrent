
class Ajaxrpc
	def initialize(s)
		@xmlrpc = s
	end

	def call(env)

		req = Rack::Request.new(env)
		info = @xmlrpc.getInfo(req["view"])

		#puts info

		message = ERB.new(template, 0, "%<>")

		return [200, {"Content-Type" => "application/json"}, info.to_json ]

	end

end