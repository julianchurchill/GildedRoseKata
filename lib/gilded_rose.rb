require './lib/item.rb'

class ShopItem
  MIN_QUALITY = 0
  MAX_QUALITY = 50
  QUALITY_DELTA = 1

  AGE_DELTA = 1
  EXPIRY_DAY = 0
  SELL_IN_DOUBLE_QUALITY_DELTA_BOUNDARY = 12
  SELL_IN_TRIPLE_QUALITY_DELTA_BOUNDARY = 5

  BRIE = "Aged Brie"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"

  def initialize item
    @item = item
  end

  def increase_age
    @item.sell_in -= AGE_DELTA if can_age?
  end

  def can_age?
      @item.name != SULFURAS
  end

  def quality_reduces_over_time?
      @item.name != BRIE && @item.name != BACKSTAGE_PASS
  end

  def can_degrade?
      @item.name != SULFURAS
  end

  def reduce_quality
    if @item.quality > MIN_QUALITY
      if can_degrade?
        @item.quality -= QUALITY_DELTA
        @item.quality -= QUALITY_DELTA if @item.name =~ /^Conjured .*/
      end
    end
  end

  def increase_quality
    @item.quality += QUALITY_DELTA if @item.quality < MAX_QUALITY
  end

  def add_approaching_expiry_quality_bonus
     if @item.name == BACKSTAGE_PASS
      increase_quality if @item.sell_in <= SELL_IN_DOUBLE_QUALITY_DELTA_BOUNDARY
      increase_quality if @item.sell_in <= SELL_IN_TRIPLE_QUALITY_DELTA_BOUNDARY
    end
  end

  def adjust_quality_of_expired_item
    reduce_quality if quality_reduces_over_time?
    @item.quality = MIN_QUALITY if @item.name == BACKSTAGE_PASS
    increase_quality if @item.name == BRIE
  end

  def expired?
    @item.sell_in < EXPIRY_DAY
  end

  def update_quality
    if quality_reduces_over_time?
      reduce_quality
    else
      increase_quality
      add_approaching_expiry_quality_bonus
    end
    adjust_quality_of_expired_item if expired?
  end
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
      item = ShopItem.new i
      item.increase_age
      item.update_quality
    end
  end

end
