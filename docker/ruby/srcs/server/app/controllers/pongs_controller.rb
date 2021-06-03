class PongsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_pong, only: %i[ show edit update destroy ]
  
    def index
      @pongs = Pong.all.order(:updated_at).reverse
    end
  
    def show
    end
  
    def new
      @pong = Pong.new
    end
  
    def edit
    end
  
    def create
        @pong = Pong.new(pong_params)
        if @pong.save
          ActionCable.server.broadcast "pong_channel", content: "ok"
        end
    end

    def spectate
        user = User.find_by_id(current_user.id)
        user.pong = params[:room_id]
        if user.save
            ActionCable.server.broadcast "player_#{current_user.email}", content: "spectate", user: user
        end
    end

    def duel_demand
      war = false
      user_one = User.find_by_id(params[:user_one_id])
      user_two = User.find_by_id(params[:user_two_id])

      if user_two.pong == 0
        if user_one.guild != nil && user_two.guild != nil
          guild_one = Guild.find_by_id(user_one.guild)
          guild_two = Guild.find_by_id(user_two.guild)
          if guild_one.war != nil && guild_two.war != nil
            if guild_one.war == guild_two.war
              guild_war = GuildWar.find_by_id(guild_one.war)
              if guild_war.started == true && guild_war.done == false
                war = true
              end
            end
          end
        end
        ActionCable.server.broadcast "flash_admin_channel:#{params[:user_two_id]}", type: "duel", user_one_name: user_one.username, user_one_id: params[:user_one_id], user_two_id: params[:user_two_id], war: war
      end
    end

    def accept_duel
      if params[:war] == "true"
        ranked = "war"
      else
        ranked = "duel"
      end
      user_one = User.find_by_id(params[:user_one_id])
      if (user_one.online == true && user_one.pong == 0)
        ActionCable.server.broadcast "player_#{current_user.email}", content: "create a match", is_matchmaking: false, ranked: ranked, duel: true, user_one_email: user_one.email
        ActionCable.server.broadcast "player_#{user_one.email}", content: "create a match", is_matchmaking: false, ranked: "joining", duel: true, user_one_email: "test@test.fr"
      end
    end

    def decline_duel
      user_one = User.find_by_id(params[:user_one_id])
      user_two = User.find_by_id(params[:user_two_id])

      if user_one.guild != nil && user_two.guild != nil
        guild_one = Guild.find_by_id(user_one.guild)
        guild_two = Guild.find_by_id(user_two.guild)
        if guild_one.war != nil && guild_two.war != nil
          if guild_one.war == guild_two.war
            guild_war = GuildWar.find_by_id(guild_one.war)
            if guild_war.started == true && guild_war.done == false 
              if guild_two.id == guild_war.guild_one_id
                guild_war.unanswered_guild_two += 1
                guild_war.guild_two_points += 10
                if guild_war.unanswered_guild_two >= guild_war.unanswered_match && guild_war.unanswered_match != 0
                  guild_one.points -= guild_war.prize
                  guild_two.points += guild_war.prize
                  guild_war.winner = guild_two.id
                  guild_war.looser = guild_one.id
                  guild_one.loose += 1
                  guild_two.win += 1
                  guild_war.done = true
                  guild_war.started = true 
                  guild_war.pending = false
                end
              else
                guild_war.unanswered_guild_one += 1
                guild_war.guild_one_points += 10
                if guild_war.unanswered_guild_one >= guild_war.unanswered_match && guild_war.unanswered_match != 0
                  guild_two.points -= guild_war.prize
                  guild_one.points += guild_war.prize
                  guild_war.looser = guild_two.id
                  guild_war.winner = guild_one.id
                  guild_two.loose += 1
                  guild_one.win += 1
                  guild_war.done = true
                  guild_war.started = true 
                  guild_war.pending = false
                end
              end
              if guild_war.save
                ActionCable.server.broadcast "guild_channel", content: "guild_war", userid: current_user.id
              end
            end
          end
        end
      end
    end

    def update
      if @pong.update(pong_params)
        ActionCable.server.broadcast "pong_channel", content: "ok"
      end
    end
  
    def destroy
        @pong.destroy
        respond_to do |format|
          ActionCable.server.broadcast "pong_channel", content: "ok"
          format.json { head :no_content }
        end
    end

    private
      def set_pong
        @pong = Pong.find(params[:id])
      end

      def pong_params
        params.permit(:id, :user_left_id, :user_right_id, :user_left_score, :user_right_score, :done, :started, :mode, :playing, :winner, :looser, :tie, :room_id)
      end
end
