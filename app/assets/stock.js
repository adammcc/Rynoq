var app = app || {};

app.Stock = Backbone.Model.extend({
	urlRoot: '/stocks',
	defaults: {
		ticker: 'Not specified.',
		company_name: 'Not specified.',
		description: 'Not specified',
		quotes: []
	},

	initialize: function(){
		console.log("A stock was retrieved.")
	}

});