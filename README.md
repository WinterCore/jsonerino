# JSONERINO

JSONERINO is a lightweight json parser written in ruby. with no dependencies. It also contains a command line tool for validating json files (check below).

## Usage

First of all you need to add the following to your `Gemfile`
```
gem 'jsonerino'
```
Then you need to run `bundle install`.

After that you can use it to parse json by calling the `parse` method

```ruby
require 'jsonerino'

p Jsonerino::parse('nil') == nil # true

output = Jsonerino::parse('[{"name" : "Alex", "age" : 15 }]')

p output == [{"name" => "Alex","age" => 15}] # true

```


Calling the `parse` method will convert the json string to it's corresponding ruby representation.


[![Run on Repl.it](https://repl.it/badge/github/WinterCore/microverse-ruby-capstone-json-parser)](https://repl.it/@WinterCore/microverse-ruby-capstone-json-parser#main.rb)

## Using the included json validator

![CLI DEMO](cli-demo.gif)

- Run `gem install jsonerino`
- Run `jsonerino <file|directory>`
    If no filename is provided. jsonerino will try to parse all the JSON files that are in your current working directory.


## Built with

- Ruby

## Development Commands

- Run tests `bundle exec rspec`
- Run rubocop (code linter) `bundle exec rubocop`

Note: Make sure to run `bundle install` in the project's directory before trying to run the previous commands.

## Authors

👤  **WinterCore**

- Github: [@WinterCore](https://github.com/WinterCore)

## 🤝  Contributing

Contributions, issues and feature requests are welcome! Start by:

- Forking the project
- Cloning the project to your local machine
- `cd` into the project directory
- Run `git checkout -b your-branch-name`
- Make your contributions
- Push your branch up to your forked repository
- Open a Pull Request with a detailed description to the development branch of the original project for a review

## Show your support

Give a ⭐️  if you like this project!
