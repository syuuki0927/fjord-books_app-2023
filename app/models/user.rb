# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [150, 150]
    attachable.variant :icon_inline, resize_to_limit: [50, 50]
  end
  has_many :report, dependent: :destroy
end
