class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_friend, only: %i[ show edit update destroy ]

  # GET /friends or /friends.json
  def index
    @friends = Friend.all
  end

  # GET /friends/1 or /friends/1.json
  def show
  end

  # GET /friends/new
  def new
    @friend = Friend.new
  end

  # GET /friends/1/edit
  def edit
  end

  # POST /friends or /friends.json
  def create
    if !friendship_exists(params[:user_one_id], params[:user_two_id]) \
    && params[:user_one_id] != params[:user_two_id]
      @friend = Friend.new(friend_params)
      if @friend.save
        ActionCable.server.broadcast "friend_channel", content: "ok"
      end
    end
  end

  # PATCH/PUT /friends/1 or /friends/1.json
  def update
    if @friend.update(friend_params)
      ActionCable.server.broadcast "friend_channel", content: "ok"
    end
  end

  # DELETE /friends/1 or /friends/1.json
  def destroy
    if @friend.user_one_id == current_user.id || @friend.user_two_id == current_user.id
      @friend.destroy
      respond_to do |format|
        ActionCable.server.broadcast "friend_channel", content: "ok"
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_friend
      @friend = Friend.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def friend_params
      params.permit(:user_one_id, :user_two_id, :pending)
    end

    def friendship_exists(user_1, user_2)
      if (!Friend.where(user_one_id: user_1, user_two_id: user_2).empty? \
      || !Friend.where(user_one_id: user_2, user_two_id: user_1).empty?)
          return 1
      end
      return nil
  end
end
