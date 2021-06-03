class Chatroom < ApplicationRecord
    has_many :chat, -> { order(:created_at) }, dependent: :destroy, inverse_of: :chatroom
    validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { in: 3..20 }
    validates :password, :if => :check_if_private, presence: true, length: { minimum: 6 }
    has_many :chatroom_ban, dependent: :destroy
    has_many :chatroom_mute, dependent: :destroy

    def check_if_private
        chatroom_type == "private"
    end

    def as_json(options = {})
        super(options.merge(except: [ :password ]))
    end
end
