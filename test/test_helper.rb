require_relative '../config/env'
require "minitest/autorun"

Dougal::Config.init(files: "#{Dougal.root}/test/data/test-config.yml")
