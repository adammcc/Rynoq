var app = app || {};

app.StockView = Backbone.View.extend({
	el: $('#main'),

	events: {
		'change #stock_ticker': 'route'
	},

	initialize: function(){
		console.log("StockView initialized!")
	},

	render: function(){
		var template = Handlebars.compile($('#stock-view-template').html());
		this.$el.html(template(this.model.toJSON()));
	},

	route: function(){
		ticker_input = $('#stock_ticker option:selected').val();
    app.router.navigate('/stocks/' + ticker_input, {trigger: true })
	}
})