class StocksController < ApplicationController
	def index
		
	end

	def show
		@stock = Stock.find(params[:id])
	end 

end
