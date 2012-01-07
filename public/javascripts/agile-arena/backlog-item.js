var BacklogItem = Backbone.Model.extend({
	defaults: function() {
    return {
      selected: false
    };
  },
	toggleSelect : function(){
		this.set({selected : !this.get("selected")});
	}
});

var BacklogItemCollection = Backbone.Collection.extend({
	model : BacklogItem,
	backlogId : $("#backlog-items-list").data("backlog-id"),
	url : function(){		
		return "/backlog_items/";
	},		
	selected : function() {  
    return this.filter(function(item) {  
      return item.get('selected') == true;  
    });  
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

var BacklogItemView = Backbone.View.extend({
	tagName : "li",	
	template: $('#backlog_item_template'),	
	initialize: function(){
		_.bindAll(this, 'render');
		this.model.bind('destroy', this.remove, this);
		this.model.bind('change', this.render, this);
	},	
	events : {
		"click .backlog-selector" : "toggleSelect"
	},
	toggleSelect : function(){
		this.model.toggleSelect();
	},
  remove: function() {
    $(this.el).remove();
  },
	render : function(){
		var item = this.model.toJSON();
		var element = $(this.el);
		element.html(this.template.jqote(item));	
		element.addClass("fc");
		item.selected ? element.addClass("selected") : element.removeClass("selected");
		element.attr("data-id", item.id);	
		return this;
	}		
});
