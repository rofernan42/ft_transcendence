class GamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_game, only: %i[ show edit update destroy ]

  def index
    @games = Game.all
  end

  def show
  end

  def new
    @game = Game.new
  end

  def edit
  end

  def create
    if params[:ladder] == "true"
        ranked = true
    else    
        ranked = false
    end
    ActionCable.server.broadcast "player_#{current_user.email}", content: "create a match", is_matchmaking: true, ranked: ranked, duel: false, user_one_email: "test@test.fr"
  end

  def update
  end

  def destroy
    game_id = @game.id
    @game.destroy
    respond_to do |format|
        ActionCable.server.broadcast "users_channel", content: "profile"
        ActionCable.server.broadcast "game_channel", content: "leave_game", userid: current_user.id, game_id: game_id
        format.json { head :no_content }
    end
  end

  private
    def set_game
      @game = Game.find(params[:id])
    end

    def game_params
      params.permit(:id)
    end
end
