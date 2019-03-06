%w(byebug date json hashie trello yaml fileutils uri net/http active_support/all).each { |f| require f }
require_relative "dougal/version"

module Dougal
  def self.root
    File.dirname(__FILE__) + '/..'
  end
end

Dir[File.dirname(__FILE__) + '/dougal/**/*.rb'].sort.each { |f| puts f; require f }
