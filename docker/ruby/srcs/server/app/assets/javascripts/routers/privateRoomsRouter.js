Transcendence.Routers.PrivateRooms = Backbone.Router.extend({
    routes: {
        "private_rooms": "index",
        "private_rooms/:id": "show",
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
        this.view = new Transcendence.Views.PrivateRoomsIndex({ collection: Transcendence.private_rooms });
        $('#main-body').html(this.view.render().$el);
    },
    show: function (id) {
        if (!Transcendence.private_rooms.get(id)) {
            location.hash = "#private_rooms";
            flashMessage("error", "This page doesn't exist !");
        } else {
            if (Transcendence.private_rooms.get(id).toJSON().users.includes(Transcendence.current_user.id)) {
                this.cleanUp();
                this.view = new Transcendence.Views.PrivateRoomShow({
                    collection: Transcendence.private_rooms,
                    model: Transcendence.private_rooms.get(id),
                    id: id
                });
                $('#main-body').html(this.view.render().$el);
            } else {
                location.hash = "#private_rooms";
                flashMessage("error", "You are not allowed to access this page !");
            }
        }
    }
});