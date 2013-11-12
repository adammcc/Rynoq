class StocksController < ApplicationController
	def index
		@select_options_list = Stock.all.pluck(:company_name,:ticker)

		respond_to do |format|
			format.html
			format.json {render :json => @select_options_list}
		end
	end

	def show
		@select_options_list = Stock.all.pluck(:company_name,:ticker)

		@stock = Stock.find(params[:id])

		respond_to do |format|
      format.html
      format.json {render :json => @stock}
		end
	end 
end


