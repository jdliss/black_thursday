require_relative 'test_helper'
require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/customer_repository'
require_relative '../lib/customer'


class CustomerRepositoryTest < Minitest::Test
  attr_accessor :customer_repository

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv",
      :invoice_items => "./data/invoice_items_small.csv",
      :transactions  => "./data/transactions_small.csv",
      :customers => "./data/customers_small.csv"
    })

    @customer_repository = se.customers
  end

  def test_can_find_all_customers
    assert customer_repository.all.is_a?(Array)
    assert customer_repository.all[0].is_a?(Customer)
  end

  def test_can_find_customer_by_id
    assert customer_repository.find_by_id(1).is_a?(Customer)
    assert_equal nil, customer_repository.find_by_id("lsdhj")
  end

  def test_can_find_all_customers_by_first_name
    assert customer_repository.find_all_by_first_name("Joe").is_a?(Array)
    assert customer_repository.find_all_by_first_name("Joe")[0].is_a?(Customer)

    assert customer_repository.find_all_by_first_name("fghjk").is_a?(Array)
    assert customer_repository.find_all_by_first_name("fghjk").empty?
    assert customer_repository.find_all_by_first_name(123).empty?
  end

  def test_can_find_all_customers_by_last_name
    assert customer_repository.find_all_by_last_name("Ond").is_a?(Array)
    assert customer_repository.find_all_by_last_name("Ond")[0].is_a?(Customer)

    assert customer_repository.find_all_by_last_name("fghjk").is_a?(Array)
    assert customer_repository.find_all_by_last_name("fghjk").empty?
    assert customer_repository.find_all_by_last_name(123).empty?

  end
end
