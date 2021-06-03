Transcendence.Views.HomeAdmin = Backbone.View.extend({
    initialize: function () {
        this.listenTo(Transcendence.users, 'change:admin', function () {
            this.render();
            $("#admins-actions").show();
        });
        this.listenTo(Transcendence.users, 'change:banned', function () {
            this.render();
            $("#bans-actions").show();
        });
        this.listenTo(Transcendence.chatrooms, 'remove', function () {
            this.render();
            $("#chatrooms-actions").show();
        });
        this.listenTo(Transcendence.tournaments, 'add remove', function () {
            this.render();
            $("#tournaments-actions").show();
        });
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-home").addClass("active")
        if (Transcendence.current_user.toJSON().superuser == false && Transcendence.current_user.toJSON().admin == false) {
            this.remove();
            location.hash = "#";
        } else {
            this.$el.html(JST['templates/home/admin_panel']({
                members: Transcendence.users.toJSON(),
                admins: Transcendence.users.where({ admin: true }),
                banned: Transcendence.users.where({ banned: true })
            }));
            return this;
        }
    }
});
