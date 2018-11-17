$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mxmnd'
require 'webmock/rspec'

def presence_of_keys?(dict, keys_array)
  keys_array.each { |key| return false unless dict[key] }
  true
end

