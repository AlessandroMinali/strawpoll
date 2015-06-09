# The Strawpoll Ruby Gem
A Ruby interface to the Strawpoll API. http://strawpoll.me/

## Installation
```
gem install strawpoll_api
```

## Examples

Create a poll
```
poll = StrawPoll.new "My new Poll", "option a", "option b", "option c"
```

Edit poll details
```
poll.multi = true
poll.title = "New Title"
poll.options << "option d"
```

Make poll live on StrawPoll.me
```
poll.create!
poll.id #=> strawpoll ID
poll.link #=> link to your new poll page
poll.results #=> link to your poll results
```

View poll status
```
poll.view

#or specifiy a poll besides your own
poll.view 1234
```

Get the winning result
```
poll.winner

#or specifiy a poll besides your own
poll.winner 1234
```

##Tests

To run tests
```
ruby ./test/test_strawpoll_api.rb
```
