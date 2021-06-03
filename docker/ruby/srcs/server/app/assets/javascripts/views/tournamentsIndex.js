Transcendence.Views.TournamentsIndex = Backbone.View.extend({
    events: {
    },
    initialize: function () {
        this.listenTo(this.collection, 'add remove change', this.render);
        this.listenTo(Transcendence.users, 'add remove change', this.render);
    },
    render: function () {
        this.$el.html(JST['templates/games/tournaments']({}));
        return this;
    }
});
