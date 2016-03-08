require_relative 'sales_engine'
require_relative 'transaction'

class TransactionRepository
  attr_accessor :transactions,
                :sales_engine

  def initialize(transaction_data, sales_engine)
    @sales_engine = sales_engine

    @transactions ||= transaction_data.map do |transaction|
      Transaction.new(transaction, self)
    end
  end

  def inspect
    "#<#{self.class} #{@transactions.size} rows>"
  end

  def all
    transactions
  end

  def find_by_id(id)
    transactions.find { |transaction| transaction.id == id.to_i }
  end

  def find_all_by_invoice_id(invoice_id)
    transactions.find_all do |transaction|
      transaction.invoice_id == invoice_id.to_i
    end
  end

  def find_all_by_credit_card_number(number)
    transactions.find_all do |transaction|
      transaction.credit_card_number == number.to_i
    end
  end

  def find_all_by_result(result)
    transactions.find_all do |transaction|
      transaction.result.downcase == result.downcase
    end
  end
end
