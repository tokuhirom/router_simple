# RouterSimple

RouterSimple is yet another HTTP routing library.

## Installation

Add this line to your application's Gemfile:

    gem 'router_simple'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install router_simple

## Usage

    router = RouterSimple::Router.new
    router.register('GET',  '/', 'Root')
    router.register('POST', '/member/create', 'Member#create')
    router.register('GET',  '/member/:name', 'Member#detail')
    router.register('GET',  '/download/*path', 'Download#detail')

    router.match('/')
    # => ('Root', {})

    router.match('/member/dankogai')
    # => ('Member#detail', {"name" => 'dankogai'})

    router.match('/download/growthforecast')
    # => ('Download#detail', {"path" => 'growthforecast'})

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
