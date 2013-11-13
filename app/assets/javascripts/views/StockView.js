var app = app || {};

app.StockView = Backbone.View.extend({
	el: $('#main'),

	events: {
		'change #stock_ticker': 'route',
		'click #start_animation': 'start'
	},

	initialize: function(){
		console.log("StockView initialized!")
	},

	render: function(){
		var template = Handlebars.compile($('#stock-view-template').html());
		this.$el.html(template(this.model.toJSON()));
		// convert form to an auto complete form
		$('select').selectToAutocomplete();
		return this;
	},

	route: function(){
		ticker_input = $('#stock_ticker option:selected').val();
    app.router.navigate('/stocks/' + ticker_input, {trigger: true })
    makeCircle(this.model.attributes.quotes)
	},

	start: function(){
		makeCircle(this.model.attributes.quotes)
	}

})