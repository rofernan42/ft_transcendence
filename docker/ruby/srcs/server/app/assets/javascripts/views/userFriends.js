Transcendence.Views.FriendsIndex = Backbone.View.extend ({
    events: {
        "click .send-pm": "sendPM"
    },
    initialize: function () {
        this.listenTo(Transcendence.users, 'change:username change:guild add remove', this.render);
        this.listenTo(Transcendence.current_user, 'change', this.render);
        this.listenTo(Transcendence.friends, 'change add remove', this.render);
        this.listenTo(Transcendence.guilds, 'change add remove', this.render);
        this.listenTo(Transcendence.guild_invitations , 'change add remove', this.render);
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-user").addClass("active")
        var friends1 = this.collection.where({ user_one_id: Transcendence.current_user.id, pending: false });
        var friends2 = this.collection.where({ user_two_id: Transcendence.current_user.id, pending: false });
        var friends = friends1.concat(friends2);
        this.$el.html(JST['templates/users/friends']({
            friends: friends,
            pending1: this.collection.where({ user_one_id: Transcendence.current_user.id, pending: true }),
            pending2: this.collection.where({ user_two_id: Transcendence.current_user.id, pending: true })
        }));
        return this;
    },
    sendPM: function (e) {
        pr = Transcendence.private_rooms.find(function (pr) {
            return (pr.toJSON().users.includes(Transcendence.current_user.id)
            && pr.toJSON().users.includes(parseInt($(e.currentTarget).attr('id'))));
        });
        if (pr) {
            location.hash = "#private_rooms/" + pr.id;
        }
    }
});