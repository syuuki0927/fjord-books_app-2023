class Report < ApplicationRecord
  belongs_to :user
  has_many :comment, as: :commentable, dependent: :destroy
end
