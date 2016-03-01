require 'csv'
require 'pry'
require_relative 'item'

class ItemRepository

  attr_accessor :items

  def initialize(file_path)
    csv_table = CSV.readlines(file_path, headers: true)

    @items = csv_table.map do |item|
      Item.new(item)
    end
    @items
  end

  def all
    items
  end

  def find_by_id(item_id)
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

end
