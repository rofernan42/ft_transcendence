Transcendence.Routers.Chatrooms = Backbone.Router.extend({
    routes: {
        "chatrooms": "index",
        "chatrooms/public": "index",
        "chatrooms/private": "index",
        "chatrooms/my_chatrooms": "index",
        "chatrooms/:id": "show",
        "chatrooms/:id/edit": "edit",
        "chatrooms/:id/admin": "admin",
    },
    initialize: function () {
        this.view = null;
    },
    cleanUp: function () {
        if (this.view)
            this.view.remove();
        this.view = null;
    },
    index: function () {
        this.cleanUp();
        this.view = new Transcendence.Views.ChatroomsIndex({ collection: Transcendence.chatrooms });
        $('#main-body').html(this.view.render().$el);
    },
    show: function (id) {
        if (!Transcendence.chatrooms.get(id)) {
            location.hash = "#chatrooms/public";
            flashMessage("error", "This chatroom doesn't exist !");
        } else {
            if (
                Transcendence.current_user.toJSON().admin == true
                || Transcendence.current_user.id == Transcendence.chatrooms.get(id).toJSON().owner
                || Transcendence.chatrooms.get(id).toJSON().members.includes(Transcendence.current_user.id)
            ) {
                this.cleanUp();
                this.view = new Transcendence.Views.ChatroomShow({
                    id: id,
                    model: Transcendence.chatrooms.get(id)
                });
                $('#main-body').html(this.view.render().$el);
            } else {
                if (Transcendence.chatrooms.get(id).toJSON().banned.includes(Transcendence.current_user.id)) {
                    msg = "You have been banned from this chatroom !"
                }
                else {
                    msg = "You are not a member of this chatroom !"
                }
                var hash = Transcendence.chatrooms.get(id).toJSON().chatroom_type
                location.hash = "#chatrooms/" + hash;
                flashMessage("error", msg);
            }
        }
    },
    admin: function (id) {
        if (!Transcendence.chatrooms.get(id)) {
            location.hash = "#chatrooms/public";
            flashMessage("error", "This chatroom doesn't exist !");
        } else {
            if (
                Transcendence.current_user.toJSON().admin == true
                || Transcendence.current_user.id == Transcendence.chatrooms.get(id).toJSON().owner
                || Transcendence.chatrooms.get(id).toJSON().admin.includes(Transcendence.current_user.id)
            ) {
                this.cleanUp();
                this.view = new Transcendence.Views.ChatroomAdmin({
                    model: Transcendence.chatrooms.get(id).toJSON(),
                    id: id,
                });
                $('#main-body').html(this.view.render().$el);
            } else {
                var loc = "#chatrooms/" + id;
                location.hash = loc;
                flashMessage("error", "You are not admin of this chatroom !");
            }
        }
    }
});
