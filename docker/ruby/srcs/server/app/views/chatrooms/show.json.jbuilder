json.extract! @chatroom, :id, :name, :chatroom_type, :owner, :admin, :banned, :members, :muted, :chat
json.url chatroom_url(@chatroom, format: :json)
