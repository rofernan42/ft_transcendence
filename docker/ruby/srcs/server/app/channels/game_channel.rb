class GameChannel < ApplicationCable::Channel
  def subscribed
    stream_from "player_#{current_user.email}"

    if (params[:ranked] == "joining")
      puts "Joining matches"
    elsif (params[:is_duel])
      Game.start(current_user.email, params[:user_one_email], params[:ranked])
    elsif (params[:is_matchmaking])
      ranked = params[:ranked] ? "ladder" : "duel"
      Match.create(current_user.email, ranked)
    end
  end

  def unsubscribed
    disconnected({player_email: current_user.email})
    if Redis.current.get('matches') == current_user.email
      Redis.current.set('matches', nil)
    end
    if Redis.current.get('matches_ladder') == current_user.email
      Redis.current.set('matches_ladder', nil)
    end
    
    user = User.find_by(email: current_user.email)
    user.pong = 0
    if user.save
      ActionCable.server.broadcast "users_channel", content: "profile"
    end
  end

  def disconnected(data)
    Game.disconnected(current_user.email)
  end
end
