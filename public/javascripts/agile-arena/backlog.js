var BacklogPageView = Backbone.View.extend({
	el : $('#backlogs_controller'),
	
	events : {
		"click #remove-item" : "removeBacklogItem",
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
		BacklogItems.bind('destroy', this.itemDeleted, this);
	    
    this.list.children().remove();
    this.setupAll();    

  	$("button.always-available").show();
	},	
	
  addOne: function(backlogItem) {
    var view = new BacklogItemView({model: backlogItem});    
    this.$("#backlog-items-list").append(view.render().el);
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
	itemDeleted : function(e){
  	this.displayActionBySelection();	
	},
	itemChanged : function(e){
  	this.displayActionBySelection();	
	},	  
  newBacklogItem : function(e){  	
  	BacklogItems.createFromForm(this.form);	  	
  	return false;
  },	 
	removeBacklogItem : function(e){
		_.each(BacklogItems.selected(), function(item){ item.destroy(); });
		return false;
	},
  displayActionBySelection : function(){
		var buttons = "button.item-selected";
		$("li.selected", this.list).length > 0 ? $(buttons).show() : $(buttons).hide();
  }
});

$(function(){
	if($("#new_backlog_item").length > 0){
		window.backlogApp = new BacklogPageView;
	}	
});
