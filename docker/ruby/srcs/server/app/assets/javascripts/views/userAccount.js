Transcendence.Views.UserAccount = Backbone.View.extend({
    events: {
        "submit #enable-2fa": "enable2fa",
        "submit #disable-2fa": "disable2fa"
    },
    render: function () {
        $(".nav-option").removeClass("active")
        $(".option-user").addClass("active")
        this.$el.html(JST['templates/users/edit_account']({ user: this.model.toJSON() }));
        return this;
    },
    enable2fa: function (e) {
        e.preventDefault();
        e.stopImmediatePropagation();
        $.ajax({
            type: "PUT",
            url: "/api/users/enable_2fa",
            data: new FormData($("#enable-2fa")[0]),
            dataType: "json",
            encode: true,
            processData: false,
            contentType: false,
        }).done(data => {
            Transcendence.current_user.set({ otp_required_for_login: true });
            Transcendence.otp_uri = data.otp_uri;
            this.render();
        });
    },
    disable2fa: function (e) {
        e.preventDefault();
        e.stopImmediatePropagation();
        $.ajax({
            type: "PUT",
            url: "/api/users/disable_2fa",
            encode: true,
            processData: false,
            contentType: false,
        }).done(data => {
            Transcendence.current_user.set({ otp_required_for_login: false });
            this.render();
        });
    }
});
