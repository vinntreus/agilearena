var SprintPageView = Backbone.View.extend({
	el : $('#backlog-page'),
	
	events : {
		"submit #new_sprint" : "newSprintItem"
	},
	
	initialize : function(){
		this.form    = this.$("#new_sprint");
		
		var items = $.map($("#sprint-items-list li"), function(item){
			var data = {
				id : $(item).data("id"),
				title : $("a", item).text()
			};
			return new SprintItem(data);
		});
		
		SprintItems = new SprintItemCollection(items);	
		
		this.setDroppable();		

    SprintItems.bind('add',   this.addOne, this);
    SprintItems.bind('reset', this.addAll, this);
	},
	
	setDroppable : function(){
		var list = this.$("#sprint-items-list li"),
				that = this;
		list.droppable("destroy");
		list.droppable({
			accept: '#backlog-items-list li',
			activeClass: 'active-droppable',
			tolerance: 'pointer',
			over: function(event, ui){
				$("a", this).append("<span class='over'>Add to sprint</span>");
			},
			out : function(event, ui){
				$("span.over", this).remove();
			},
			drop : function(event, ui){
				//console.log("sprintid: " + $(this).data("id"));
				//console.log("itemid: " + ui.draggable.data("id"));
				var sprintId = $(this).data("id");
				var itemId = ui.draggable.data("id");
				
				that.addItemToSprint(sprintId, itemId);
				
				$("span.over", this).remove();
			}
		});
	},
	
	addOne: function(SprintItem) {
    var view = new SprintItemView({model: SprintItem});
    this.$("#sprint-items-list").append(view.render().el);
    window.sprintScroll.tinyscrollbar_update('bottom');
 		this.setDroppable();
  },
  
  addItemToSprint : function(sprintId, itemId){
  	$.ajax({
			type: "POST",
			data : {id : sprintId, itemId : itemId},
			url : "/sprints/addItemTo",
			success : function(data, textStatus, jqXHR){
				var result = BacklogItems.get(itemId);
				var sprint = SprintItems.get(sprintId).get("title");
				result.set({ sprint : sprint });
			},
			error : function(jqXHR, textStatus, errorThrown){
				alert(jqXHR.responseText);
			}
		});
  },
  
  newSprintItem : function(e){  	

   	SprintItems.create();
  	
  	return false;
  },
	
});

$(function(){
	window.sprintApp = new SprintPageView;
	window.sprintScroll = $("#scrollbar2").tinyscrollbar();
});
