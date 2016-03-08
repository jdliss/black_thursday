require 'time'
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
    merchant_data[0].to_i
  end

  def name
    merchant_data[1]
  end

  def created_at
    Time.parse(merchant_data[2])
  end

  def updated_at
    Time.parse(merchant_data[3])
  end

  def items
    merchant_repository.sales_engine.items.find_all_by_merchant_id(id)
  end

  def invoices
    merchant_repository.sales_engine.invoices.find_all_by_merchant_id(id)
  end

  def successful_invoices
    invoices.find_all { |invoice| invoice.is_paid_in_full? }
  end

  def successful_invoices_in_month(month)
    successful_invoices.find_all do |invoice|
      invoice.created_at.strftime("%B").downcase == month.downcase
    end
  end

  def customers
    merchant_invoices =
        merchant_repository.sales_engine.invoices.find_all_by_merchant_id(id)

    customer_ids = merchant_invoices.map do |invoice|
      invoice.customer_id
    end.uniq

    customers_repo = merchant_repository.sales_engine.customers

    customer_ids.map do |id|
      customers_repo.find_by_id(id)
    end
  end

  def revenue_for_merchant
    successful_invoices.reduce(0) do |total, invoice|
      if invoice.total.nil?
        total += 0
      else
        total += invoice.total
      end
      total
    end
  end
end
