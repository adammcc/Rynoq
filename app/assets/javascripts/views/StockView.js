var app = app || {};

app.StockView = Backbone.View.extend({
	el: $('#main'),

	events: {
		'change #stock_ticker': 'show',
		'click #start_animation': 'start',
		'click #home_link': 'home',
		'click #battle_link': 'battle'
	},

	initialize: function(){
		console.log("StockView initialized!")
		makeCircle(this.model.attributes.quotes);
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
    app.router.navigate('/stocks/' + ticker_input, {trigger: true });
	},

	start: function(){
		makeCircle(this.model.attributes.quotes);
	},

	home: function(e){
		e.preventDefault();
		app.router.navigate('', {trigger: true});
	},

	battle: function(e){
		e.preventDefault();
		app.router.navigate('battle', {trigger:true})
	}
})