class FriendChannel < ApplicationCable::Channel
  def subscribed
    stream_from "friend_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
