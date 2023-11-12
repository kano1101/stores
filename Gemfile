source "https://rubygems.org"

ruby "3.2.0"

# Custom
gem "bigdecimal"
gem "dotenv-rails"
gem "watir", "~> 7.3"
gem 'whenever', require: false

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.1"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "tzinfo-data", platforms: %i[ mswin mingw ]

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
#   gem "debug", platforms: %i[ mri windows ]
  gem "debug", platforms: %i[ mri mswin mingw ]
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"

end

