class StocksController < ApplicationController
	def index
		@people = Person.all
	end
end
