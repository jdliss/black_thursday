require_relative 'sales_engine'
require_relative 'customer'

class CustomerRepository
  attr_accessor :customers,
                :sales_engine

  def initialize(transaction_data, sales_engine)
    @sales_engine = sales_engine

    @customers ||= transaction_data.map do |customer|
      Customer.new(customer, self)
    end
  end

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end

  def all
    customers
  end

  def find_by_id(id)
    customers.find { |customer| customer.id == id.to_i }
  end

  def find_all_by_first_name(first)
    customers.find_all do |customer|
      customer.first_name.downcase.include?(first.downcase)
    end
  end

  def find_all_by_last_name(last)
    customers.find_all do
      |customer| customer.last_name.downcase.include?(last.downcase)
    end
  end
end
