Transcendence.Views.PrivateRoomsIndex = Backbone.View.extend({
    events: {
        "click .send-pm": "sendPM"
    },
    initialize: function () {
        this.listenTo(Transcendence.private_rooms, "add remove", this.render);
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-user").addClass("active")
        var prs = this.collection.filter(function(pr){
            return pr.toJSON().users.includes(Transcendence.current_user.id);
        });
        this.$el.html(JST['templates/private_rooms/index']({ prs: prs }));
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
