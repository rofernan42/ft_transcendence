Transcendence.Routers.Users = Backbone.Router.extend({
    routes: {
        "users": "index",
        "users/edit_account": "editAccount",
        "users/edit_profile": "editProfile",
        "users/friends": "friends",
        "users/:id": "profile"
    },
    initialize: function () {
        this.view = null;
    },
    cleanUp: function () {
        if (this.view)
            this.view.remove();
        this.view = null;
    },
    index: function () {
        this.cleanUp();
        this.view = new Transcendence.Views.UsersIndex({ collection: Transcendence.users });
        $('#main-body').html(this.view.render().$el);
    },
    editAccount: function () {
        this.cleanUp();
        this.view = new Transcendence.Views.UserAccount({ model: Transcendence.current_user });
        $('#main-body').html(this.view.render().$el);
    },
    editProfile: function () {
        this.cleanUp();
        this.view = new Transcendence.Views.UserEdit({ model: Transcendence.current_user });
        $('#main-body').html(this.view.render().$el);
    },
    friends: function () {
        this.cleanUp();
        this.view = new Transcendence.Views.FriendsIndex({ collection: Transcendence.friends });
        $('#main-body').html(this.view.render().$el);
    },
    profile: function (id) {
        if (!Transcendence.users.get(id)) {
            location.hash = "#users";
            flashMessage("error", "This user doesn't exist !");
        } else {
            this.cleanUp();
            this.view = new Transcendence.Views.UserProfile({
                model: Transcendence.users.get(id),
                id: id,
                collection : Transcendence.guild_invitations
            });
            $('#main-body').html(this.view.render().$el);
        }
    }
});