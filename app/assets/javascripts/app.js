var app = app || {};

$(function(){
	app.router = new app.Router();
	Backbone.history.start({pushState: Modernizr.history});

	$('#home_link').on('click', function(e){
		e.preventDefault();
		app.router.navigate('', {trigger: true});
	});

	$('#battle_link').on('click', function(e){
		e.preventDefault();
		app.router.navigate('stock/battle', {trigger:true})
	})
});