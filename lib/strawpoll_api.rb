require 'json'
require 'net/http'

class StrawPoll
	attr_accessor :title, :multi, :perm, :options 
	attr_reader :api, :id, :leader, :votes, :link, :results

	def initialize title, *options
		raise ArgumentError unless options.length >= 2
		@title = title
		@multi = false
		@perm = true
		@options = options
		@api = 'http://strawpoll.me/api/v2/polls/'
		@id = nil
		@leader = nil
		@votes = nil
		@link = nil
		@results = nil
	end

	def create!
		raise ArgumentError unless !@title.empty? && @options.length >= 2
		params = {
			"title" => @title,
			"options" => @options,
			"multi" => @multi,
			"permissive" => @perm,
		}
		url = URI @api
		resp = Net::HTTP.post_form(url, params)
		@id = JSON.parse(resp.body)['id']
		@link = "http://strawpoll.me/#{@id}" 
		@results = "http://strawpoll.me/#{@id}/r"
		resp.body
	end

	def view id=@id
		raise ArgumentError unless id.is_a? Fixnum
		url = URI "#{@api}#{id}"
		resp = Net::HTTP.get(url)
	end

	def winner id=@id
		raise ArgumentError unless id.is_a? Fixnum
		url = URI "#{@api}#{id}"
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