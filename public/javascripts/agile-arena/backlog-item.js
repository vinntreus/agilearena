var BacklogItem = Backbone.Model.extend({});

var BacklogItemCollection = Backbone.Collection.extend({
	model : BacklogItem,
	backlogId : $("#backlog-items-list").data("backlog-id"),
	url : function(){		
		return "/backlogs/items/" + this.backlogId;
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
		})
	}
});

var BacklogItems = new BacklogItemCollection

var BacklogItemView = Backbone.View.extend({
	tagName : "li",	
	template: $('#backlog_item_template'),	
	render : function(){
		$(this.el).html(this.template.jqote(this.model.toJSON()));		
		return this;
	}		
});
