module Dougal

  def self.root
    File.expand_path("../..", __FILE__)
  end

end

puts "root: `#{Dougal.root}`"
$LOAD_PATH.unshift "#{Dougal.root}/lib"
require "dougal"
