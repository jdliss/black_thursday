require_relative 'item_repository'
require_relative 'merchant_repository'

class Merchant
  attr_accessor :merchant_data,
                :merchant_repository

  def initialize(merchant_data, merchant_repository)
    @merchant_data = merchant_data
    @merchant_repository = merchant_repository
  end

  def id
    merchant_data[0]
  end

  def name
    merchant_data[1]
  end

  def items
    merchant_repository.sales_engine.item_repository.find_all_by_merchant_id(id)
  end
end
