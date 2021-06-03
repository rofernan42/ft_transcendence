Transcendence.Views.GamesGame = Backbone.View.extend ({
    initialize: function () {
        this.listenTo(Transcendence.current_user, 'change add remove', this.render);
        this.listenTo(Transcendence.users, 'change add remove', this.render);
        this.listenTo(Transcendence.guilds, 'change add remove', this.render);
        this.listenTo(Transcendence.games, 'change add remove', this.render);
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-play").addClass("active")
        if (this.collection.get(this.id))
            var match = this.collection.get(this.id).toJSON();
        else
        {
            location.hash = "#games";
            return this
        }
        var user1 = Transcendence.users.get(match.user_one_id).toJSON();
        if (match.user_two_id != 0)
            var user2 = Transcendence.users.get(match.user_two_id).toJSON();
        else
            var user2 = null    
        this.$el.html(JST['templates/games/game']({
            match: match,
            user1: user1,
            user2: user2,
            }));
        return this
    },
});