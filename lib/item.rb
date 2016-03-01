class Item
  attr_accessor :item

  def initialize(item)
    @item = item
  end

  def id
    item[0]
  end

  def name
    item[1]
  end

  def description
    item[2]
  end

  def unit_price
    item[3]
  end

  def merchant_id
    item[4]
  end

  def created_at
    item[5]
  end

  def updated_at
    item[6]
  end

  def unit_price_to_dollars
    unit_price.to_f.round(2)
  end

end
