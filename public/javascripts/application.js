// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var AGILE = (function(){
	
	var log = function(item){
		if(window.console && window.console.log){
			window.console.log(item);
		}
	}
	
	var setupToggle = function()	{
		$(".toggle-block").click(function(){		
				var selectorToToggle = $(this).attr("data-toogle");		
				$(selectorToToggle).toggle();					
				return false;
		});
	}
	
	init = function()	{
		//init in jquery context
		$(function(){
		
			setupToggle();			
			
		});
	}
	
	
	return this.init();	
	
})();
