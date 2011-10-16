var BacklogPageView = Backbone.View.extend({
	el : $('#backlog-page'),
	
	events : {
		"submit #new_backlog_item" : "newBacklogItem"
	},
	
	initialize : function(){
		this.form    = this.$("#new_backlog_item");

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
