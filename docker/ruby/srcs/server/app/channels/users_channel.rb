class UsersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "users_channel:#{current_user.id}"
    stream_from "users_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
