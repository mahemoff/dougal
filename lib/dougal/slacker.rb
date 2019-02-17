module Dougal

  class Slacker

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
        puts 'Message sent'
      else
        puts "Error: #{res.code}\n#{res.body}"
      end
      result = JSON.parse(res.body)
      if !result['ok']
        puts res.body
        puts "warning: #{result['warning']}"  if result['warning']
        puts "error: #{result['error']}" if result['error']
        puts "meta: #{result['response_metadata']}"
      end

    end

    # why does ruby make this so hard?
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
