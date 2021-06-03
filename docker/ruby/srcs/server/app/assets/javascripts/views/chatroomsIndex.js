Transcendence.Views.ChatroomsIndex = Backbone.View.extend({
    events: {
        "submit .sideform": "erase"
    },
    initialize: function () {
        this.listenTo(this.collection, 'add remove change:members change:banned change:name change:chatroom_type change:owner', function () {
            this.$('#chatrooms-list').empty();
            this.chatroomType();
        });
    },
    render: function () {
        this.$el.html(JST['templates/chatrooms/index']());
        this.chatroomType();
        return this;
    },
    chatroomType: function () {
        $(".nav-option").removeClass("active")
        $(".option-chatrooms").addClass("active")
        if (window.location.hash == "#chatrooms/public" || window.location.hash == "#chatrooms") {
            this.$('#optpublic').addClass('active');
            var chatroomView = JST['templates/chatrooms/public']({ chatrooms: this.collection.where({chatroom_type: "public"}) });
        } else if (window.location.hash == "#chatrooms/private") {
            this.$('#optpriv').addClass('active');
            var chatroomView = JST['templates/chatrooms/private']({ chatrooms: this.collection.where({chatroom_type: "private"}) });
        } else if (window.location.hash == "#chatrooms/my_chatrooms") {
            this.$('#optmych').addClass('active');
            var joined = this.collection.filter(function(chatroom){
                return chatroom.toJSON().members.includes(Transcendence.current_user.id);
            });
            var chatroomView = JST['templates/chatrooms/my_chatrooms']({
                owned: this.collection.where({owner: Transcendence.current_user.id}),
                joined: joined
            });
        }
        this.$('#chatrooms-list').append(chatroomView);
    },
    erase: function () {
        setTimeout(function () {
            $('input[type=text]').val('');
            $('input[type=password]').val('');
        });
    }
});
