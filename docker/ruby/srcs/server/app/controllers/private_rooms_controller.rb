class PrivateRoomsController < ApplicationController
    before_action :authenticate_user!
    before_action :load_entities, only: [:index, :show]
    before_action { flash.clear }

    def index
    end

    def show
    end

    def create
        if !pr_exists(params[:private_room][:user1], params[:private_room][:user2]) \
        && params[:private_room][:user1] != params[:private_room][:user2]
            private_room = PrivateRoom.new
            user1 = params[:private_room][:user1]
            user2 = params[:private_room][:user2]
            private_room.users.push(user1)
            private_room.users.push(user2)
            if private_room.save
                ActionCable.server.broadcast "room_channel", type: "private_rooms", action: "update", updateType: "add", roomid: private_room.id, userid: current_user.id
            else
                respond_to do |format|
                    flash[:error] = "Something is wrong"
                    ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
                    format.json { render json: { private_room: private_room }, status: :unprocessable_entity }
                end
            end
        end
    end

    def destroy
        private_room = PrivateRoom.find(params[:id])
        private_room.destroy
        ActionCable.server.broadcast "room_channel", type: "private_rooms", action: "update", updateType: "destroy"
        # respond_to do |format|
            # flash[:notice] = "This conversation was deleted successfully"
            # ActionCable.server.broadcast "chatrooms_channel", content: "ok"
            # ActionCable.server.broadcast "flash_admin_channel:#{current_user.id}", type: "flash", flash: flash
            # format.json { head :no_content }
        # end
    end

    private
    def load_entities
        @private_rooms = PrivateRoom.all
        @private_room = PrivateRoom.find(params[:id]) if params[:id]
    end
    def permitted_parameters
        params.require(:private_room).permit(:users)
    end
    def pr_exists(user_1, user_2)
        if (!PrivateRoom.where(users: [user_1, user_2]).empty? \
        || !PrivateRoom.where(users: [user_2, user_1]).empty?)
            return 1
        end
        return nil
    end
end
