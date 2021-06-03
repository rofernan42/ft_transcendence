Transcendence.Routers.Guilds = Backbone.Router.extend({
    routes: {
        "guilds": "index",
        "guilds/:id": "guild",
        "guilds/:id/wars": "wars",
        "guilds/:id/wars/new": "newWar"
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
        this.view = new Transcendence.Views.GuildsIndex({ collection: Transcendence.guilds });
        $('#main-body').html(this.view.render().$el);
    },
    guild: function (id) {
        if (!Transcendence.guilds.get(id)) {
            location.hash = "#guilds";
            flashMessage("error", "This guild doesn't exist !");
        } else {
            this.cleanUp();
            this.view = new Transcendence.Views.GuildsPanel({
                model: Transcendence.guilds.get(id),
                id: id
            });
            $('#main-body').html(this.view.render().$el);
        }
    },
    wars: function (id) {
        if (!Transcendence.guilds.get(id)) {
            location.hash = "#guilds";
            flashMessage("error", "This guild doesn't exist !");
        } else {
            this.cleanUp();
            this.view = new Transcendence.Views.GuildWars({
                model: Transcendence.guilds.get(id),
                id: id
            });
            $('#main-body').html(this.view.render().$el);
        }
    },
    newWar: function (id) {
        if (!Transcendence.guilds.get(id)) {
            location.hash = "#guilds";
            flashMessage("error", "This guild doesn't exist !");
        } else {
            if (Transcendence.current_user.id == Transcendence.guilds.get(id).toJSON().owner) {
                this.cleanUp();
                this.view = new Transcendence.Views.GuildWarsNew({
                    model: Transcendence.guilds.get(id),
                    id: id
                });
                $('#main-body').html(this.view.render().$el);
            } else {
                location.hash = "#guilds";
                flashMessage("error", "You are not allowed to access this page !");
            }
        }
    }
});