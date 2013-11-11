class StocksController < ApplicationController
	def index
		@stocks = Stock.all.to_a
	end

	def show
		id = params[:id]
		@stock = Stock.find(id)

		respond_to do |format|
      format.html
      format.json {render :json => @stock}
		end
	end 

end
