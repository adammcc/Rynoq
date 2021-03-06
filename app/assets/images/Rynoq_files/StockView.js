var app = app || {};

app.StockView = Backbone.View.extend({
	el: $('#main'),

	events: {
		'change #stock_ticker': 'route',
		'click #start_animation': 'start',
		'click .home-link' : 'gohome',
		'click .battle-link' : 'render'
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
	},

	changeView : function(e) {
		e.preventDefault();
    app.router.navigate('/battle', { trigger: true });
  },

  changeView : function(e) {
		e.preventDefault();
    app.router.navigate('/index', { trigger: true });
  }
})
;
