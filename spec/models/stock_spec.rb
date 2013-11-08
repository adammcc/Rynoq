require "spec_helper"

describe Stock do
	before(:all) do
		@stock = Stock.new
	end

	it "is a class" do
		Stock.class.should == Class
	end

	it "can be instantiated" do
		@stock.class.should == Stock
	end

	it "has an information attribute that can be a hash" do
		@stock.information = {}
		@stock.information.should == {}
	end

	it "has a price attribute that can be a hash" do
		@stock.price = {}
		@stock.price.should == {}
	end

end