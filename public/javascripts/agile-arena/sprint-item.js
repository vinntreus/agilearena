var SprintItem = Backbone.Model.extend({});

var SprintItemCollection = Backbone.Collection.extend({
	
	model : SprintItem,
	backlogId : $("#backlog-items-list").data("backlog-id"),
	url : function(){		
		return "/sprints/?backlog_id=" + this.backlogId;
	},
	createFromForm: function(form, backlogItems, onsuccess){		
		var that = this,
				loader = $(".loader", form),
				data = form.serializeArray();
		data[data.length] = { "name" : "backlogItems", "value" : backlogItems};
		//console.log(data);
		/* do this in wait for better solution with create */
		$.ajax({
			type: "POST",
			beforeSend : function(){
				loader.css("display", "inline-block");
			},
			data : data,
			url : form.attr("action"),
			success : function(data, textStatus, jqXHR){
				onsuccess(data);
			},
			error : function(jqXHR, textStatus, errorThrown){
				alert(jqXHR.responseText);
			},
			complete : function(){
				loader.hide();
			}
		});
	}
});

var SprintItemView = Backbone.View.extend({
	tagName : "li",	
	template: $('#sprint_item_template'),	
	render : function(){
		var item = this.model.toJSON();
		var templatedEl = this.template.jqote(item);
		$(this.el).html(templatedEl);
		$(this.el).attr("data-id", item.id);	
		$(this.el).addClass("sprint-item fc");	
		
		return this;
	}		
});
