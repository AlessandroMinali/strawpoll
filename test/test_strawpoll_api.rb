require 'minitest/autorun'
require_relative '../lib/strawpoll_api'

describe "StrawPoll new" do

	describe "when given title and more than two options" do
		before do
			@poll = StrawPoll.new "Test Poll", "option 1", "option 2"
		end

		it "must initalize properly" do
			@poll.must_be_instance_of StrawPoll
		end

		it "must initialize all attributes to be read" do
			@poll.must_respond_to :title 
			@poll.must_respond_to :multi
			@poll.must_respond_to :perm
			@poll.must_respond_to :options
			@poll.must_respond_to :api
			@poll.must_respond_to :id
			@poll.must_respond_to :leader
			@poll.must_respond_to :votes
			@poll.must_respond_to :link
			@poll.must_respond_to :results
		end
	end

	describe "when given less than two options" do
		it "must raise Argument Error" do
			proc{ StrawPoll.new("Title", "option a") }.must_raise ArgumentError
		end
	end
end

describe "StrawPoll create!" do

	describe "when asked to create" do
		before do
			@poll = StrawPoll.new "Test Poll", "option 1", "option 2"
		end

		it "must successfully make a poll and return HTTP body" do
			@poll.must_respond_to :create!
			@poll.create!.must_be_instance_of String
			@poll.id.must_be_instance_of Fixnum
			@poll.link.wont_be_nil
			@poll.results.wont_be_nil
		end
	end

	describe "when configuration is incorrect" do
		before do
			@poll = StrawPoll.new "Test Poll", "option 1", "option 2"
			@poll.options.delete_at 1
		end
		it "must raise ArgumentError" do
			proc{ @poll.create! }.must_raise ArgumentError
		end
	end
end

describe "StrawPoll view" do
	before do
		@poll = StrawPoll.new "Test Poll", "option 1", "option 2"
		@poll.create!
	end

	describe "when asked to view default" do
		it "must return HTTP body" do
			@poll.must_respond_to :view
			@poll.view.must_be_instance_of String
		end
	end

	describe "when asked for a specific poll to view" do
		it "must return the appropiate HTTP body" do
			@poll.view(1).must_be_instance_of String
		end

		it "must raise ArgumentError if ID is not a fixnum" do
			proc{ @poll.view 'hello' }.must_raise ArgumentError
		end
	end
end

describe "StrawPoll winner" do
 	before do
		@poll = StrawPoll.new "Test Poll", "option 1", "option 2"
		@poll.create!
	end

	describe "when asked for winner of poll" do
		it "must return winner" do
			@poll.must_respond_to :winner
			@poll.winner.must_be_instance_of String
			@poll.leader.wont_be_nil
			@poll.votes.wont_be_nil
		end
	end

	describe "when asked for a specific winner to view" do
		it "must return the appropiate winner" do
			@poll.winner(1).must_be_instance_of String
		end

		it "must raise ArgumentError if ID is not a fixnum" do
			proc{ @poll.winner 'hello' }.must_raise ArgumentError
		end
	end
end
