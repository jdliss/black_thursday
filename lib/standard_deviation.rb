require 'bigdecimal'
require_relative 'averages'

module StandardDeviation
  include Averages

  def standard_deviation(collection, average, method)
    difference = collection.map do |element|
      send_method_to_element(element, average, method)
    end
    finish_standard_deviation(difference)
  end

  def send_method_to_element(element, average, method)
    methods = method.split(".")

    if methods.length == 1
      (element.send(method) - average) ** 2
    elsif methods.length == 2
      ((element.send(methods[0]).send(methods[1])) - average) ** 2
    else
      (element[1] - average) ** 2
    end
  end

  def finish_standard_deviation(difference)
    sum = difference.reduce(:+)
    Math.sqrt(sum / (difference.length - 1)).round(2)
  end

  def average_items_per_merchant_standard_deviation
    standard_deviation(all_merchants,average_items_per_merchant,"items.length")
  end

  def average_item_price_standard_deviation
    standard_deviation(all_items, average_price_of_items, "unit_price")
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(all_merchants, average_invoices_per_merchant,
        "invoices.length")
  end

  def average_invoices_per_day_standard_deviation
    standard_deviation(actual_invoices_per_day, average_invoices_per_day, "")
  end
end
