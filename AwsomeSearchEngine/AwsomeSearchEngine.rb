require 'rubygems'
require 'sinatra'
require 'json'
require 'redis'

get '/search/:prefix' do
	redis = Redis.new(:host => "10-36-209-202.wifi.gene.com", :port => 6379)
	keys = redis.keys "#{params[:prefix]}*"
	result = "{\"result\":[";
	keys.each do |key|
		result += redis.get(key)
		result += ","
	end
	result = result[0..result.size - 2]
	result += "]}";
	result
end

