class GuildsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_guild, only: %i[ show edit update destroy promote demote kick ]
    before_action { flash.clear }

    # GET /guilds or /guilds.json
    def index
      @guilds = Guild.all.order(:points).reverse
    end

    # GET /guilds/1 or /guilds/1.json
    def show
    end

    # GET /guilds/new
    def new
      @guild = Guild.new
    end

    # GET /guilds/1/edit
    def edit
    end

    # POST /guilds or /guilds.json
    def create
      if (User.find_by_id(guild_params[:owner]).guild != nil)
        redirect_to "/#guilds"
        flash[:error] = "You are already in a guild sneaky :) "
        ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
        ActionCable.server.broadcast "guild_channel", content: "create_guild", userid: current_user.id
      else
        @guild = Guild.new(guild_params)
        @guild.war = nil;
        if @guild.save
          user_params = User.find_by_id(guild_params[:owner])
          user_params.guild = Guild.find_by(name: guild_params[:name]).id
          user_params.save
          ActionCable.server.broadcast "users_channel", content: "profile"
          ActionCable.server.broadcast "guild_channel", content: "ok"
        else
          flash[:error] = ""
          @guild.errors.full_messages.each do |msg|
            flash[:error] = flash[:error] << msg << "<br/>"
          end
          respond_to do |format|
            ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
            format.json { render json: { guild: @guild }, status: :unprocessable_entity }
          end
        end
      end
    end
  
    # PATCH/PUT /guilds/1 or /guilds/1.json
    def update
      if current_user.id == @guild.owner
        respond_to do |format|
          if @guild.update(guild_params)
            ActionCable.server.broadcast "guild_channel", content: "ok"
            format.json { render :show, status: :ok, location: @guild }
          else
            flash[:error] = ""
            @guild.errors.full_messages.each do |msg|
              flash[:error] = flash[:error] << msg << "<br/>"
            end
            ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
            format.json { render json: { guild: @guild }, status: :unprocessable_entity }
          end
        end
      end
    end

    def join_guild
      user_params = User.find_by_id(params[:user_id])
      user_params.guild = params[:guild_id]
      user_params.officer = false
      user_params.member = false
      if user_params.save
        ActionCable.server.broadcast "users_channel", content: "profile"
        ActionCable.server.broadcast "guild_channel", content: "ok"
      end
    end

    def leave_guild
      user_params = User.find_by_id(params[:current_id])
      guild_temp = Guild.find_by_id(user_params.guild)
      if ((user_params.id == guild_temp.owner) && (check_owner(params[:new_owner], guild_temp.id)) && (params[:new_owner] != current_user.username))
        newowner = User.find_by_username(params[:new_owner])
        newowner.officer = false
        newowner.member = false
        guild_temp.owner = newowner.id
        user_params.guild = nil
        user_params.officer = false
        user_params.member = false

        if guild_temp.save && user_params.save && guild_temp.save
          ActionCable.server.broadcast "users_channel", content: "profile"
          ActionCable.server.broadcast "guild_channel", content: "ok"
        end
      elsif User.where(guild: guild_temp.id).length <= 1
        user_params.guild = nil
        user_params.officer = false
        user_params.member = false
        if user_params.save
          guild_temp.destroy
          ActionCable.server.broadcast "users_channel", content: "profile"
          ActionCable.server.broadcast "guild_channel", content: "ok"
        end
      elsif user_params.id == guild_temp.owner
        flash[:error] = "User must be a member of the guild !"
        ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
      else
        user_params.guild = nil
        user_params.officer = false
        user_params.member = false
        if user_params.save
          ActionCable.server.broadcast "users_channel", content: "profile"
          ActionCable.server.broadcast "guild_channel", content: "ok"
        end
      end
    end

    def promote
      user_params = User.find_by_id(params[:current_id])
      if is_sadmin(current_user) || is_owner(current_user, @guild)
        if user_params.member == true
          user_params.member = false
          user_params.officer = true
        elsif !user_params.officer && !user_params.member
          user_params.member = true
        end
        if user_params.save
          ActionCable.server.broadcast "users_channel", content: "profile"
          ActionCable.server.broadcast "guild_channel", content: "ok"
        end
      end
    end

    def demote
      user_params = User.find_by_id(params[:current_id])
      if is_sadmin(current_user) || is_owner(current_user, @guild)
        if user_params.member == true
          user_params.member = false
        elsif user_params.officer == true
          user_params.officer = false
          user_params.member = true
        end
        if user_params.save
          ActionCable.server.broadcast "users_channel", content: "profile"
          ActionCable.server.broadcast "guild_channel", content: "ok"
        end
      end
    end

    def kick
      user_params = User.find_by_id(params[:current_id])
      if (is_sadmin(current_user) || is_owner(current_user, @guild) || is_officer(current_user, @guild)) \
        && !is_owner(user_params, @guild) && !is_officer(user_params, @guild) && !is_sadmin(user_params)
        user_params.guild = nil
        user_params.officer = false
        if user_params.save
          ActionCable.server.broadcast "users_channel", content: "profile"
          ActionCable.server.broadcast "guild_channel", content: "ok"
        end
      end
    end

    # DELETE /guilds/1 or /guilds/1.json
    def destroy
      User.where(guild: params[:id]).each do |temp|
        temp.guild = nil
        temp.officer = false
        temp.member = false
        temp.save
      end
      GuildWar.where(guild_one_id: @guild.id).destroy_all
      GuildWar.where(guild_two_id: @guild.id).destroy_all
      @guild.destroy
      respond_to do |format|
        ActionCable.server.broadcast "users_channel", content: "profile"
        ActionCable.server.broadcast "guild_channel", content: "guild_war"
        format.json { head :no_content }
      end
    end

  private
  def set_guild
    @guild = Guild.find(params[:id])
  end

  def guild_params
    params.permit(:name, :anagram, :points, :owner, :win, :loose, :war)
  end

  def check_owner(username_value, guild_id)
    user = User.find_by_username(username_value)
    if (user && user.guild == guild_id)
      return true
    end
    return false 
  end

  def is_owner(user, guild)
    if user.id == guild.owner
      return true
    end
    return false
  end

  def is_officer(user, guild)
    if user.officer == true && user.guild == guild.id
      return true
    end
    return false
  end
end