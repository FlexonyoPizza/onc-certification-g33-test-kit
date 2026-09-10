# frozen_string_literal: true

source "https://rubygems.org"

gemspec

# Track the PAS test kit from git rather than the latest release so that client v2.2.1 changes are
# picked up before they are published to rubygems. This kit cannot be published to rubygems while
# this points at git.
gem 'davinci_pas_test_kit',
    git: 'https://github.com/inferno-framework/davinci-pas-test-kit.git',
    branch: 'main'

# activesupport still passes the `quirks_mode:` keyword that json 3.x removed, so loading the test
# kit raises ArgumentError under json 3. Resolving the PAS kit from github lifted the upper bound the
# released gem was providing, so it is pinned here instead for now.
gem 'json', '< 3'

group :development, :test do
  gem 'debug'
  gem 'rubocop', '~> 1.9'
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'database_cleaner-sequel', '~> 1.8'
  gem 'factory_bot', '~> 6.1'
  gem 'rack-test'
  gem 'rspec', '~> 3.10'
  gem 'simplecov', '0.21.2', require: false
  gem 'webmock', '~> 3.11'
end