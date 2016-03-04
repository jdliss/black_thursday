require 'time'

class Invoice
  attr_accessor :invoice_data,
                :invoice_repository

  def initialize(invoice_data, invoice_repository)
    @invoice_repository = invoice_repository
    @invoice_data = invoice_data
  end

  def id
    invoice_data[0].to_i
  end

  def customer_id
    invoice_data[1].to_i
  end

  def merchant_id
    invoice_data[2].to_i
  end

  def status
    invoice_data[3].to_sym
  end

  def created_at
    Time.parse(invoice_data[4])
  end

  def updated_at
    Time.parse(invoice_data[5])
  end

  def merchant
    invoice_repository.sales_engine.merchants.find_by_id(merchant_id)
  end
end
