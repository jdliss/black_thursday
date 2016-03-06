require 'time'

class InvoiceItem
  attr_accessor :data,
                :invoice_item_repository

  def initialize(data, invoice_item_repository)
    @data = data
    @invoice_item_repository = invoice_item_repository
  end

  def id
    data[0].to_i
  end

  def item_id
    data[1].to_i
  end

  def invoice_id
    data[2].to_i
  end

  def quantity
    data[3].to_i
  end

  def unit_price
    num = '%.2f' % (data[4].to_f/100)
    BigDecimal.new(num)
  end

  def created_at
    Time.parse(data[5])
  end

  def updated_at
    Time.parse(data[6])
  end

  def unit_price_to_dollars
    unit_price.to_f.round(2)
  end
end
