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

  def invoice_items
    invoice_repository.sales_engine.invoice_items.find_all_by_invoice_id(id)
  end

  def items
    invoice_items.map do |invoice_item|
      invoice_repository.sales_engine.items.find_by_id(invoice_item.item_id)
    end.compact
  end

  def transactions
    invoice_repository.sales_engine.transactions.find_all_by_invoice_id(id)
  end

  def customer
    invoice_repository.sales_engine.customers.find_by_id(customer_id)
  end

  def is_paid_in_full?
    transactions.any? { |transaction| transaction.result == "success" }
  end

  def total
    invoice_items.map do |invoice_item|
      invoice_item.unit_price * invoice_item.quantity
    end.reduce(:+)
  end
end
