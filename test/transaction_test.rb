require 'minitest/autorun'
require 'minitest/pride'
require 'time'
require_relative '../lib/sales_engine'
require_relative '../lib/transaction_repository'
require_relative '../lib/transaction'

class TransactionTest < Minitest::Test
  attr_reader :transaction,
              :transactions

  def setup
    se = SalesEngine.from_csv({
      :items     => "./data/items_small.csv",
      :merchants => "./data/merchants_small.csv",
      :invoices  => "./data/invoices_small.csv",
      :invoice_items => "./data/invoice_items_small.csv",
      :transactions  => "./data/transactions_small.csv",
      :customers => "./data/customers_small.csv"
    })

    @transactions = se.transactions
    @transaction = @transactions.all[0]
  end

  def test_can_return_id
    assert_equal 1, transaction.id
  end

  def test_can_return_invoice_id
    assert_equal 2179, transaction.invoice_id
  end

  def test_can_return_credit_card_number
    assert_equal 4149654190362629, transaction.credit_card_number
  end

  def test_can_return_credit_card_expiration_date
    assert_equal "0217", transaction.credit_card_expiration_date
  end

  def test_can_return_transaction_result
    assert_equal "success", transaction.result
  end

  def test_can_return_time_created_at
    assert_equal Time.parse("2012-02-26 20:56:56 UTC"), transaction.created_at
  end

  def test_can_return_time_updated_at
    assert_equal Time.parse("2012-02-26 20:56:56 UTC"), transaction.updated_at
  end

  def test_can_find_invoice_connected_to_transaction
    invoice = transaction.invoice

    assert invoice.is_a?(Invoice)
    assert_equal invoice.id, transaction.invoice_id
  end
end
