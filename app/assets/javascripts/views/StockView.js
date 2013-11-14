var app = app || {};

app.StockView = Backbone.View.extend({
	el: $('#main'),

	events: {
		'change #stock_ticker': 'show',
		'click #start_animation': 'start',
		'click #home-link' : 'home',
		'click #battle-link' : 'battle'
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

	show: function(){
		ticker_input = $('#stock_ticker option:selected').val();
    app.router.navigate('stocks/' + ticker_input, {trigger: true })
    makeCircle(this.model.attributes.quotes)
	},

	start: function(){
		makeCircle(this.model.attributes.quotes)
	}
})