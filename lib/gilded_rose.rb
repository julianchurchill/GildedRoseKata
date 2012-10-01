require './lib/item.rb'

class SmartItem
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def initialize item
    @item = item
  end

  def increase_age
    if @item.name != "Sulfuras, Hand of Ragnaros"
      @item.sell_in -= 1;
    end
  end

  def expired?
    @item.sell_in < 0
  end

  def reduce_quality
    if @item.quality > MIN_QUALITY
      if @item.name != "Sulfuras, Hand of Ragnaros"
        @item.quality -= 1
      end
    end
  end

  def quality_reduces_over_time
    @item.name != "Aged Brie" && @item.name != "Backstage passes to a TAFKAL80ETC concert"
  end

  def increase_quality
    if @item.quality < MAX_QUALITY
      @item.quality += 1
    end
  end

  def add_quality_bonus_as_expiry_approaches
    if @item.name == "Backstage passes to a TAFKAL80ETC concert"
      if @item.sell_in < 11
        increase_quality
      end
      if @item.sell_in < 6
        increase_quality
      end
    end
  end

  def change_quality_after_expiry
    if quality_reduces_over_time
      reduce_quality
    elsif @item.name == "Backstage passes to a TAFKAL80ETC concert"
      @item.quality = MIN_QUALITY
    else
      increase_quality
    end
  end

  def update_quality
    if quality_reduces_over_time
      reduce_quality
    else
      increase_quality
      add_quality_bonus_as_expiry_approaches
    end
    change_quality_after_expiry if expired?
  end
end

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

  def update_quality
    @items.each do |i|
      item = SmartItem.new i
      item.increase_age
      item.update_quality
    end
  end

end
