class Stock
	include Mongoid::Document
	field :ticker
	field :company_name
	field :description
	field :_id, type: String, default: ->{ ticker }
	embeds_many :quotes
end