var app = app || {};

app.HomeView = Backbone.View.extend({
	el: $('#main'),

	events: {
		'change #stock_ticker': 'route',
	},

	initialize: function(){
		console.log('HomeView initialized!');
		this.template = Handlebars.compile($('#home-view-template').html());
	},

	render: function(){
		this.$el.html(this.template());
		$('select').selectToAutocomplete();
		return this;
	},

	route: function(){
		if ($('#stock_ticker').val() != ''){
			ticker_input = $('#stock_ticker option:selected').val();
	    app.router.navigate('stocks/' + ticker_input, {trigger: true })
    }
	}
	
});