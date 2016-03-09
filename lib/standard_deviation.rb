require 'bigdecimal'
require_relative 'averages'
require_relative 'collections'

module StandardDeviation
  include Averages
  include Collections

  def standard_deviation(collection, average, method)
    difference = collection.map do |element|
      send_method_to(element, average, method)
    end
    finish_standard_deviation(difference)
  end

  def send_method_to(element, average, method)
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
    # difference = sales_engine.items.all.map do |item|
    #   (item.unit_price - average_price_of_items) ** 2
    # end
    #
    # finish_standard_deviation(difference)
  end

  def average_invoices_per_merchant_standard_deviation
    standard_deviation(all_merchants, average_invoices_per_merchant,
        "invoices.length")

    # average_invoices = average_invoices_per_merchant
    #
    # difference = all_merchants.map do |merchant|
    #   (merchant.invoices.length - average_invoices) ** 2
    # end
    #
    # finish_standard_deviation(difference)
  end

  def average_invoices_per_day_standard_deviation
    standard_deviation(actual_invoices_per_day, average_invoices_per_day, "")
    # average = average_invoices_per_day
    #
    # difference = actual_invoices_per_day.map do |_day, sales|
    #   (sales - average) ** 2
    # end
    #
    # finish_standard_deviation(difference)
  end


end
