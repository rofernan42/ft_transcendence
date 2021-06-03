Transcendence.Views.PrivateRoomShow = Backbone.View.extend({
    events: {
    },
    initialize: function () {
        this.listenTo(this.model, "change add remove", function () {
            if (!Transcendence.private_rooms.get(this.id)) {
                this.remove();
                location.hash = "#private_rooms";
            } else {
                this.$('#private-messages').empty();
                var pms = JST['templates/private_rooms/private_messages']({ pm: this.model.toJSON().private_message });
                this.$('#private-messages').append(pms);
            }
        });
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-user").addClass("active")
        var prs = this.collection.filter(function (pr) {
            return pr.toJSON().users.includes(Transcendence.current_user.id);
        });
        var to_user = this.model.toJSON().users.filter(function (usr) {
            return usr != Transcendence.current_user.id;
        })
        this.$el.html(JST['templates/private_rooms/private_room']({
            prs: prs,
            pr: this.model.toJSON(),
            to_user: Transcendence.users.get(to_user).toJSON()
        }));
        var pms = JST['templates/private_rooms/private_messages']({
            pm: this.model.toJSON().private_message
        });
        this.$('#private-messages').append(pms);
        return this;
    },
});