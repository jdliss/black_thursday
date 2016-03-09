module Collections
  def all_merchants
    sales_engine.merchants.all
  end

  def all_items
    sales_engine.items.all
  end

  def merchant_items_prices(merchant)
    merchant.items.map do |item|
      item.unit_price
    end
  end

  def all_merchants_item_prices
    sales_engine.merchants.all.map do |merchant|
      average_item_price_for_merchant(merchant.id)
    end
  end

  def invoices
    sales_engine.invoices.all
  end

  def all_item_prices
    all_items.map do |item|
      item.unit_price
    end
  end

  def invoices_on_date(date)
    date = date.strftime('%D') if date.is_a?(Time)
    sales_engine.invoices.find_all_by_date(date)
  end

  def actual_invoices_per_day
   days = Hash.new(0)

   sales_engine.invoices.all.each do |invoice|
     day = invoice.created_at.strftime("%A")
     days[day] += 1
   end
   days
 end
end
