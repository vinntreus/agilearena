var SprintItem = Backbone.Model.extend({});

var SprintItemCollection = Backbone.Collection.extend({
	
	model : SprintItem,
	backlogId : $("#backlog-items-list").data("backlog-id"),
	url : function(){		
		return "/sprints/?backlog_id=" + this.backlogId;
	},
	createFromForm: function(form){		
		var that = this,
				loader = $(".loader", form);
		/* do this in wait for better solution with create */
		$.ajax({
			type: "POST",
			beforeSend : function(){
				loader.css("display", "inline-block");
			},
			data : form.serialize(),
			url : form.attr("action"),
			success : function(data, textStatus, jqXHR){
				that.add(data);
				$("input[type='text']", form).val("");
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

var SprintItems; // = new SprintItemCollection

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
