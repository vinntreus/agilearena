var BacklogPageView = Backbone.View.extend({
	el : $('#backlogs_controller'),
	
	events : {
		"click #remove-item" : "removeBacklogItem",
		"click #add-sprint" : "addBacklogItemToSprint",
		"submit #new_backlog_item" : "newBacklogItem",
		"submit #new_sprint" : "newSprintItem"
	},
	
	initialize : function(){
		this.form    = this.$("#new_backlog_item");
		this.sprintform = this.$("#new_sprint");
		this.list = this.$("#backlog-items-list");

		SprintItems = new SprintItemCollection();
		//SprintItems.bind('add', this.addOneSprint, this);
    SprintItems.reset(sprintData);//defined in backlog/show.html.erb

		BacklogItems = new BacklogItemCollection();				
    BacklogItems.bind('add',   this.addOne, this);
    BacklogItems.bind('reset', this.render, this);
		BacklogItems.bind('change', this.itemChanged, this);
		BacklogItems.bind('destroy', this.itemDeleted, this);	  
		BacklogItems.reset(backlogData);  //defined in backlog/show.html.erb

  	$("button.always-available").show();
	},		
  addOne: function(backlogItem) {
    var view = new BacklogItemView({model: backlogItem});    
    this.$("#backlog-items-list").append(view.render().el);
  },
  render: function(){
		var currentSprintId = 0,
				currentSprint = null,
				sprintView = null,
				view = null;

		this.$("#backlog-items-list").children().remove();

  	BacklogItems.each(function(item){
			itemsprintId = item.get("sprint_id");

			if(itemsprintId != null && itemsprintId != currentSprintId){
				currentSprintId = itemsprintId;
				currentSprint = SprintItems.get(itemsprintId);
				sprintView = new SprintItemView({model : currentSprint});
	  		this.$("#backlog-items-list").append(sprintView.render().el);
			}

  		view = new BacklogItemView({model: item});
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
	addBacklogItemToSprint : function(e){
		$("#sprint-dialog").dialog("open");
		return false;
	},
	newSprintItem : function(e){
		console.log("new sprint");
		var that = this;
		var itemsId = _.map(BacklogItems.selected(), function(item){ return item.get("id"); });
   	SprintItems.createFromForm(this.sprintform, itemsId, function(data){
				$("#sprint-dialog").dialog("close");
				SprintItems.add(data);			
				_.each(BacklogItems.selected(), function(item){
					item.set({sprint_id : data.id, selected : false });
				});
				that.render();
		});
  	return false;
  },
  displayActionBySelection : function(){
		var buttons = "button.item-selected";
		$("li.selected", this.list).length > 0 ? $(buttons).show() : $(buttons).hide();
  }
});

$(function(){
	if($("#new_backlog_item").length > 0){
		$("#sprint-dialog").dialog({ autoOpen: false });
		window.backlogApp = new BacklogPageView;
	}	
});
