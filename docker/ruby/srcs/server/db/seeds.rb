# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# users = [
#     {username: "Romain", email: "romain@mail.com", encrypted_password: "$2a$12$.qvkAddxMAgucNoH8JWHouphkuURGuCpeA9SDbSGKgGH/wibDiw8O", avatar: "/assets/blank-profile-picture.jpg", admin: true}
# ]
# users.each do |user_attr|
#     user = User.new(user_attr)
#     user.save
# end
unless User.exists?(1)
    users = [
        {username: "Romain", email: "romain@mail.com", encrypted_password: "$2a$12$.qvkAddxMAgucNoH8JWHouphkuURGuCpeA9SDbSGKgGH/wibDiw8O", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, avatar: "/assets/blank-profile-picture.jpg", superuser: true, admin: true},
        {username: "Raphael", email: "raphael@mail.com", encrypted_password: "$2a$12$.qvkAddxMAgucNoH8JWHouphkuURGuCpeA9SDbSGKgGH/wibDiw8O", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, avatar: "/assets/blank-profile-picture.jpg", superuser: true, admin: true},
        {username: "Mike", email: "mike@mail.com", encrypted_password: "$2a$12$.qvkAddxMAgucNoH8JWHouphkuURGuCpeA9SDbSGKgGH/wibDiw8O", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, avatar: "/assets/blank-profile-picture.jpg", superuser: true, admin: true}
    ]
    users.each do |user_attr|
        user = User.new(user_attr)
        user.save!(validate: false)
    end
end
