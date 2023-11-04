class PhoneNumber < ApplicationRecord
  validates :number, presence: true, format: { with: /\A\d{10}\z/ }

  belongs_to :employee
end
