class PrivateRoom < ApplicationRecord
    has_many :private_message, -> { order(:created_at) }, dependent: :destroy
end
