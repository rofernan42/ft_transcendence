class PrivateMessagesController < ApplicationController
    before_action :authenticate_user!

    def create
        prid = params[:pm][:pr_id]
        pr = PrivateRoom.find_by_id(prid)
        pm = PrivateMessage.create(pm_params)
        pm.date_creation = Time.now.strftime('%I:%M %p')
        respond_to do |format|
            if pm.save
                ActionCable.server.broadcast "room_channel", type: "private_rooms", action: "chats", content: pm
                format.html { redirect_to pm, notice: "PM was successfully created." }
                format.json { render :show, status: :created, location: pm }
                format.js
            else
                format.json { render json: pm.errors, status: :unprocessable_entity }
            end
        end
    end
    private
    def pm_params
        params.require(:pm).permit(:message, :user_id, :private_room_id)
    end
end
