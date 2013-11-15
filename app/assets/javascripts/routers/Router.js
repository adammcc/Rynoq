var app = app || {};
	
app.Router = Backbone.Router.extend({
	routes: {
		'': 'index',

		'stocks': 'index',

		'stocks/:id': 'show',

		'battle': 'battle'
	},

	index: function(){
		console.log("Home View routing")
		d3.selectAll('svg').remove();
		var home_view = new app.HomeView();
		home_view.render();	
	},

	show: function(id){
		console.log("Stock View routing")
		d3.selectAll('svg').remove();
		var stock = new app.Stock({id:id});
		stock.fetch({
			error: function(model, response) {
				console.log(response);
			},
			success: function(model, response) {
				console.log('Stock fetched successfully!');
				var stock_view = new app.StockView({model: model})
				stock_view.render();
			}
		});
	},

	battle: function() {
		console.log("Battle View routing")
		var battle_view = new app.BattleView()
		battle_view.render();
	}


});
