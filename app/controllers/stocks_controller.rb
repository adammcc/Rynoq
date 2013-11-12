class StocksController < ApplicationController
	def index
		@select_options_list = Stock.pluck(:company_name, :ticker).collect do |stock| 
			["#{stock[0]} (#{stock[1]})", stock[1]]
		end

		respond_to do |format|
			format.html
			format.json {render :json => @select_options_list}
		end
	end

	def show
		@select_options_list = Stock.pluck(:company_name, :ticker).collect do |stock| 
			["#{stock[0]} (#{stock[1]})", stock[1]]
		end

		@stock = Stock.find(params[:id])

		respond_to do |format|
      format.html
      format.json {render :json => @stock}
		end
	end 
end


