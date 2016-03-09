module Averages
  def average_items_per_merchant
    (sales_engine.items.all.count/
        sales_engine.merchants.all.count.to_f).round(2)
  end

  def average_price_of_items
    item_prices = sales_engine.items.all.map do |item|
      item.unit_price
    end
    (item_prices.reduce(:+).to_f/item_prices.length).round(2)
  end

  def average_item_price_for_merchant(merchant_id)
    merchant = sales_engine.merchants.find_by_id(merchant_id)
    item_prices = merchant.items.map do |item|
      item.unit_price
    end
    (item_prices.reduce(:+)/item_prices.length).round(2)
  end

  def average_average_price_per_merchant
    item_prices = sales_engine.merchants.all.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
    (item_prices.reduce(:+)/item_prices.length).round(2)
  end

  def average_invoices_per_day
    (sales_engine.invoices.all.count/7.0).round(2)
  end

  def average_invoices_per_merchant
    (sales_engine.invoices.all.count/
        sales_engine.merchants.all.count.to_f).round(2)
  end


end
