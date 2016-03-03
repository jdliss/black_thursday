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
    assert_equal Time.parse("2009-02-07 00:00:00 -0700"), invoice.created_at
  end

  def test_can_find_date_updated
    assert_equal Time.parse("2014-03-15 00:00:00 -0600"), invoice.updated_at
  end
end
