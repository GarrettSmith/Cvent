require 'httparty'
require 'savon'

Dir[File.dirname(__FILE__) + '/cvent/**/*.rb'].each do |file|
  require file
end

module Cvent
end
