var BacklogItem = Backbone.Model.extend({
	initialize: function(item){
		this.bind("change", this.ch, this);
	},
	ch: function(){
		console.log("BacklogItem:changed");
	}
});

var BacklogItemCollection = Backbone.Collection.extend({
	model : BacklogItem,
	backlogId : $("#backlog-items-list").data("backlog-id"),
	url : function(){		
		return "/backlogs/items/" + this.backlogId;
	},	
	initialize: function(items){
		//console.log(items);
		
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

var BacklogItems;// = new BacklogItemCollection

var BacklogItemView = Backbone.View.extend({
	tagName : "li",	
	template: $('#backlog_item_template'),	
	initialize: function(){
		_.bindAll(this, 'render');
    this.model.bind('change', this.render);
    //this.render();
	},	
	render : function(){
		var item = this.model.toJSON();
		$(this.el).html(this.template.jqote(item));	
		$(this.el).addClass("fc");
		$(this.el).attr("data-id", item.id);	
		return this;
	}		
});
