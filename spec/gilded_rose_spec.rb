require './lib/gilded_rose.rb'
require "rspec"

describe GildedRose do

  VEST = "+5 Dexterity Vest"
  BRIE = "Aged Brie"
  ELIXIR = "Elixir of the Mongoose"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"
  MANA_CAKE = "Conjured Mana Cake"

  before(:all) do
    @all_items = [ VEST, BRIE, ELIXIR, SULFURAS, BACKSTAGE_PASS, MANA_CAKE ]
  end

  def find_item name, items
    items.each do |item|
      return item if item.name == name
    end
    nil
  end

  it "should be able to find all items" do
    @all_items.each do |name|
      find_item( name, subject.items ).should_not eq nil
    end
  end

  it "should decrease sell by date of all items except Sulfuras" do
    @all_items.each do |name|
      if name != SULFURAS
        original_sell_by_date = find_item( name, subject.items ).sell_in
        subject.update_quality
        find_item( name, subject.items ).sell_in.should eq original_sell_by_date-1
      end
    end
  end

  it "should degrade quality of ordinary items" do
    original_vest_quality = find_item( VEST, subject.items ).quality
    original_elixir_quality = find_item( ELIXIR, subject.items ).quality
    subject.update_quality
    find_item( VEST, subject.items ).quality.should eq original_vest_quality-1
    find_item( ELIXIR, subject.items ).quality.should eq original_elixir_quality-1
  end

  it "should not degrade quality of Sulfuras" do
    original_quality = find_item( SULFURAS, subject.items ).quality
    (0...10).each do
      subject.update_quality
      find_item( SULFURAS, subject.items ).quality.should eq original_quality
    end
  end

  it "should increase quality of Aged Brie" do
    original_quality = find_item( BRIE, subject.items ).quality
    subject.update_quality
    find_item( BRIE, subject.items ).quality.should eq original_quality+1
  end

  it "should increase quality of Backstage passes" do
    original_quality = find_item( BACKSTAGE_PASS, subject.items ).quality
    subject.update_quality
    find_item( BACKSTAGE_PASS, subject.items ).quality.should eq original_quality+1
  end

  it "should degrade the quality of ordinary items twice as fast once sell by date has passed"

  it "should increase quality of Backstage passes by 2 when there are 10 days or less on sell by date"
  it "should increase quality of Backstage passes by 3 when there are 5 days or less on sell by date"
  it "should make quality of Backstage passes 0 when sell by date passed"

end
