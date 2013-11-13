var app = app || {};

app.BattleView = Backbone.View.extend({
	el: $('#main'),

	events: {
		'change #stock_two_ticker': 'route'
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
    // app.router.navigate('/stocks/' + ticker_input, {trigger: true })
    // console.log(ticker_input)
    var stock = new app.Stock({id:ticker_input});
    // console.log(stock)
    stock.fetch({
			success: function(model, response) {
				// console.log(model)
				console.log(response.quotes)
				// console.log('Stock fetched successfully!');
				makeCircle(response.quotes)
			}
		});
    
	},

	
});