gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/merchant"
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'

class MerchantTest < Minitest::Test
  attr_accessor :merchant_repository,
                :merchant
  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv",
      :invoice_items => "./data/invoice_items_small.csv",
      :transactions  => "./data/transactions_small.csv",
      :customers => "./data/customers_small.csv"
    })

    @merchant_repository = se.merchants
    @merchant = @merchant_repository.all[3]
  end


  # TODO TEST EDGE CASES
  def test_can_return_id_of_merchant
    assert_equal 12334123, merchant.id
  end

  def test_can_return_name_of_merchant
    assert_equal "Keckenbauer", merchant.name
  end

  def test_can_traverse_object_links_and_find_items_linked_to_merchant
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv"})

    new_merchant = sales_engine.merchants.find_by_id(12334185)
    assert new_merchant.is_a?(Merchant)

    assert new_merchant.merchant_repository.is_a?(MerchantRepository)
    merchant_repository = new_merchant.merchant_repository

    assert merchant_repository.sales_engine.items.is_a?(ItemRepository)
    items = merchant_repository.sales_engine.items
    merchant_items = items.find_all_by_merchant_id(12334185)

    assert_equal 3, merchant_items.length
    assert_equal "Glitter scrabble frames", merchant_items[0].name
  end

  def test_can_find_all_merchant_items_using_merchant_items_method
    new_merchant = @merchant_repository.all[8]
    assert new_merchant.items.is_a?(Array)
    assert new_merchant.is_a?(Merchant)
    assert_equal 3, new_merchant.items.length
  end

  def test_can_traverse_chain_to_find_invoices_associated_with_merchant
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv"
    })

    merchant = se.merchants.all[9]
    sales_engine = merchant.merchant_repository.sales_engine
    assert sales_engine.is_a?(SalesEngine)

    invoices = sales_engine.invoices.find_all_by_merchant_id(merchant.id)
    assert invoices.is_a?(Array)
    assert invoices[0].is_a?(Invoice)
  end

  def test_can_use_invoices_method_of_merchant
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv"
    })
    merchant = se.merchants.all[9]

    assert_equal merchant.invoices[0].merchant_id, merchant.id
  end

  def test_can_find_all_customers_of_merchant
    merchant = merchant_repository.all.last
    customers = merchant.customers

    refute customers.empty?
    assert_equal 2, customers.length
    assert customers[0].is_a?(Customer)
  end
end
