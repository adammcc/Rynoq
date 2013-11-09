require 'spec_helper'

describe StocksController do
	before(:all) do
		Stock.create(ticker:'goog', company_name: 'Google', description: 'Awesome company.') 
	end

	describe "GET #index" do

		it "responds successfully with HTTP 200 status code" do
			get :index
			expect(response).to be_successful
			expect(response.status).to eq(200)
		end

		it "instantiates @stocks array" do
			@stocks.class == Array
		end

	end
end
