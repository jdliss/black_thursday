require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative '../lib/sales_engine'
require_relative '../lib/customer_repository'
require_relative '../lib/customer'

class CustomerTest < Minitest::Test
  attr_reader :customer,
              :customers

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv",
      :invoice_items => "./data/invoice_items_small.csv",
      :transactions  => "./data/transactions_small.csv",
      :customers => "./data/customers_small.csv"
    })

    @customers = se.customers
    @customer = @customers.all[0]
  end

  def test_can_return_id
    assert_equal 1, customer.id
  end

  def test_can_return_first_name
    assert_equal "Joey", customer.first_name
  end

  def test_can_return_last_name
    assert_equal "Ondricka", customer.last_name
  end

  def test_can_return_date_created_at
    assert_equal Time.parse("2012-03-27 14:54:09 UTC"), customer.created_at
  end

  def test_can_return_date_updated_at
    assert_equal Time.parse("2012-03-27 14:54:09 UTC"), customer.updated_at
  end

  def test_can_find_all_merchants_associated_with_customer
    merchants = customer.merchants

    refute merchants.empty?
    assert_equal 7, merchants.length
    assert merchants[0].is_a?(Merchant)
  end
end
