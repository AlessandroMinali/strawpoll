require 'json'
require 'net/http'

##
# This class stores a poll instance that can interact with www.strawpoll.me
# Creates a poll object which you can customize and then 
# publish online.
#
# An ArgumentError is raised if you have less than two
# options in your poll
class StrawPoll
	##
	# These attributes can be changed in the same manner
	# that can be done on the strawpoll.me website

	attr_accessor :title, :multi, :perm, :options 

	##
	# These attributes are internally use to track state
	# and provide some quickyl accesible features from online polls

	attr_reader :api, :id, :leader, :votes, :link, :results

	##
	# Creates a new poll instance
	#
	# Returns StrawPoll Object
	#
	# An ArgumentError is raised if passed less than two options

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

	##
	# Publishes poll online and setups links for distribution
	#
	# Returns raw HTTP body
	#
	# An ArgumentError is raised if title is remove or options are
	# reduced below 2

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

	##
	# Retrieves generic poll info. Defaults to poll instance but
	# can be pointed at any poll by using it's ID number
	#
	# Returns raw HTTP body
	#
	# An ArgumentError is raised if ID is not valid type

	def view id=@id
		raise ArgumentError unless id.is_a? Fixnum
		url = URI "#{@api}#{id}"
		resp = Net::HTTP.get(url)
	end

	##
	# Retrieves options with most votes. Defaults to poll instance but
	# can be pointed at any poll by using it's ID number
	#
	# Returns String of winning option, setups up internal states for instance
	#
	# An ArgumentError is raised if ID is not valid type

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