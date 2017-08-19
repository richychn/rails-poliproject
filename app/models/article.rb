class Article < ApplicationRecord
  validates :url, presence: true, uniqueness: true
  validates :bias, presence: true
end
