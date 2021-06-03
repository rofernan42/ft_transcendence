class Match < ApplicationRecord
    def self.create(player_mail, ranked)
        if ranked == "ladder"
            if Redis.current.get("matches_ladder").blank? && Redis.current.get('matches_ranked') != player_mail
                Redis.current.set("matches_ladder", player_mail)
            else
                opponent = Redis.current.get('matches_ladder')
                Game.start(player_mail, opponent, ranked)
                Redis.current.set("matches_ladder", nil)
            end
        else
            if Redis.current.get("matches").blank? && Redis.current.get('matches') != player_mail
                Redis.current.set("matches", player_mail)
            else
                opponent = Redis.current.get('matches')
                Game.start(player_mail, opponent, ranked)
                Redis.current.set("matches", nil)
            end
        end
	end
end
