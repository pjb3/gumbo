# Gumbo

Gumbo is a standalone asset packager for creating HTML files that link to a single CSS and single JS file, which includes an MD5 in the file name to make the asset package files cacheable for indefinite amounts of time.

## Installation

Add this line to your application's Gemfile:

    gem 'gumbo'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gumbo

## Usage

To see an example of how this works, look at `examples/todo`.  To build the assets, in that directory, run:

    $ gumbo

To make changes and have them automatically built, you can install `guard-shell` and run:

    $ guard

The way is works is that you put your assets in the `assets` directory.  In the `assets` directory, there is a `packages.yml` file that looks like:

    js:
      todo:
        - todo.coffee
        - templates/todo.eco

    css:
      todo:
        - reset.css
        - style.css

What this means is that there is one js package called todo and one css package called todo.  When the assets are built, they will be put into a directory called `public` along side `assets`.

Static HTML files can be generated from dynamic content using the [Liquid][liquid] templating language.  In this example, the names of the asset packages with an MD5 timestamp of the contents are included in the resulting HTML file that is created in the `public` directory.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[liquid]: http://liquidmarkup.org/
