require "json"
require "faraday"
require "net/http"
require "uri"
require "pry-byebug"

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
      chan = delivery_channels(channel)
      payload = {
        text: text,
        channel: chan[0],
        username: @username,
        icon_url: @icon_url,
        icon_emoji: @icon_emoji,
        link_names: @link_names,
        unfurl_links: @unfurl_links
      }
      uri = URI.parse(@webhook_url)
      req = Net::HTTP::Post.new(uri.request_uri)
      req["Content-Type"] = "application/json"
      req.body = payload.to_json
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      response = http.request(req)
      handle_response(response)
    end

    private

      def delivery_channels(channel)
        [channel || @channel || "#general"].flatten.compact.uniq
      end

      def handle_response(response)
        unless response.code == "200"
          if response.body.include?("\n")
            raise SlackNotify::Error
          else
            raise SlackNotify::Error.new(response.body)
          end
        end
      end
  end
end