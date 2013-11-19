class StocksController < ApplicationController
	before_filter :build_select_options

	def index
		respond_to do |format|
			format.html
			format.json {render :json => @select_options_list}
		end
	end

	def show
		@stock = Stock.find(params[:id])
		respond_to do |format|
      format.html
      format.json {render :json => @stock}
		end
	end

	def battle
	end

	private

	def build_select_options
		@select_options_list = Stock.pluck(:company_name, :ticker).collect do |stock| 
			["#{stock[0]} (#{stock[1]})", stock[1]]
		end
	end


end


