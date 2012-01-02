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
		
		$("#add_sprint_toggler").click(function(e){
			$("#new_sprint").toggle();
			return false;
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
				$("a", this).append("<p class='over'>Add to sprint</p>");
			},
			out : function(event, ui){
				$(".over", this).remove();
			},
			drop : function(event, ui){
				var sprintId = $(this).data("id");
				var itemId = ui.draggable.data("id");
				
				that.addItemToSprint(sprintId, itemId);
				
				$(".over", this).remove();
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
				result.set({ sprint : data.title });
			},
			error : function(jqXHR, textStatus, errorThrown){
				alert(jqXHR.responseText);
			}
		});
  },
  
  newSprintItem : function(e){
   	SprintItems.createFromForm(this.form);  	
  	return false;
  },
	
});

$(function(){
	if($("#new_sprint").length > 0){
		window.sprintApp = new SprintPageView;
	}
	
});
