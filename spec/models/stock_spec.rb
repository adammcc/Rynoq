require 'spec_helper'

describe Stock do
	before(:all) do
		@stock = Stock.new(ticker:'goog')
	end

	it "is a class" do
		Stock.class.should == Class
	end

	it "can be instantiated" do
		@stock.class.should == Stock
	end

	it "has a ticker attribute" do
		@stock.ticker.should == 'goog'
	end

	it "can have many quotes" do
		@stock.quotes = []
	end

	it "has a custom id that equals to its ticker" do
		@stock.id.should == 'goog'
	end

end