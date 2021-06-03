var Chatroom = Backbone.Model.extend({
    defaults:{
        id: "",
        name: "",
        chatroom_type: "",
        owner: "",
    },
    urlRoot: "/api/chatrooms"
});
