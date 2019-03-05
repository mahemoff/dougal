# Wraps a hash representing all config. Config will be read from
# all files in ~/.config/dougal, which are assumed to be YAML format.
module Dougal

  class Config

    CONFIG_DIR = "#{ENV['HOME']}/.config/dougal"
    DEFAULT_CONFIG_FILE = "#{CONFIG_DIR}/config.yaml"
    TEMPLATE_CONFIG_FILE = "#{Dougal.root}/config/config.yaml.template"

    def self.init

      @config = Hashie::Mash.new
      FileUtils.mkdir_p CONFIG_DIR
      config_files = Dir.glob("#{CONFIG_DIR}/**/*.yaml")
      config_files.each { |f| @config.merge! YAML.load_file(f) }
      if config_files.empty?
        puts "Generated config file"
        FileUtils.cp TEMPLATE_CONFIG_FILE, DEFAULT_CONFIG_FILE
      end
      if FileUtils.compare_file TEMPLATE_CONFIG_FILE, DEFAULT_CONFIG_FILE
        puts "Please configure #{DEFAULT_CONFIG_FILE} first"
        exit 1
      end

      ::Trello.configure do |config|
        config.developer_public_key = @config[:trello_api_key]
        config.member_token = @config[:trello_oauth_token]
      end

    end

    def self.get(key, default=nil)
      if !@config.key?(key) && default.nil?
        raise "Ensure #{key} is configured in #{DEFAULT_CONFIG_FILE}" 
      end
      @config[key] || default
    end

  end

end
