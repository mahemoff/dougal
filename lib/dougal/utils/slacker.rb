##############################################################################
# Generic convenience library for posting to Slack
##############################################################################

module Dougal

  module Utils

    class Slacker

      #######################################################################
      # Post a message to a channel
      #######################################################################

      def self.post(channel, message)

        oauth_token = Dougal::Config.get(:slack_oauth_token)

        channel = "##{channel}" if !channel.starts_with?('#')
        res = self.post_json(
          'https://slack.com/api/chat.postMessage',
          {
            token: oauth_token,
            channel: channel,
            text: message
          },
          {
            'Content-Type' => 'application/json',
            'Authorization' => "Bearer #{oauth_token}" 
          }
        )

        if res.code=='200'
          puts "Message sent to #{channel}"
        else
          puts "Error: #{res.code}\n#{res.body}"
        end

        result = JSON.parse(res.body)
        if !result['ok']
          puts res.body
          puts "Warning: #{result['warning']}"  if result['warning']
          puts "Error: #{result['error']}" if result['error']
          puts "Meta: #{result['response_metadata']}"
        end

      end

      #######################################################################
      # Generic HTTP JSON post
      # Using Net::HTTP which is painful, but means we don't have to require
      # a 3rd party library
      #######################################################################

      def self.post_json(url, payload, headers={})
        begin
          uri = URI(url)
          http = Net::HTTP.new(uri.host, uri.scheme=='https' ? 443 : 80)
          http.use_ssl = true
          req = Net::HTTP::Post.new(uri.path, 'Content-Type' => 'application/json; charset=UTF-8')
          req.body = payload.to_json
          headers.each { |k, v| req[k] = v }
          http.request(req)
        rescue => ex
          puts "Error: request failed #{ex}"
        end
      end

    end

  end

end
