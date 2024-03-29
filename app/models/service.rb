class Service < ApplicationRecord
  belongs_to :contract
  belongs_to :user
  belongs_to :reason, optional: true

  has_many :service_items, dependent: :destroy
  has_many :items, through: :service_items
  has_many :service_parts, dependent: :destroy

  enum request_type: [:monthly, :repair]
  enum status: [:open, :done, :paid, :denied, :delayed]

  def service_total_price
    price = self.contract.total_price
    self.service_parts.each do |part|
      price += (part.price * part.qty)
    end
    price
  end
end
