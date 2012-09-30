require './lib/gilded_rose.rb'
require "rspec"

describe GildedRose do

  VEST = "+5 Dexterity Vest"
  BRIE = "Aged Brie"
  ELIXIR = "Elixir of the Mongoose"
  SULFURAS = "Sulfuras, Hand of Ragnaros"
  BACKSTAGE_PASS = "Backstage passes to a TAFKAL80ETC concert"
  CONJURED_MANA_CAKE = "Conjured Mana Cake"

  before(:all) do
    @all_items = [ VEST, BRIE, ELIXIR, SULFURAS, BACKSTAGE_PASS, CONJURED_MANA_CAKE ]
  end

  def find_item name
    subject.items.each do |item|
      return item if item.name == name
    end
    nil
  end

  def backstage_pass
    find_item( BACKSTAGE_PASS )
  end

  def brie
    find_item( BRIE )
  end

  def sulfuras
    find_item( SULFURAS )
  end

  def vest
    find_item( VEST )
  end

  def elixir
    find_item( ELIXIR )
  end

  def conjured_item
    find_item( CONJURED_MANA_CAKE )
  end

  it "should be able to find all items" do
    @all_items.each do |name|
      find_item( name ).should_not eq nil
    end
  end

  it "should decrease sell by date of all items except Sulfuras" do
    @all_items.each do |name|
      if name != SULFURAS
        original_sell_by_date = find_item( name ).sell_in
        subject.update_quality
        find_item( name ).sell_in.should eq original_sell_by_date-1
      end
    end
  end

  it "should degrade quality of ordinary items" do
    original_vest_quality = vest.quality
    original_elixir_quality = elixir.quality
    subject.update_quality
    vest.quality.should eq original_vest_quality-1
    elixir.quality.should eq original_elixir_quality-1
  end

  it "should degrade the quality of ordinary items twice as fast once sell by date has passed" do
    vest.sell_in.times { subject.update_quality }
    original_vest_quality = vest.quality
    subject.update_quality
    vest.quality.should eq original_vest_quality-2
  end

  it "should never decrease the quality of an ordinary item beyond 0" do
    51.times { subject.update_quality }
    vest.quality.should eq 0
    elixir.quality.should eq 0
  end

  it "should not degrade quality of Sulfuras" do
    original_quality = sulfuras.quality
    (0...10).each do
      subject.update_quality
      sulfuras.quality.should eq original_quality
    end
  end

  it "should increase quality of Aged Brie" do
    original_quality = brie.quality
    subject.update_quality
    brie.quality.should eq original_quality+1
  end

  it "should never increase the quality of Aged Brie beyond 50" do
    51.times { subject.update_quality }
    brie.quality.should eq 50
  end

  it "should increase quality of Backstage passes" do
    original_quality = backstage_pass.quality
    subject.update_quality
    backstage_pass.quality.should eq original_quality+1
  end

  it "should increase quality of Backstage passes by 2 when there are 10 days or less on sell by date" do
    while backstage_pass.sell_in > 10 do
      subject.update_quality
    end
    original_quality = backstage_pass.quality
    subject.update_quality
    backstage_pass.quality.should eq original_quality+2
  end

  it "should increase quality of Backstage passes by 3 when there are 5 days or less on sell by date" do
    while backstage_pass.sell_in > 5 do
      subject.update_quality
    end
    original_quality = backstage_pass.quality
    subject.update_quality
    backstage_pass.quality.should eq original_quality+3
  end

  it "should make quality of Backstage passes 0 when sell by date passed" do
    while backstage_pass.sell_in > 0 do
      subject.update_quality
    end
    original_quality = backstage_pass.quality
    subject.update_quality
    backstage_pass.quality.should eq 0
  end

  it "should degrade conjured items twice as fast as normal items" do
    original_quality = conjured_item.quality
    subject.update_quality
    conjured_item.quality.should eq original_quality-2
  end

end
