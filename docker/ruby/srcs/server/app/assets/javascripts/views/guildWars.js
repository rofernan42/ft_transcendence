Transcendence.Views.GuildWars = Backbone.View.extend({
    initialize: function () {
        this.listenTo(Transcendence.users, 'change add remove', this.render);
        this.listenTo(Transcendence.guilds, 'change add remove', this.render);
        this.listenTo(Transcendence.guild_wars, 'change add remove', this.render);
    },
    render: function () {
        $(".nav-option").removeClass("active");
        $(".option-guilds").addClass("active");
        if (!Transcendence.guilds.get(this.id)) {
            this.remove();
            location.hash = "#guilds";
        } else {
            this.$el.html(JST['templates/guilds/guild_wars']({
                curguild: this.model.toJSON(),
                warreq: Transcendence.guild_wars.where({ guild_two_id: this.model.toJSON().id, pending: true }),
                wardem: Transcendence.guild_wars.where({ guild_one_id: this.model.toJSON().id, pending: true }),
            }));
            this.$('.guilds-sidenav').append(JST['templates/guilds/guilds_sidenav']());
        }
        return this
    },
});