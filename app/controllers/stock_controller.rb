class StockController < ApplicationController

	def battle
		@select_options_list = Stock.pluck(:company_name, :ticker).collect do |stock| 
			["#{stock[0]} (#{stock[1]})", stock[1]]
		end
	end

end
