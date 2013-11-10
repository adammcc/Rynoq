require 'spec_helper'

describe Quote do
	before(:all) do
		@stock = Stock.new
		@quote = @stock.quotes.new(id: 1, date:'2013-10-10')
	end

	it "belongs to a stock" do
		@quote._parent.class.should == Stock
	end

	it "is embedded in the stock document" do
		@quote.metadata.macro.should == :embeds_many
	end

	it "has a data attribute" do
		@quote.date.should == '2013-10-10'
	end

	it "has a custom id that can be assigned" do
		@quote.id.should == 1
	end

	xit "check for uniqueness of _id" do

	end

	xit "check for uniqueness of date" do

	end

end