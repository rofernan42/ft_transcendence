Transcendence.Views.ChatroomAdmin = Backbone.View.extend({
    initialize: function () {
        this.listenTo(Transcendence.chatrooms.get(this.id), 'change:admin change:banned change:muted remove', function () {
            if (!Transcendence.chatrooms.get(this.id)) {
                this.remove();
                location.hash = "#chatrooms/public";
            } else {
                this.model = Transcendence.chatrooms.get(this.id).toJSON();
                this.render();
            }
        });
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-chatrooms").addClass("active")
        if (
            Transcendence.current_user.toJSON().admin == false
            && Transcendence.current_user.id != Transcendence.chatrooms.get(this.id).toJSON().owner
            && !Transcendence.chatrooms.get(this.id).toJSON().admin.includes(Transcendence.current_user.id)
        ) {
            this.remove();
            var loc = "#chatrooms/" + this.id;
            location.hash = loc;
        } else {
            this.$el.html(JST['templates/chatrooms/admin_panel']({
                chatroom: this.model,
                members: this.model.members,
                admins: this.model.admin,
                banned: this.model.banned,
                muted: this.model.muted
            }));
        }
        return this;
    },
});
