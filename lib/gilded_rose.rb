require './lib/item.rb'

class GildedRose

  MIN_QUALITY = 0
  MAX_QUALITY = 50

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

  def is_normal? item
      item.name != "Aged Brie" && item.name != "Backstage passes to a TAFKAL80ETC concert"
  end

  def can_age? item
      item.name != "Sulfuras, Hand of Ragnaros"
  end

  def can_degrade? item
      item.name != "Sulfuras, Hand of Ragnaros"
  end

  def reduce_quality item
    if item.quality > MIN_QUALITY
      if can_degrade? item
        item.quality -= 1
      end
    end
  end

  def increase_quality item
    if item.quality < MAX_QUALITY
      item.quality += 1
    end
  end

  def expired? item
    item.sell_in < 0
  end

  def age_item item
    item.sell_in -= 1 if can_age? item
  end

  def update_quality
    @items.each do |item|
      age_item item
      if is_normal? item
        reduce_quality item
      else
        increase_quality item
        if item.name == "Backstage passes to a TAFKAL80ETC concert"
          increase_quality item if item.sell_in < 11
          increase_quality item if item.sell_in < 6
        end
      end
      if expired? item
        reduce_quality item if is_normal? item
        item.quality = 0 if item.name == "Backstage passes to a TAFKAL80ETC concert"
        increase_quality item if item.name == "Aged Brie"
      end
    end
  end

end
