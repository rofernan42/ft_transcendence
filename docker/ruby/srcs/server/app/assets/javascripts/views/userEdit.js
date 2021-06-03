Transcendence.Views.UserEdit = Backbone.View.extend ({
    events: {
        "submit #user-edit-profile": "reload"
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-user").addClass("active")
        this.$el.html(JST['templates/users/edit_profile']({ user: this.model.toJSON() }));
        return this;
    },
    reload: function () {
        setTimeout(function () {
            document.location.reload()
        }, 500)
    }
});
