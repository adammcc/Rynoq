require 'spec_helper'

describe Stock do
	before(:all) do
		@stock = Stock.create!(ticker:'goog', company_name:'Google')
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

	xit "check for uniqueness of ticker" do
		expect {stock = Stock.create!(ticker:'goog', company_name:'Yahoo')}.to raise_error
		puts "*********"
		p stock.errors
		stock.errors.messages[:ticker].first.should == "This ticker already exists."
	end

	xit "check for uniqueness of company name" do
		stock = Stock.create!(ticker:'yhoo', company_name:'Google')
		stock.errors.messages[:company_name].first.should == "This company name already exists."
	end
end