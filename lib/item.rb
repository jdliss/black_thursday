require 'bigdecimal'

class Item
  attr_accessor :item_data,
                :item_repository

  def initialize(item_data, item_repository)
    @item_repository = item_repository
    @item_data = item_data
  end

  def merchant
    item_repository.sales_engine.merchant_repository.find_by_id(merchant_id)
  end

  def id
    item_data[0].to_i
  end

  def name
    item_data[1]
  end

  def description
    item_data[2]
  end

  def unit_price
    num = '%.2f' % (item_data[3].to_f/100)
    BigDecimal.new(num)
  end

  def merchant_id
    item_data[4].to_i
  end

  def created_at
    Time.parse(item_data[5])
  end

  def updated_at
    Time.parse(item_data[6])
  end

  def unit_price_to_dollars
    unit_price.to_f.round(2)
  end

end
