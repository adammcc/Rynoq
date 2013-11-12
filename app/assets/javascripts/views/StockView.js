var app = app || {};

app.StockView = Backbone.View.extend({
	el: $('#main'),

	events: {},

	initialize: function(){
		console.log("StockView initialized!")
	},

	render: function(){
		var template = Handlebars.compile($('#stock-view-template').html());
		this.$el.html(template(this.model.toJSON()));
	}
})