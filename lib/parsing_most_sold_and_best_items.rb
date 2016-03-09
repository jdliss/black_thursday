module ParsingMostSoldAndBestItems
  def sort_most_sold(hash)
    zipped = hash.sort_by do |pair|
      pair[1]
    end

    top = zipped[-1]
    items = zipped.find_all do |item|
      item[1] == top[1]
    end

    find_most_sold_items(items)
  end

  def find_most_sold_items(item_ids)
    item_ids.map do |item|
      sales_engine.items.find_by_id(item[0])
    end.compact
  end

  def find_best_item(best_items)
    best_item = best_items.max_by do |pair|
      pair[1]
    end

    sales_engine.items.find_by_id(best_item[0])
  end
end
