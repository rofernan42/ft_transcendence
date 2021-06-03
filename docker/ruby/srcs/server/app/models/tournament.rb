class Tournament < ApplicationRecord
    has_many :user, foreign_key: "tournament"
    has_many :competing, -> { where eliminated: false }, class_name: "User", foreign_key: "tournament"

    def start_tournament
        self.competing.each do |user|
            if user.online == false
                user.eliminated = true
                user.save
                self.competing.reload
            end
        end
        if started == true && m_playing == nil && m_ended == nil && self.user.length <= 1
            self.destroy
            return
        end
        self.m_playing = 0
        self.m_ended = 0
        save
        if self.competing.length <= 1
            if self.competing.first
                user_winner = self.competing.first
                self.winner = user_winner.id
                save
                user_winner.score += self.user_reward
                user_winner.save
                if user_winner.guild
                    guild = Guild.find(user_winner.guild)
                    guild.points += self.guild_reward
                    guild.save
                    if guild.war
                        war = GuildWar.find(guild.war)
                        if war.started == true && war.done == false && war.tournaments == true
                            if guild.id == war.guild_one_id
                                war.guild_one_points += 50
                            elsif guild.id == war.guild_two_id
                                war.guild_two_points += 50
                            end
                            war.save
                            ActionCable.server.broadcast "guild_channel", content: "guild_war"
                        end
                    end
                end
                ActionCable.server.broadcast "flash_admin_channel:#{user_winner.id}", type: "flash", flash: [[:notice, "Congratulations, you won the tournament !"]]
            end
            self.user.each do |user|
                user.tournament = nil
                user.eliminated = false
                user.save
            end
            ActionCable.server.broadcast "users_channel", content: "profile"
            ActionCable.server.broadcast "tournament_channel", content: "ok"
            return
        end
        competitors = self.competing.shuffle
        matches = []
        while competitors.length > 1
            matches.push([competitors.shift(), competitors.pop()])
        end
        matches.each do |match|
            self.m_playing += 1
            save
            ActionCable.server.broadcast "player_#{match.first.email}", content: "create a match", is_matchmaking: false, ranked: "tournament", duel: true, user_one_email: match.last.email
            ActionCable.server.broadcast "player_#{match.last.email}", content: "create a match", is_matchmaking: false, ranked: "joining", duel: true, user_one_email: "test@test.fr"
        end
    end

    def end_match(winner, looser)
        looser.eliminated = true
        looser.save
        self.m_ended += 1
        save
        self.competing.reload
        if self.m_playing == self.m_ended
            start_tournament
        end
    end
end
