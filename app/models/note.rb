class Note < ApplicationRecord
  belongs_to :user
  # belongs_to :pair

  validates :content, presence: true, length: { maximum: 140 }



end
