gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/merchant"
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'

class ItemTest < Minitest::Test
  attr_accessor :items_repository,
                :merchant
  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
    })

    @merchant_repository = se.merchants
    @merchant = @merchant_repository.all[3]
  end

  def test_can_return_id_of_merchant
    assert_equal "12334115", merchant.id
  end

  def test_can_return_name_of_merchant
    assert_equal "LolaMarleys", merchant.name
  end

  def test_can_traverse_object_links_and_find_items_linked_to_merchant
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv"})

    new_merchant = sales_engine.merchants.find_by_id("12334105")
    assert new_merchant.is_a?(Merchant)

    assert new_merchant.merchant_repository.is_a?(MerchantRepository)
    merchant_repository = new_merchant.merchant_repository

    assert merchant_repository.sales_engine.item_repository.is_a?(ItemRepository)
    items = merchant_repository.sales_engine.item_repository
    merchant_items = items.find_all_by_merchant_id("12334105")

    assert_equal 3, merchant_items.length
    assert_equal "Vogue Paris Original Givenchy 2307", merchant_items[0].name
  end

  def test_can_find_all_merchant_items_using_merchant_items_method
    new_merchant = @merchant_repository.all[30]
    assert new_merchant.items.is_a?(Array)
    assert new_merchant.is_a?(Merchant)
    assert_equal 10, new_merchant.items.length
  end
end
