class StocksController < ApplicationController
	def index
		@stocks = Stock.all.to_a
	end

	def show
		@stocks = Stock.all.to_a.collect do |stock|
			"#{stock.company_name} (#{stock.ticker})"
		end

		@stock = Stock.find(params[:id])

		respond_to do |format|
      format.html
      format.json {render :json => @stock}
		end
	end 

end


