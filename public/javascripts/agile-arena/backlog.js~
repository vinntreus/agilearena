var BacklogPageView = Backbone.View.extend({
	el : $('#backlog-page'),
	
	events : {
		"submit #new_backlog_item" : "newBacklogItem"
	},
	
	initialize : function(){
		this.form    = this.$("#new_backlog_item");
		this.list = this.$("#backlog-items-list");
		
		var items = $.map(this.list.children("li"), function(item){
			var data = {
				id : $(item).data("id"),
				title : $("h3", item).text()
			};
			var sprint = $(".sprint", item);
			if(sprint.length > 0)
				data.sprint = sprint.text();
			return new BacklogItem(data);
		});
		
		BacklogItems = new BacklogItemCollection(items);		
		
    BacklogItems.bind('add',   this.addOne, this);
    BacklogItems.bind('reset', this.addAll, this);
    BacklogItems.bind('change', this.itemChanged, this);
    
    this.list.children().remove();
    this.setupAll();
    
 		this.initDraggable();
		this.initSelectable();	
	},	
	
	addOne: function(backlogItem) {
    var view = new BacklogItemView({model: backlogItem});    
    this.$("#backlog-items-list").append(view.render().el);
    window.backlogScroll.tinyscrollbar_update('bottom');
    this.updateDraggable();
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
  updateDraggable: function(){
  	$("li", this.list).draggable("destroy");
  	this.initDraggable();
  },
  initDraggable: function(){
	  $("li", this.list).draggable({
			start: function(event, ui){				 
				 $(event.target).addClass("ui-selected");
			},
			revert: 'invalid',
			cursor: 'move',
			helper : function(event){
				var el = $(this).clone();
				
				el.css({opacity : 0.7, width: $(this).width() * 0.9 + "px"})
					.addClass("backlog-list-item");
					
				$("body").append(el);
				return el[0];
			},
			stop : function(event, ui){
 			 $(this).removeClass("ui-selected");
			}
		});
  },
  initSelectable : function(){
  	/*this.list.selectable({
			tolerance: 'fit',
			selected: function(event, ui){
				
				$(ui.selected).draggable({
					stack : '#backlog-page',
					zIndex : 4000,
					drag : function(){
						
					}
				});
			},
			unselected : function(event, ui){
				//$(ui.unselected).unbind("drag");
			}
		});*/
  }
	
});

$(function(){
	if($("#new_backlog_item").length > 0){
		window.backlogApp = new BacklogPageView;
	}
	window.backlogScroll = $("#backlog-large-column-scroll").tinyscrollbar();
	
});
