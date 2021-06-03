Transcendence.Views.UserProfile = Backbone.View.extend ({
    events: {
        "click #send-pm": "sendPM"
    },
    initialize: function () {
        this.listenTo(Transcendence.users, 'change: username change: guild change:score', this.render);
        this.listenTo(Transcendence.current_user, 'change', this.render);
        this.listenTo(Transcendence.friends, 'change add remove', this.render);
        this.listenTo(Transcendence.guild_invitations, 'change add remove', this.render);
        this.listenTo(Transcendence.guilds, 'change add remove', this.render);
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-user").addClass("active")
        var friend = Transcendence.friends.findWhere({ user_one_id: Transcendence.current_user.id, user_two_id: this.model.toJSON().id });
        if (!friend) {
            friend = Transcendence.friends.findWhere({ user_two_id: Transcendence.current_user.id, user_one_id: this.model.toJSON().id });
        }
        var user_guild = null
        if (this.model.toJSON().guild && Transcendence.guilds.get(this.model.toJSON().guild)) {
            user_guild = Transcendence.guilds.get(this.model.toJSON().guild).toJSON();
        }
        this.$el.html(JST['templates/users/profile']({
            user: this.model.toJSON(),
            user_guild: user_guild,
            friend: friend,
            guild_invitations: this.collection.where({ user_id: Transcendence.current_user.id, pending: true }),
        }));
        return this;
    },
    sendPM: function (e) {
        pr = Transcendence.private_rooms.find(function (pr) {
            return (pr.toJSON().users.includes(Transcendence.current_user.id)
            && pr.toJSON().users.includes(parseInt($(e.currentTarget).attr('class'))));
        });
        if (pr) {
            location.hash = "#private_rooms/" + pr.id;
        }
    }
});
