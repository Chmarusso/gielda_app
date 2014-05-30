class Company < ActiveRecord::Base
  has_many :quotes
  scope :by_name, ->(name) { where(name: name).limit(1).first }
  validates :name, uniqueness: true

end
