require 'rubygems'
require 'rack'
require 'home'
require 'xmlrpc.rb'
require 'torrentlist'

server = XmlrpcClient.new

builder = Rack::Builder.new do
	use Rack::CommonLogger
  
	map '/' do
		run Home.new
	end

	map '/weh/app/torrentlist' do
		run Torrentlist.new(server)
	end

	map '/weh/app/torrentdetails' do
		run Home.new
	end


end
Rack::Handler::WEBrick.run builder, :Port => 9292