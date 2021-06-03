class Game < ApplicationRecord
    def self.start(player1, player2, ranked)
		left, right = [player1, player2].shuffle
		if (left != right)
            current_match_id = 1
			if Redis.current.get('match_id').blank? || Redis.current.get('match_id').to_i >= 999_999
				Redis.current.set('match_id', 1)
			else
				Redis.current.set('match_id', Redis.current.get('match_id').to_i + 1)
				current_match_id = Redis.current.get('match_id')
			end
            Redis.current.set("play_channel_#{current_match_id}_l", "#{left}")
			Redis.current.set("play_channel_#{current_match_id}_r", "#{right}")
            
            user_one = User.find_by(email: left)
            user_two = User.find_by(email: right)

            user_one.pong = current_match_id
            user_two.pong = current_match_id
            if user_one.save && user_two.save
				ActionCable.server.broadcast "users_channel", content: "profile"
				pong = Pong.new
				pong.user_left_id = user_one.id
				pong.user_right_id = user_two.id
				pong.user_left_score = 0
				pong.user_right_score = 0
				pong.mode = ranked
				pong.started = true
				pong.done = false
				pong.playing = true
				pong.winner = 0
				pong.looser = 0
				pong.tie = false
				pong.room_id = current_match_id
				if pong.save
					ActionCable.server.broadcast "pong_channel", content: "set", pong: pong
					Redis.current.set("opponent_for:#{left}", right)
					Redis.current.set("opponent_for:#{right}", left)
					ActionCable.server.broadcast "player_#{left}", {action: "game_start", msg: "left", match_room_id: current_match_id, user: user_one, pong: pong}
					ActionCable.server.broadcast "player_#{right}", {action: "game_start", msg: "right", match_room_id: current_match_id, user: user_two, pong: pong}
				end
			end
            room_name = "play_channel_#{current_match_id}"

			game = {
				room_id: current_match_id,
				room_name: room_name,
				type: ranked,
				ball_pos_x: 175.0,
				ball_pos_y: 300.0,
				left_action: 's',
				right_action: 's',
				right_score: 0,
				left_score: 0,
				ball_speed: 400.0,
				ball_dir_x: 0.5,
				ball_dir_y: 0.5,
			}
			$games[room_name] = game
		end
	end

	def self.disconnected(data)
		if Redis.current.get("opponent_for:#{data}")
        	opponent = Redis.current.get("opponent_for:#{data}")
			if user_opponent = User.find_by(email: opponent)
				if user_opponent.pong != 0
					game = Pong.find_by(room_id: user_opponent.pong)
					room_name = "play_channel_#{user_opponent.pong}"
					trnmt = false
					if game.mode == "tournament"
						trnmt = true
					end
					user_current = User.find_by(email: data)
					user_opponent.pong = 0
					user_current.pong = 0
					game.user_left_score = $games[room_name][:left_score]
					game.user_right_score = $games[room_name][:right_score]
					game.winner = user_opponent.id
					game.looser = user_current.id
					game.tie = false
					game.done = true
					game.playing = false

					if game.mode == "ladder"
						if user_opponent.guild != nil
						  	guild = Guild.find_by_id(user_opponent.guild)
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
									ActionCable.server.broadcast "guild_channel", content: "guild_war", userid: user_opponent.id
								end
							end
							if guild.save
								ActionCable.server.broadcast "guild_channel", content: "ok", userid: user_opponent.id
							end
						end
						user_opponent.score += 10
						user_current.score -= 10
						if (user_current.score < 0)
							user_current.score = 0
						end
					elsif game.mode == "war"
						if user_opponent.guild != nil
							guild = Guild.find_by_id(user_opponent.guild)
						  	if guild.war != nil
								war = GuildWar.find_by_id(guild.war)
								if war.guild_one_id == guild.id
							 		war.guild_one_points += 10
								else
							  		war.guild_two_points += 10
								end
								if war.save
									ActionCable.server.broadcast "guild_channel", content: "guild_war", userid: user_opponent.id
								end
							end
						end
					end
					if game.save && user_opponent.save && user_current.save
						ActionCable.server.broadcast "guild_channel", content: "ok"
						ActionCable.server.broadcast "users_channel", content: "profile"
						ActionCable.server.broadcast "pong_channel", content: "ok"
						ActionCable.server.broadcast "flash_admin_channel:#{user_opponent.id}", type: "flash", flash: [[:notice, "You won this match !"]]
      					ActionCable.server.broadcast "flash_admin_channel:#{user_current.id}", type: "flash", flash: [[:deleted, "You forfeited this match !"]]
						users = User.where(pong: $games[room_name][:room_id])
						users.each do |temp|
					 		temp.pong = 0
					 		if temp.save
								ActionCable.server.broadcast "player_#{temp.email}", {content: "disconnected"}
					 		end
						end
						Redis.current.set("play_channel_#{user_opponent.pong}_l", nil)
						Redis.current.set("play_channel_#{user_opponent.pong}_r", nil)
					end
				else
    				user_opponent.pong = 0
    				if user_opponent.save
	      				ActionCable.server.broadcast "users_channel", content: "profile"
					end
				end
			end
			ActionCable.server.broadcast "player_#{opponent}", {content: "disconnected", loc: "game.rb self.disconnected opponent", usr: opponent}
			Redis.current.set("opponent_for:#{data}", nil)
			Redis.current.set("opponent_for:#{opponent}", nil)
			if trnmt == true
				tournament = Tournament.find(user_current.tournament)
				tournament.end_match(user_opponent, user_current)
			end
		end
    end
end
