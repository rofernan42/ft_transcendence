Transcendence.Views.GamesIndex = Backbone.View.extend ({
    initialize: function () {
        this.listenTo(Transcendence.tournaments, 'add remove change', function () {
            $("#tournaments-list").empty();
            this.tournaments();
        });
        this.listenTo(Transcendence.current_user, 'add remove change', function () {
            $("#tournaments-list").empty();
            this.tournaments();
        });
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-play").addClass("active")
        this.$el.html(JST['templates/games/index']());
        this.tournaments();
        return this;
    },
    tournaments: function () {
        var tournaments = JST['templates/games/tournaments']();
        this.$('#tournaments-list').append(tournaments);
    }
});