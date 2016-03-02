gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/merchant"
require_relative '../lib/merchant_repository'
require_relative '../lib/sales_engine'

class MerchantTest < Minitest::Test
  attr_accessor :items_repository,
                :merchant
  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
    })

    @merchant_repository = se.merchants
    @merchant = @merchant_repository.all[3]
  end


  # TODO TEST EDGE CASES
  def test_can_return_id_of_merchant
    assert_equal "12334115", merchant.id
  end

  def test_can_return_name_of_merchant
    assert_equal "LolaMarleys", merchant.name
  end

  def test_can_traverse_object_links_and_find_items_linked_to_merchant
    sales_engine = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv"})

    new_merchant = sales_engine.merchants.find_by_id("12334185")
    assert new_merchant.is_a?(Merchant)

    assert new_merchant.merchant_repository.is_a?(MerchantRepository)
    merchant_repository = new_merchant.merchant_repository

    assert merchant_repository.sales_engine.item_repository.is_a?(ItemRepository)
    items = merchant_repository.sales_engine.item_repository
    merchant_items = items.find_all_by_merchant_id("12334185")

    assert_equal 3, merchant_items.length
    assert_equal "Glitter scrabble frames", merchant_items[0].name
  end

  def test_can_find_all_merchant_items_using_merchant_items_method
    new_merchant = @merchant_repository.all[9]
    assert new_merchant.items.is_a?(Array)
    assert new_merchant.is_a?(Merchant)
    assert_equal 3, new_merchant.items.length
  end
end
