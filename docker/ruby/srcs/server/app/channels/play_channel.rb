class PlayChannel < ApplicationCable::Channel
  def subscribed
    stream_from "play_channel_#{params[:game_room_id]}"
  end

  def unsubscribed
  end

  def finish_match(data, room_name, game, winner, looser, trnmt)
		winner.pong = 0
		looser.pong = 0
    if game.mode == "ladder"
      if winner.guild != nil
        guild = Guild.find_by_id(winner.guild)
        guild.points += 10
        if guild.war != nil
          war = GuildWar.find_by_id(guild.war)
          if war.started && war.done == false
            if war.guild_one_id == guild.id
               war.guild_one_points += 10
            else
                war.guild_two_points += 10
            end
          end
          if war.save
            ActionCable.server.broadcast "guild_channel", content: "guild_war", userid: winner.id
          end
        end
        if guild.save
          ActionCable.server.broadcast "guild_channel", content: "ok", userid: winner.id
        end
      end
      winner.score += 10
      looser.score -= 10
      if (looser.score < 0)
        looser.score = 0
      end
    elsif game.mode == "war"
      if winner.guild != nil
        guild = Guild.find_by_id(winner.guild)
        if guild.war != nil
          war = GuildWar.find_by_id(guild.war)
          if war.guild_one_id == guild.id
            war.guild_one_points += 10
          else
            war.guild_two_points += 10
          end
          if war.save
            ActionCable.server.broadcast "guild_channel", content: "guild_war", userid: winner.id
          end
        end
      end
    end
		game.winner = winner.id
    game.looser = looser.id
    game.user_left_score = $games[room_name][:left_score]
    game.user_right_score = $games[room_name][:right_score]
		game.tie = false
		game.done = true
    game.playing = false
    if game.save && winner.save && looser.save
      ActionCable.server.broadcast data['room_name'], content: "end"
      ActionCable.server.broadcast "pong_channel", content: "ok"
      ActionCable.server.broadcast "guild_channel", content: "ok"
      ActionCable.server.broadcast "users_channel", content: "profile"
      ActionCable.server.broadcast "flash_admin_channel:#{winner.id}", type: "flash", flash: [[:notice, "You won this match !"]]
      ActionCable.server.broadcast "flash_admin_channel:#{looser.id}", type: "flash", flash: [[:deleted, "You lost this match !"]]
    end
    users = User.where(pong: $games[room_name][:room_id])
    users.each do |temp|
      temp.pong = 0
      if temp.save
        ActionCable.server.broadcast data['room_name'], content: "end";
      end
    end
    if trnmt == true
      tournament = Tournament.find(winner.tournament)
      tournament.end_match(winner, looser)
    end
  end

  def update_left(data)
    room_name = data['room_name']
    trnmt = false

    $games[room_name][:ball_pos_x] = data['ballx']
    $games[room_name][:ball_pos_y] = data['bally']
    $games[room_name][:left_score] = data['user_left_score']
    $games[room_name][:left_action] = data['left_action']
    $games[room_name][:right_score] = data['user_right_score']
    $games[room_name][:ball_dir_x] = data['balldirx']
    $games[room_name][:ball_dir_y] = data['balldiry']
    $games[room_name][:ball_speed] = data['ballspeed']

    if ($games[room_name][:left_score] == 11)
      game = Pong.find_by(room_id: $games[room_name][:room_id])
			user_left = User.find_by_id(game.user_left_id)
      user_right = User.find_by_id(game.user_right_id)
      if game.mode == "tournament"
        trnmt = true
      end
      finish_match(data, room_name, game, user_left, user_right, trnmt)
    elsif ($games[room_name][:right_score] == 11)
      game = Pong.find_by(room_id: $games[room_name][:room_id])
			user_left = User.find_by_id(game.user_left_id)
      user_right = User.find_by_id(game.user_right_id)
      if game.mode == "tournament"
        trnmt = true
      end
      finish_match(data, room_name, game, user_right, user_left, trnmt)
    end
  end

  def update_right(data)
    $games[data['room_name']][:right_action] = data['paddle_right_y']
  end

  def get_datas(data)
    ActionCable.server.broadcast data['room_name'], $games[data['room_name']];
  end

  def leave(data)
    user = User.find_by_id(current_user.id)
    user.pong = 0
    if user.save
      ActionCable.server.broadcast "users_channel", content: "profile"
      ActionCable.server.broadcast "player_#{user.email}", {content: "disconnected"}
    end
  end
end