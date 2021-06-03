class OnlineChannel < ApplicationCable::Channel
  def subscribed
    stream_from "online_channel"
    if current_user
      ActionCable.server.broadcast "online_channel", { user: current_user.id, online: :on }
      current_user.online = true
      current_user.pong = 0
      current_user.save!
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    if current_user
      ActionCable.server.broadcast "online_channel", { user: current_user.id, online: :off }
      current_user.online = false
      current_user.pong = 0
      current_user.save!
    end
  end
end
