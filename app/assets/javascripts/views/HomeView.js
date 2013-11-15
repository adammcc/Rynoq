var app = app || {};

app.HomeView = Backbone.View.extend({
	el: $('#main'),

	events: {
		'change #stock_ticker': 'show',
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

	show: function(e){
		e.preventDefault();
		if ($('#stock_ticker') != ''){
			ticker_input = $('#stock_ticker option:selected').val();
	    app.router.navigate('stocks/' + ticker_input, {trigger: true })
    }
	}
	
});