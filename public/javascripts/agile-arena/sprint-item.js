var SprintItem = Backbone.Model.extend({});

var SprintItemCollection = Backbone.Collection.extend({
	
	model : SprintItem,
	backlogId : $("#backlog-items-list").data("backlog-id"),
	url : function(){		
		return "/sprints/?backlog_id=" + this.backlogId;
	}
});

var SprintItems = new SprintItemCollection

var SprintItemView = Backbone.View.extend({
	tagName : "li",	
	template: $('#sprint_item_template'),	
	render : function(){
		var item = this.model.toJSON();
		var templatedEl = this.template.jqote(item);
		$(this.el).html(templatedEl);
		$(this.el).attr("data-id", item.id);	
		
		return this;
	}		
});