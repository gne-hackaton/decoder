require 'rubygems'
require 'sinatra'
require 'json'
require 'redis'

get '/search/:prefix' do
	redis = Redis.new(:host => "127.0.0.1", :port => 6379)
	keys = redis.keys "#{params[:prefix]}*".upcase
	result = "{\"result\":[";
	keys.each do |key|
		result += redis.get(key)
		result += ","
	end
	result = result[0..result.size - 2]
	result += "]}";
	result
end

