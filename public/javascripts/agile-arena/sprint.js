var SprintPageView = Backbone.View.extend({
	el : $('#backlog-page'),
	
	events : {
		"submit #new_sprint" : "newSprintItem"
	},
	
	initialize : function(){
		this.form    = this.$("#new_sprint");

    SprintItems.bind('add',   this.addOne, this);
    SprintItems.bind('reset', this.addAll, this);
	},
	
	addOne: function(SprintItem) {
    var view = new SprintItemView({model: SprintItem});
    this.$("#sprint-items-list").append(view.render().el);
    window.sprintScroll.tinyscrollbar_update('bottom');
  },
  
  newSprintItem : function(e){  	

   	SprintItems.create();
  	
  	return false;
  },
	
});

$(function(){
	window.app = new SprintPageView;
	window.sprintScroll = $("#scrollbar2").tinyscrollbar();
});
