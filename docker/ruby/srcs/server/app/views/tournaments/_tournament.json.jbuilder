json.extract! tournament, :id, :start_time, :user_reward, :guild_reward, :winner, :started
json.url tournaments_url(tournament, format: :json)
