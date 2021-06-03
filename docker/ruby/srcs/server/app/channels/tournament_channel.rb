class TournamentChannel < ApplicationCable::Channel
  def subscribed
    stream_from "tournament_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
