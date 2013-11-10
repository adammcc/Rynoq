class Stock
	include Mongoid::Document
	field :ticker, type: String
	field :company_name, type: String
	field :description, type: String
	field :quotes, type: Array
	field :_id, type: String, default: ->{ ticker }
	index ({company_name: 1})
	validates :ticker, 
		uniqueness: {message: "This ticker already exists."}, 
		presence: {message: "Ticker can't be blank."}
	validates :company_name, 
		uniqueness: {message: "This company name already exists."}, 
		presence: {message: "Ticker can't be blank."}
end