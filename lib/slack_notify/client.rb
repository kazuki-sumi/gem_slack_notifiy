require "json"
require "faraday"
require "net/http"
require "uri"

module SlackNotify
  class Client
    include SlackNotify::Connection

    def initialize(options = {})
      raise ArgumentError, "webhook URL required" unless options[:webhook_url]

      @webhook_url  = options[:webhook_url]
      @username     = options[:username]
      @channel      = options[:channel]
      @icon_url     = options[:icon_url]
      @icon_emoji   = options[:icon_emoji]
      @link_names   = options[:link_names]
      @unfurl_links = options[:unfurl_links] || "1"
    end

    def test
      notify("Test Message")
    end

    def notify(text, channel = nil)
      delivery_channels(channel).each do |chan|
        payload = SlackNotify::Payload.new(
          text: text,
          channel: chan,
          username: @username,
          icon_url: @icon_url,
          icon_emoji: @icon_emoji,
          link_names: @link_names,
          unfurl_links: @unfurl_links
        )
        uri = URI.parse(@webhook_url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        req = Net::HTTP::Post.new(uri.request_uri)
        req["Content-Type"] = "application/json"
        req.body = payload.to_json
        res = http.request(req)
        puts "OK"
        # send_payload(payload)
      end

      true
    end

    private

      def delivery_channels(channel)
        [channel || @channel || "#general"].flatten.compact.uniq
      end
  end
end