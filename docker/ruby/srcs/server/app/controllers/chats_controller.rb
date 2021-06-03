class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :end_of_ban_mute

  # POST /chats or /chats.json
  def create
    chatroomid = params[:chat][:chatroom_id].to_i
    chatroom = Chatroom.find_by_id(chatroomid)
    if ((chatroom.members.detect{ |e| e == current_user.id } && !chatroom.muted.detect{ |e| e == current_user.id }) \
    || chatroom.owner == current_user.id \
    || is_sadmin(current_user))
      @chat = Chat.create(chat_params)
      @chat.date_creation = Time.now.strftime('%I:%M %p')
      respond_to do |format|
        if @chat.save
          ActionCable.server.broadcast "room_channel", type: "chatrooms", action: "chats", content: @chat
          format.html { redirect_to @chat, notice: "Chat was successfully created." }
          format.json { render :show, status: :created, location: @chat }
          format.js
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @chat.errors, status: :unprocessable_entity }
        end
      end
    end
    if chatroom.muted.detect{ |e| e == current_user.id }
      respond_to do |format|
        flash[:deleted] = "You have been muted from #{chatroom.name} !"
        ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
        format.json { render json: { chatroom: chatroom }, status: :forbidden }
      end
    end
  end

  private
  # Only allow a list of trusted parameters through.
  def chat_params
    params.require(:chat).permit(:message, :user_id, :chatroom_id)
  end

  def end_of_ban_mute
    if bans = ChatroomBan.where("end_time < ?", DateTime.now.change(:offset => "+0000").to_time)
        bans.each do |ban|
            ban.chatroom.banned.delete(ban.user_id)
            ban.chatroom.save
            ban.destroy
            ActionCable.server.broadcast "room_channel", type: "chatrooms", action: "update"
        end
    end
    if mutes = ChatroomMute.where("end_time < ?", DateTime.now.change(:offset => "+0000").to_time)
        mutes.each do |mute|
            mute.chatroom.muted.delete(mute.user_id)
            mute.chatroom.save
            mute.destroy
            ActionCable.server.broadcast "room_channel", type: "chatrooms", action: "update"
        end
    end
  end
end
