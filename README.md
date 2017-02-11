# SearchSpring
[![Build Status](https://api.travis-ci.org/parallel588/search_spring.svg?branch=master)](https://api.travis-ci.org/parallel588/search_spring.svg?branch=master)

What is SearchSpring?
----------------

SearchSpring provides advanced site search and category navigation solutions to the worlds' top eCommerce retailers. Delivering the best possible results. https://searchspring.com/

What does this Gem do?
----------------------
* implementation Live Indexing API (https://searchspring.zendesk.com/hc/en-us/articles/202518745-SearchSpring-Live-Indexing-API)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'search_spring'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install search_spring

## Usage

```ruby
client = SearchSpring::Client.new(site_id, secret_key)

client.upsert(feed_id: '1234', products: [{id: '1', title: 'Product title'}])
client.update(feed_id: '1234', products: [{id: '1', title: 'Product title'}])
client.delete(feed_id: '1234', product_ids: [1])

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/parallel588/search_spring
