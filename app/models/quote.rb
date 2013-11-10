class Quote
	include Mongoid::Document
	field :_id
  field :date
  field :open
  field :high
  field :low
  field :close
  field :volume
  field :adjusted
  embedded_in :stock, :inverse_of => :quotes
  validates :_id,
    uniqueness: {message: "This ID already exists."},
    presence: {message: "ID can't be balnk."}
  validates :date,
    uniqueness: {message: "This date already exists."},
    presence: {message: "Date can't be blank."}
end