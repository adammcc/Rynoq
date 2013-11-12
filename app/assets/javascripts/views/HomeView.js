var app = app || {};

app.HomeView = Backbone.View.extend({
	el: $('#main'),

	events: {},

	initialize: function(){
		console.log('HomeView initialized!');
		this.template = Handlebars.compile($('#home-view-template').html());
	},

	render: function(){
		this.$el.html(this.template());
		return this;
	}
});