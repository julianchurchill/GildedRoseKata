require './lib/item.rb'

class SmartItem
  MIN_QUALITY = 0

  def initialize item
    @item = item
    @degradation_rate = 1
    @sell_in_rate = 1
  end

  def increase_age
    @item.sell_in -= @sell_in_rate;
  end

  def update_quality
    reduce_quality
    reduce_quality if expired?
  end

  def reduce_quality
    @item.quality -= @degradation_rate if @item.quality > MIN_QUALITY
  end

  def expired?
    @item.sell_in < 0
  end
end

class QualityIncreasingSmartItem < SmartItem
  MAX_QUALITY = 50

  def increase_quality
    @item.quality += 1 if @item.quality < MAX_QUALITY
  end
end

class AgedBrieSmartItem < QualityIncreasingSmartItem
  def update_quality
    increase_quality
    increase_quality if expired?
  end
end

class BackstagePassesSmartItem < QualityIncreasingSmartItem
  def update_quality
    if expired?
      @item.quality = MIN_QUALITY
    else
      increase_quality
      increase_quality if @item.sell_in < 11
      increase_quality if @item.sell_in < 6
    end
  end
end

class SulfurasSmartItem < SmartItem
  def increase_age
  end

  def reduce_quality
  end
end

class ConjuredSmartItem < SmartItem
  def initialize item
    super item
    @degradation_rate = 2
  end
end

AGED_BRIE = "Aged Brie"
BACKSTAGE_PASSES = "Backstage passes to a TAFKAL80ETC concert"
SULFURAS = "Sulfuras, Hand of Ragnaros"

def smart_item_factory item
  return ConjuredSmartItem.new item if item.name =~ /^Conjured .*/
  return AgedBrieSmartItem.new item if item.name == AGED_BRIE
  return BackstagePassesSmartItem.new item if item.name == BACKSTAGE_PASSES
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
