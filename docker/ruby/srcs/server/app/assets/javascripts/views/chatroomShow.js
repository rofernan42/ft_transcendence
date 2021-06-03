Transcendence.Views.ChatroomShow = Backbone.View.extend({
    events: {
        "click .member-name, .member-owner, .member-admin": "menu",
        "click .send-pm": "sendPM"
    },
    initialize: function () {
        this.listenTo(this.model, "change:name change:chatroom_type", this.render);
        this.listenTo(this.model, "change:chat add:chat", function () {
            this.$('#messages').empty();
            var msgs = JST['templates/chatrooms/messages']({ chat: this.model.toJSON().chat });
            this.$('#messages').append(msgs);
        });
        this.listenTo(Transcendence.chatrooms.get(this.id), 'change:owner change:members change:admin change:muted remove', function () {
            if (!Transcendence.chatrooms.get(this.id)
                || (!Transcendence.chatrooms.get(this.id).toJSON().members.includes(Transcendence.current_user.id)
                    && !Transcendence.chatrooms.get(this.id).toJSON().banned.includes(Transcendence.current_user.id)
                    && Transcendence.current_user.toJSON().admin == false
                    && Transcendence.current_user.id != Transcendence.chatrooms.get(this.id).toJSON().owner)
            ) {
                this.remove();
                location.hash = "#chatrooms/public";
            } else {
                this.model = Transcendence.chatrooms.get(this.id);
                if (Transcendence.current_user.toJSON().admin == true || this.model.toJSON().owner == Transcendence.current_user.id) {
                    this.$('#chatroom-edit-panel').empty();
                    var editPanel = JST['templates/chatrooms/edit_panel']({ chatroom: this.model.toJSON() });
                    this.$('#chatroom-edit-panel').append(editPanel);
                }
                this.$('#members').empty();
                this.members();
            }
        });
        this.listenTo(Transcendence.current_user, 'change', this.render);
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-chatrooms").addClass("active")
        this.$el.html(JST['templates/chatrooms/chatroom']({ chatroom: this.model.toJSON() }));
        this.members();
        var msgs = JST['templates/chatrooms/messages']({ chat: this.model.toJSON().chat });
        this.$('#messages').append(msgs);
        var flashMsg = JST['templates/chatrooms/flash_messages']({ chatroom: this.model.toJSON() });
        this.$('#flash-messages').append(flashMsg);
        if (Transcendence.current_user.toJSON().admin == true || this.model.toJSON().owner == Transcendence.current_user.id) {
            var editPanel = JST['templates/chatrooms/edit_panel']({ chatroom: this.model.toJSON() });
            this.$('#chatroom-edit-panel').append(editPanel);
        }
        if (this.model.toJSON().chatroom_type == "public") {
            this.$('#optpublic').addClass('active');
        } else if (this.model.toJSON().chatroom_type == "private") {
            this.$('#optpriv').addClass('active');
        }
        setTimeout(function () {
            let roomId = $('.current_chatroom_id').data('roomid')
            sessionStorage.setItem("chat_roomid", roomId)
        })
        return this;
    },
    members: function () {
        var members = JST['templates/chatrooms/members']({ chatroom: this.model.toJSON() });
        this.$('#members').append(members);
    },
    menu: function (e) {
        if (Transcendence.current_user.toJSON().id != $(e.currentTarget).attr('id'))
            $(e.currentTarget).next(e.currentTarget.nextElementSibling).slideToggle(300);
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
