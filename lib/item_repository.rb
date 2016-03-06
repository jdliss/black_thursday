require 'csv'
require 'pry'
require_relative 'item'

class ItemRepository

  attr_accessor :items,
                :sales_engine

  def initialize(items_data, sales_engine)
    @sales_engine = sales_engine

    @items_data.map do |item|
      Item.new(item, self)
    end
  end

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end

  def all
    items
  end

  def find_by_id(item_id)
    item_id = item_id.to_i if item_id.class == String
    items.find { |item| item.id == item_id }
  end

  def find_by_name(item_name)
    items.find { |item| item.name.downcase == item_name.downcase }
  end

  def find_all_with_description(substring)
    items.find_all { |item| item.description.downcase.include?(substring.downcase)}
  end

  def find_all_by_price(item_price)
    items.find_all { |item| item.unit_price.to_f == item_price }
  end

  def find_all_by_price_in_range(price_range)
    items.find_all { |item| price_range.include?(item.unit_price) }
  end

  def find_all_by_merchant_id(merchant_id)
    merchant_id = merchant_id.to_i if merchant_id.class == String
    items.find_all { |item| item.merchant_id == merchant_id }
  end
end
