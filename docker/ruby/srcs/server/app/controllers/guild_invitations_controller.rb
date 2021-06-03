class GuildInvitationsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_guild_invitation, only: %i[ show edit update destroy ]

  # GET /friends or /friends.json
  def index
    @guild_invitations = GuildInvitation.all
  end

  # GET /friends/1 or /friends/1.json
  def show
  end

  # GET /friends/new
  def new
    @guild_invitation = GuildInvitation.new
  end

  # GET /friends/1/edit
  def edit
  end

  # POST /friends or /friends.json
  def create
    if !guild_inv_exists(params[:user_id], params[:guild_id])
      @guild_invitation = GuildInvitation.new(guild_invitation_params)
      if @guild_invitation.save
        ActionCable.server.broadcast "users_channel", content: "profile"
        ActionCable.server.broadcast "guild_channel", content: "guild_invitation"
      end
    else
      flash[:error] = ""
      flash[:error] = flash[:error] << "You already sent a request" << "<br/>"
      respond_to do |format|
        ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
        format.json { render json: { guild: @guild }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /friends/1 or /friends/1.json
  def update
    if (params[:pending] == 'false')
        @guild_invitation.destroy
        user = User.find_by_id(params[:user_id])
        user.guild = params[:guild_id]
        user.save
        ActionCable.server.broadcast "users_channel", content: "profile"
        ActionCable.server.broadcast "guild_channel", content: "guild_invitation"
    end
  end

  # DELETE /friends/1 or /friends/1.json
  def destroy
    @guild_invitation.destroy
    respond_to do |format|
        ActionCable.server.broadcast "users_channel", content: "profile"
        ActionCable.server.broadcast "guild_channel", content: "guild_invitation"
        format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_guild_invitation
      @guild_invitation = GuildInvitation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def guild_invitation_params
      params.permit(:user_id, :guild_id, :pending)
    end

    def guild_inv_exists(user_id, guild_id)
      if (!GuildInvitation.where(user_id: user_id, guild_id: guild_id).empty?)
          return 1
      end
      return nil
  end
end
