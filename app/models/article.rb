class Article < ApplicationRecord
  validates :url, presence: true, uniqueness: true
end
