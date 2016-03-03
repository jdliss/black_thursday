require 'minitest/autorun'
require 'minitest/pride'
require_relative '../lib/sales_engine'
require_relative '../lib/invoice_repository'
require_relative '../lib/invoice'

class InvoiceTest < Minitest::Test

  attr_accessor :invoice_repo,
                :invoice
  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv"
    })

    @invoice_repo = se.invoices
    @invoice = @invoice_repo.all[0]
  end

  def test_can_find_id
    assert_equal 1, invoice.id
  end

  def test_can_find_all_by_customer_id
    assert_equal 1, invoice.customer_id
  end

  def test_can_find_merchant_id
    assert_equal 12335938, invoice.merchant_id
  end

  def test_can_find_status
    assert_equal "pending", invoice.status
  end

  def test_can_find_date_created
    assert_equal Time.parse("2009-02-07"), invoice.created_at
  end

  def test_can_find_date_updated
    assert_equal Time.parse("2014-03-15"), invoice.updated_at
  end

  def test_can_traverse_chain_to_find_merchant_associated_with_invoice
    sales_engine = invoice.invoice_repository.sales_engine
    assert sales_engine.is_a?(SalesEngine)

    merchant = sales_engine.merchants.find_by_id(invoice.merchant_id)
    assert merchant.is_a?(Merchant)
    assert_equal merchant.id, invoice.merchant_id
  end

  def test_can_use_merchant_method_to_return_merchant_associated_with_invoice
    merchant = invoice.merchant
    assert_equal merchant.id, invoice.merchant_id
  end
end
