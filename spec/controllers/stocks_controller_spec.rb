require 'spec_helper'

describe StocksController do
	describe "GET #index" do
		it "responds successfully with HTTP 200 status code" do
			get :index
			expect(response).to be_successful
			expect(response.status).to eq(200) 
		end
	end
end
