json.extract! guild_war, :id, :start, :end, :prize, :guild_one_id, :guild_two_id, :guild_one_points, :guild_two_points, :unanswered_match, :tournaments, :ladder, :created_at, :updated_at, :pending, :done, :started, :unanswered_guild_one, :unanswered_guild_two, :winner, :looser, :tie, :start_war_time, :end_war_time, :war_time
json.url guild_war_url(guild_war, format: :json)
