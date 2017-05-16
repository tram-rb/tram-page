# Tram::Page

Page Object pattern for Rails apps.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'tram-page'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install tram-page

## Usage

```ruby
class class IndexPage < Tram::Page
  param  :account
  option :readonly, optional: true  # See dry-initializer

  url_helper :index_url             # Delegate to Rails.application.routes.url_helpers module

  section :collection
  section :readonly, method: :readonly_on?
  section :index_url                # Usable in section methods

  def collection
    # ...
  end

  def readonly_on?
    readonly
  end
end

IndexPage.new(Account.find(99)).to_h
IndexPage.new(Account.find(99)).to_h(except: :collection)
IndexPage.new(Account.find(99)).to_h(only: :collection)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tram-rb/tram-page. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
