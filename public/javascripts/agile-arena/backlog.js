var BacklogPageView = Backbone.View.extend({
	el : $('#backlog-page'),
	
	events : {
		"submit #new_backlog_item" : "newBacklogItem"
	},
	
	initialize : function(){
		this.form    = this.$("#new_backlog_item");
		this.list = this.$("#backlog-items-list");
		this.selectedCount = 0;
		
		var items = $.map(this.list.children("li"), function(item){
			var data = {
				id : $(item).data("id"),
				points : $(".points", item).text(),
				title : $("h3", item).html(),
				status : $(".status", item).text()
			};			
			return new BacklogItem(data);
		});
		
		BacklogItems = new BacklogItemCollection(items);		
		
    BacklogItems.bind('add',   this.addOne, this);
    BacklogItems.bind('reset', this.addAll, this);
    BacklogItems.bind('change', this.itemChanged, this);
	    
    this.list.children().remove();
    this.setupAll();    

		this.initSelectable();	
	},	
	
	  addOne: function(backlogItem) {
	    var view = new BacklogItemView({model: backlogItem});    
	    this.$("#backlog-items-list").append(view.render().el);
	  },
	  itemChanged: function(item){
	  	console.log("itemChanged");
	  	console.log(item);
	  },
	  addAll: function() {
	    BacklogItems.each(this.addOne);
	  },
	  setupAll: function(){
	  	BacklogItems.each(function(item){
	  		var view = new BacklogItemView({model: item});
	  		this.$("#backlog-items-list").append(view.render().el);
	  	});
	  },
	  
	  newBacklogItem : function(e){  	
	  	BacklogItems.createFromForm(this.form);
	  	
	  	return false;
	  },	  
	  initSelectable : function(){
	  	$("button.always-available").show();
	  	var that = this;
	  	
	  	$("input:checkbox", this.list).bind("change", function(e){

	  		that.handleSelection($(this));
	  		that.displayActionBySelection();
	  	});
	  
	  },
	  handleSelection : function(element){
	  	var selecting = element.attr("checked");
	  	if(selecting)
	  	{
	  		this.selectedCount++;
	  		element.parent("li").addClass("selected");
	  	}
	  	else
	  	{
	  		this.selectedCount--;
	  		element.parent("li").removeClass("selected");
	  	}
	  },
	  displayActionBySelection : function(){
	  	if(this.selectedCount <= 0)
	  	{
	  		$("button.item-selected").hide();
	  	}
	  	else
	  	{
	  		$("button.item-selected").show();	
	  	}
	  }

});

$(function(){
	if($("#new_backlog_item").length > 0){
		window.backlogApp = new BacklogPageView;
	}
	
});
