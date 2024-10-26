class Company < ApplicationRecord
  belongs_to :user
  validates :name ,presence: true , uniqueness: true
  validates :address ,presence: true
  validates :established_year ,presence: true
end
