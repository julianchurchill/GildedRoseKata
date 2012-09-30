require './lib/item.rb'

class GildedRose

  MIN_QUALITY = 0
  MAX_QUALITY = 50
  BRIE = "Aged Brie"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"

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

  def quality_reduces_over_time? item
      item.name != BRIE && item.name != BACKSTAGE_PASS
  end

  def can_age? item
      item.name != SULFURAS
  end

  def can_degrade? item
      item.name != SULFURAS
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

  def adjust_quality_of_expired_item item
    reduce_quality item if quality_reduces_over_time? item
    item.quality = 0 if item.name == BACKSTAGE_PASS
    increase_quality item if item.name == BRIE
  end

  def add_approaching_expiry_quality_bonus item
     if item.name == BACKSTAGE_PASS
      increase_quality item if item.sell_in < 11
      increase_quality item if item.sell_in < 6
    end
  end

  def update_quality
    @items.each do |item|
      age_item item
      if quality_reduces_over_time? item
        reduce_quality item
      else
        increase_quality item
        add_approaching_expiry_quality_bonus item
      end
      adjust_quality_of_expired_item item if expired? item
    end
  end

end
