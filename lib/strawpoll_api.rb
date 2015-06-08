require 'json'
require 'net/http'

class StrawPoll
	attr_accessor :title, :multi, :perm, :options 
	attr_reader :api, :id, :leader, :votes, :link

	def initialize title, *options
		@title = title
		@multi = false
		@perm = true
		@options = options
		@api = 'http://strawpoll.me/api/v2/'
		@id = nil
		@leader = nil
		@votes = nil
		@link = nil
		@results = nil
	end

	def create!
		raise ArgumentError unless !@title.empty? && @options.length >= 2 && @mulit.is_a?(Boolean) && @perm.is_a?(Boolean)
		params = {
			"title" => @title,
			"options" => @options,
			"multi" => @multi,
			"permissive" => @perm,
		}
		url = URI 'http://strawpoll.me/api/v2/polls'
		resp = Net::HTTP.post_form(url, params)
		@id = JSON.parse(resp.body)['id'].to_s
		@link = "http://strawpoll.me/#{@id}" 
		@results = "http://strawpoll.me/#{@id}/r"
		resp.body
	end

	def view id=@id
		raise ArgumentError unless id.is_a? Integer
		url = URI "http://strawpoll.me/api/v2/#{id}"
		resp = Net::HTTP.get(url)
		resp.body
	end

	def winner id=@id
		raise ArgumentError unless id.is_a? Integer
		url = URI "http://strawpoll.me/api/v2/#{id}"
		resp = Net::HTTP.get(url)
		result = JSON.parse(resp)['votes']
		winner = JSON.parse(resp)['options'][result.index(result.max)]
		if id == @id
			@leader = winner
			@votes = result
		end
		winner
	end
end