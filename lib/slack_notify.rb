require "slack_notify/version"
require "slack_notify/error"
require "slack_notify/connection"
require "slack_notify/payload"
require "slack_notify/client"

module SlackNotify
  def self.new(option = {})
    SlackNotify::Client.new(option)
  end
end
