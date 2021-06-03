class AdminController < ApplicationController
    before_action :authenticate_user!

    def set_admin
        user = User.find_by_username(params[:username])
        if user
            if is_superuser(current_user) && !is_sadmin(user) && user.banned == false
                user.admin = true
                user.save
                flash[:notice] = "You have been promoted admin of the website !"
                ActionCable.server.broadcast "flash_admin_channel:#{user.id}", type: "flash", flash: flash
                ActionCable.server.broadcast "users_channel", content: "profile"
            end
        end
    end

    def unset_admin
        user = User.find_by_username(params[:username])
        if user
            if is_superuser(current_user) && !is_superuser(user)
                user.admin = false
                user.save
                ActionCable.server.broadcast "users_channel", content: "profile"
            end
        end
    end

    def ban_user
        user = User.find_by_username(params[:username])
        if user
            if is_sadmin(current_user) && !is_sadmin(user) && !is_superuser(user)
                user.banned = true
                user.save
                flash[:error] = "You have been banned of the website !"
                ActionCable.server.broadcast "flash_admin_channel:#{user.id}", type: "flash", flash: flash
                ActionCable.server.broadcast "users_channel", content: "profile"
                ActionCable.server.broadcast "users_channel:#{user.id}", content: "banned"
            end
        end
    end

    def unban_user
        user = User.find_by_username(params[:username])
        if user
            if is_sadmin(current_user)
                user.banned = false
                user.save
                ActionCable.server.broadcast "users_channel", content: "profile"
            end
        end
    end
end
