class Guild < ApplicationRecord
    validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { in: 4..12 }
    validates :anagram, presence: true, uniqueness: { case_sensitive: false }, length: { in: 5..5 }
    has_many :guild_invitation, dependent: :destroy
end
