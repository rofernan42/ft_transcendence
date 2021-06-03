# frozen_string_literal: true

class Registrations::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    super
    ActionCable.server.broadcast "users_channel", content: "profile"
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  def destroy
    # ADD SUPER USER CONDITION TO DESTROY USER
    super
    userid = param[:id]

    #destroy chatrooms (+ chats)
    @chatrooms = Chatroom.all
    @chatrooms.each do |chatroom|
      chatroom.members.delete(userid)
      chatroom.banned.delete(userid)
      chatroom.muted.delete(userid)
      chatroom.admin.delete(userid)
      chatroom.save
    end
    ActionCable.server.broadcast "room_channel", type: "chatrooms", action: "update"

    #destroy private rooms (+ pms)
    @prs = PrivateRoom.all
    @prs.each do |pr|
      if pr.users.detect{ |e| e == userid }
        pr.destroy
      end
    end
    ActionCable.server.broadcast "room_channel", type: "private_rooms", action: "update", updateType: "destroy"

    #destroy guild if owner + reset guild params to all users
    if guild = Guild.find_by_owner(userid)
      User.where(guild: guild.id).each do |usr|
        usr.guild = nil
        usr.officer = false
        usr.member = false
        usr.save
      end
      GuildWar.where(guild_one_id: guild.id).destroy_all
      GuildWar.where(guild_two_id: guild.id).destroy_all
      guild.destroy
      ActionCable.server.broadcast "guild_channel", content: "guild_war"
    end

    #remove user from block lists
    @users = User.all
    @users.each do |usr|
      usr.block_list.delete(userid)
      usr.save
    end

    #remove tournaments where winner is user
    Tournament.where(winner: userid).destroy_all
    ActionCable.server.broadcast "tournament_channel", content: "ok"

    #remove friendships
    Friend.where(user_one_id: userid).destroy_all
    Friend.where(user_two_id: userid).destroy_all
    ActionCable.server.broadcast "friend_channel", content: "ok"

    #remove pongs
    Pong.where(user_left_id: userid).destroy_all
    Pong.where(user_right_id: userid).destroy_all
    ActionCable.server.broadcast "pong_channel", content: "ok"

    #remove avatar folder
    FileUtils.rm_rf("public/avatars/#{userid}")

    ActionCable.server.broadcast "users_channel", content: "profile"
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
