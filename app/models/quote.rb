class Quote
	include Mongoid::Document
	field :date
  field :open
  field :high
  field :low
  field :close
  field :volume
  field :adjusted
  field :_id, type: String, default: ->{ date }
  embedded_in :stock, :inverse_of => :quotes
end