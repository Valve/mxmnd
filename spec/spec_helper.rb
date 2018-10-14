$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "mxmnd"
require 'webmock/rspec'

def presence_of_keys?(_hash, keys_array)
  keys_array.each {|key| return false if _hash[key].nil?}
  true 
end

def hash_including_locales(_hash, num_of_locales)
  _hash.is_a?(Hash) && _hash["names"].length == num_of_locales 
end