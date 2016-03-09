# require 'minitest/autorun'
# require 'minitest/pride'
# require_relative '../lib/collections'
# require_relative '../lib/sales_engine'
# require_relative '../lib/sales_analyst'
#
# class CollectionsTest < Minitest::Test
#   attr_accessor :sa
#
#   def setup
#     se = SalesEngine.from_csv({
#       :items     => "./data/items.csv",
#       :merchants => "./data/merchants.csv",
#       :invoices  => "./data/invoices.csv",
#       :invoice_items => "./data/invoice_items.csv",
#       :transactions  => "./data/transactions.csv",
#       :customers => "./data/customers.csv"
#     })
#
#
#     @sa = SalesAnalyst.new(se)
#   end
#
#   def test_merchants_grouped_by_id
#     assert_equal 475, sa.merchants_grouped_by_id.count
#
#     assert sa.merchants_grouped_by_id[12337321][0].is_a?(Merchant)
#   end
# end
