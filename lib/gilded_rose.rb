require './lib/item.rb'

class SmartItem
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  AGED_BRIE = "Aged Brie"
  BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"

  def initialize item
    @item = item
  end

  def increase_age
    @item.sell_in -= 1;
  end

  def expired?
    @item.sell_in < 0
  end

  def reduce_quality
    @item.quality -= 1 if @item.quality > MIN_QUALITY
  end

  def quality_reduces_over_time?
    @item.name != AGED_BRIE && @item.name != BACKSTAGE_PASSES
  end

  def increase_quality
    if @item.quality < MAX_QUALITY
      @item.quality += 1
    end
  end

  def add_quality_bonus_as_expiry_approaches
    if @item.name == BACKSTAGE_PASSES
      if @item.sell_in < 11
        increase_quality
      end
      if @item.sell_in < 6
        increase_quality
      end
    end
  end

  def change_quality_after_expiry
    if quality_reduces_over_time?
      reduce_quality
    elsif @item.name == BACKSTAGE_PASSES
      @item.quality = MIN_QUALITY
    else
      increase_quality
    end
  end

  def update_quality
    if quality_reduces_over_time?
      reduce_quality
    else
      increase_quality
      add_quality_bonus_as_expiry_approaches
    end
    change_quality_after_expiry if expired?
  end
end

class SulfurasSmartItem < SmartItem
  def increase_age
  end

  def reduce_quality
  end
end

SULFURAS = "Sulfuras, Hand of Ragnaros"

def smart_item_factory item
  return SulfurasSmartItem.new item if item.name == SULFURAS
  return SmartItem.new item
end

class GildedRose

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

  def update_quality
    @items.each do |i|
      item = smart_item_factory i
      item.increase_age
      item.update_quality
    end
  end

end
