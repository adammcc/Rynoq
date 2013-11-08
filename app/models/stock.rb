class Stock
	include Mongoid::Document
	field :information, type: Hash
	field :price, type: Hash
end