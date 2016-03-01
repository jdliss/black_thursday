gem 'minitest', '~> 5.2'
require 'minitest/autorun'
require 'minitest/pride'
require_relative "../lib/merchant"
require_relative '../lib/merchant_repository'

class ItemTest < Minitest::Test
  attr_accessor :merchant
  def setup
    merchant_repository = MerchantRepository.new("./data/merchants.csv")
    @merchant = merchant_repository.all[0]
  end

  def test_can_return_id_of_merchant
    assert_equal "12334105", merchant.id
  end

  def test_can_return_name_of_merchant
    assert_equal "Shopin1901", merchant.name
  end
end
