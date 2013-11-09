require 'spec_helper'

describe Quote do
	before(:all) do
		@stock = Stock.new
		@quote = @stock.quotes.new(date:'2013-10-10')
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

	it "has a custom id that equals to its date" do
		@quote.id.should == '2013-10-10'
	end

end