Transcendence.Views.GuildsIndex = Backbone.View.extend ({
    initialize: function () {
        this.listenTo(Transcendence.current_user, 'change add remove', this.render);
        this.listenTo(Transcendence.users, 'change:username', this.render);
        this.listenTo(Transcendence.guilds, 'change add remove', this.render);
    },
    render: function () {
        $(".nav-option").removeClass("active");
        $(".option-guilds").addClass("active");
        this.$el.html(JST['templates/guilds/index']());
        this.$('.guilds-sidenav').append(JST['templates/guilds/guilds_sidenav']());
        return this;
    },
});