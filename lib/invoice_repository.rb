require_relative "invoice.rb"

class InvoiceRepository

  attr_accessor :invoices,
                :sales_engine

  def initialize(invoice_data, sales_engine)
    @sales_engine = sales_engine

    @invoices = invoice_data.map do |invoice|
      Invoice.new(invoice, self)
    end
  end

  def all
    invoices
  end

  def find_by_id(id)
    invoices.find { |invoice| invoice.id == id }
  end

  def find_all_by_customer_id(customer_id)
    invoices.find_all { |invoice| invoice.customer_id == customer_id }
  end

  def find_all_by_merchant_id(merchant_id)
    invoices.find_all { |invoice| invoice.merchant_id == merchant_id}
  end

  def find_all_by_status(status)
    invoices.find_all { |invoice| invoice.status.downcase == status.downcase }
  end
end
