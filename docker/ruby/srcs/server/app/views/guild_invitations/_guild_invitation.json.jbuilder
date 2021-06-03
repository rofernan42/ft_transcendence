json.extract! guild_invitation, :id, :user_id, :guild_id, :pending
json.url guild_invitation_url(guild_invitation, format: :json)
