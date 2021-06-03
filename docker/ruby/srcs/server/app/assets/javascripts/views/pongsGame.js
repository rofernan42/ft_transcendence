Transcendence.Views.PongsGame = Backbone.View.extend({
    initialize: function () {
        this.listenTo(Transcendence.current_user, 'change', this.render);
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-play").addClass("active")
        if (Transcendence.current_user.toJSON().pong == 0 || this.id == 0) {
            this.remove();
            location.hash = "#games";
            return;
        }
        // setTimeout(() => {
            pong = this.collection.findWhere({ room_id: parseInt(this.id) }).toJSON()
            this.$el.html(JST['templates/games/pong']({
                user_left: Transcendence.users.findWhere({ id: pong.user_left_id }).toJSON(),
                user_right: Transcendence.users.findWhere({ id: pong.user_right_id }).toJSON(),
            }));
        // }, 500);
        return this;
    },
});