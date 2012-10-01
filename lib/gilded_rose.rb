require './lib/item.rb'

class GildedRose

  MAX_QUALITY = 50
  MIN_QUALITY = 0

  attr_reader :items

  @items = []

  def initialize
    @items = []
    @items << Item.new("+5 Dexterity Vest", 10, 20)
    @items << Item.new("Aged Brie", 2, 0)
    @items << Item.new("Elixir of the Mongoose", 5, 7)
    @items << Item.new("Sulfuras, Hand of Ragnaros", 0, 80)
    @items << Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20)
    @items << Item.new("Conjured Mana Cake", 3, 6)
  end

  def reduce_quality item
    if item.quality > MIN_QUALITY
      if item.name != "Sulfuras, Hand of Ragnaros"
        item.quality -= 1
      end
    end
  end

  def increase_quality item
    if item.quality < MAX_QUALITY
      item.quality += 1
    end
  end

  def increase_age item
    if item.name != "Sulfuras, Hand of Ragnaros"
      item.sell_in -= 1;
    end
  end

  def quality_reduces_over_time item
    item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert"
  end

  def expired? item
    item.sell_in < 0
  end

  def update_quality
    @items.each do |item|
      increase_age item
      if quality_reduces_over_time item
        reduce_quality item
      else
        increase_quality item
        if item.name == "Backstage passes to a TAFKAL80ETC concert"
          if item.sell_in < 11
            increase_quality item
          end
          if item.sell_in < 6
            increase_quality item
          end
        end
      end
      if expired? item
        if item.name != "Aged Brie"
          if item.name != "Backstage passes to a TAFKAL80ETC concert"
            reduce_quality item
          else
            item.quality = MIN_QUALITY
          end
        else
          increase_quality item
        end
      end
    end
  end

end
