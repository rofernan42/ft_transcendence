# Load the Rails application.
require_relative "application"

ENV['ENCRYPTION_KEY'] = "00805870a2147e34eda3777504a715580c60c5d88323c477118ecedcfc582216"
ENV["FT_ID"] = "89e6914a8ecfe99408e4118ce8830a59c4a88916fff1700194b511dca222a177"
ENV["FT_SECRET"] = "438168fe92c0b66d1f49b736f1d84463dce82e643b85cd84800670999c85849d"

# Initialize the Rails application.
Rails.application.initialize!

$games = {}