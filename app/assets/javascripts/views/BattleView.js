var app = app || {};

app.BattleView = Backbone.View.extend({
	el: $('#main'),

	events: {
		'click #start_battle': 'route'
	},

	initialize: function(){
		console.log('BattleView initialized!');
		this.template = Handlebars.compile($('#battle-view-template').html());
	},

	render: function(){
		this.$el.html(this.template());
		$('select').selectToAutocomplete();
		return this;
	},

	route: function(){
		ticker_input = $('#stock_two_ticker option:selected').val();
		ticker_input_one = $('#stock_one_ticker option:selected').val();
    console.log(ticker_input)

    var stock = new app.Stock({id:ticker_input});
    stock.fetch({
			success: function(model, response) {
				// console.log(model)
				console.log(response.quotes)
				// console.log('Stock fetched successfully!');
				makeCircle(response.quotes)
			}
		});
    
    var stock_one = new app.Stock({id:ticker_input_one});
    stock_one.fetch({
			success: function(model, response) {
				// console.log(model)
				console.log(response.quotes)
				// console.log('Stock fetched successfully!');
				makeCircleTwo(response.quotes)
		}

		});
	}
});