# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

use Rack::Auth::Basic do |user, pass|
  user == ENV['USER'] && pass == ENV['PASS']
end

run Rails.application
