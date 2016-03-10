require 'csv'
require_relative 'item'

class ItemRepository

  attr_accessor :items,
                :sales_engine

  def initialize(items_data, sales_engine)
    @sales_engine = sales_engine

    @items ||= items_data.map do |item|
      Item.new(item, self)
    end
  end

  def inspect
    "#<#{self.class} #{@items.size} rows>"
  end

  def all
    items
  end

  def input_sanitation(input, class_name)
    input.is_a?(class_name)
  end

  def formatter(input)
    input.is_a?(String) ? input.to_i : input
  end

  def find_by_id(item_id)
    item_id = formatter(item_id)
    items.find { |item| item.id == item_id }
  end

  def find_by_name(item_name)
    return nil unless input_sanitation(item_name, String)
    items.find { |item| item.name.downcase == item_name.downcase }
  end

  def find_all_with_description(substring)
    return [] unless input_sanitation(substring, String)
    items.find_all do |item|
      item.description.downcase.include?(substring.downcase)
    end
  end

  def find_all_by_price(item_price)
    items.find_all { |item| item.unit_price.to_f == item_price }
  end

  def find_all_by_price_in_range(price_range)
    return [] unless input_sanitation(price_range, Range)
    items.find_all { |item| price_range.include?(item.unit_price) }
  end

  def find_all_by_merchant_id(merchant_id)
    merchant_id = formatter(merchant_id)
    items.find_all { |item| item.merchant_id == merchant_id }
  end
end
