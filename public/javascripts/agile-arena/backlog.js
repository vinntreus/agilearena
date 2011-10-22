var BacklogPageView = Backbone.View.extend({
	el : $('#backlog-page'),
	
	events : {
		"submit #new_backlog_item" : "newBacklogItem"
	},
	
	initialize : function(){
		this.form    = this.$("#new_backlog_item");
		this.list = this.$("#backlog-items-list");
		
	  $("li", this.list).draggable({
			start: function(event, ui){				 
				 $(event.target).addClass("ui-selected");
			},
			revert: 'invalid',
			cursor: 'move',
			helper : function(event){
				var el = $(this).clone();
				el.css({opacity : 0.7, width: $(this).width() * 0.9 + "px"}).addClass("backlog-list-item");							
				$("body").append(el);
				return el[0];
			},
			stop : function(event, ui){
 			 $(this).removeClass("ui-selected");
			}
		});
		
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

    BacklogItems.bind('add',   this.addOne, this);
    BacklogItems.bind('reset', this.addAll, this);
	},	
	
	addOne: function(backlogItem) {
    var view = new BacklogItemView({model: backlogItem});    
    this.$("#backlog-items-list").append(view.render().el);
    window.backlogScroll.tinyscrollbar_update('bottom');
  },
  addAll: function() {
    BacklogItems.each(this.addOne);
  },
  
  newBacklogItem : function(e){  	
  	BacklogItems.createFromForm(this.form);
  	
  	return false;
  },
	
});

$(function(){
	window.app = new BacklogPageView;
	window.backlogScroll = $("#scrollbar1").tinyscrollbar();
	
});
