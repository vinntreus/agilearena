var common = (function(){
	var that = this;
	var log = function(item){
		if(window.console && window.console.log){
			window.console.log(item);
		}
	};		
	var dir = function(item){
		if(window.console && window.console.dir){
			window.console.dir(item);
		}
	};
	
	return {
		log : function(item){
			that.log(item);
		}		
	};
})()
