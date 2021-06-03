Transcendence.Routers.Pongs = Backbone.Router.extend({
    routes: {
        "pongs/:id": "pong",
    },
    initialize: function () {
        this.view = null;
    },
    cleanUp: function () {
        if (this.view)
            this.view.remove();
        this.view = null;
    },
    pong: function (id) {
        if (Transcendence.current_user.toJSON().pong != id || id == 0) {
            location.hash = "#games";
            flashMessage("error", "This game doesn't exist !");
        } else {
            this.cleanUp();
            this.view = new Transcendence.Views.PongsGame({
                collection: Transcendence.pongs,
                id: id
            });
            $('#main-body').html(this.view.render().$el);
        }
    },
});