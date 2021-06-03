class TournamentsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_start
    before_action :auto_create
    before_action { flash.clear }

    def index
        @tournaments = Tournament.all.order(:start_time).reverse
    end

    def create
        if is_sadmin(current_user)
            tournament = Tournament.new(permitted_parameters)
            if !params[:tournament][:time].empty?
                parse_time = params[:tournament][:date].to_s + " " + params[:tournament][:time].to_s
                start_tr = DateTime.parse(parse_time)
                if start_tr < DateTime.now.change(:offset => "+0000").to_time
                    flash[:error] = "You must enter a valid start time !"
                    ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
                    return
                else
                    tournament.start_time = start_tr
                end
                if tournament.save
                    flash[:notice] = "Tournament was created successfully"
                    ActionCable.server.broadcast "tournament_channel", content: "ok"
                    ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
                end
            else
                respond_to do |format|
                    flash[:error] = "You must enter a valid start time !"
                    ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
                    format.json { render json: { tournament: tournament }, status: :unprocessable_entity }
                end
            end
        end
    end

    def destroy
        if is_sadmin(current_user)
            tournament = Tournament.find(params[:id])
            User.where(tournament: tournament.id) do |user|
                user.tournament = nil
                user.eliminated = false
                user.save
            end
            tournament.destroy
            respond_to do |format|
                flash[:notice] = "The tournament was deleted successfully"
                ActionCable.server.broadcast "tournament_channel", content: "ok"
                ActionCable.server.broadcast "users_channel", content: "profile"
                ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
                format.json { head :no_content }
            end
        end
    end

    def register
        tournament = Tournament.find(params[:id])
        if tournament.started == false
            current_user.tournament = tournament.id
            current_user.eliminated = false
            current_user.save
            ActionCable.server.broadcast "users_channel", content: "profile"
        end
    end

    def unregister
        tournament = Tournament.find(params[:id])
        if tournament.started == false
            current_user.tournament = nil
            current_user.save
            ActionCable.server.broadcast "users_channel", content: "profile"
        end
    end

    private
    def permitted_parameters
        params.require(:tournament).permit(:user_reward, :guild_reward)
    end

    def check_start
        if trs = Tournament.where(started: false).where("start_time < ?", DateTime.now.change(:offset => "+0000").to_time)
            trs.each do |tr|
                tr.started = true
                tr.save
                ActionCable.server.broadcast "tournament_channel", content: "ok"
                tr.start_tournament
            end
        end
    end

    def auto_create
        if DateTime.now.change(:offset => "+0000").hour == 16 && Tournament.where(started: false, auto: true).length == 0
            start = DateTime.now.change(:offset => "+0000").to_time + 1.day
            tournament = Tournament.new(start_time: start, user_reward: 50, auto: true)
            tournament.save
            ActionCable.server.broadcast "tournament_channel", content: "ok"
        end
    end
end
