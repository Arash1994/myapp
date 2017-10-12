class Category < ApplicationRecord
	has_many :posts
	has_many :intrests
	has_many :users, through: :intrests
 validates :name, presence: true
end
