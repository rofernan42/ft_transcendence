class Chat < ApplicationRecord
    belongs_to :user
    belongs_to :chatroom, inverse_of: :chat
end
