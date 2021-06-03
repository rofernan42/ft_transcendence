json.extract! private_room, :id, :users, :private_message
json.url private_room_url(private_room, format: :json)
