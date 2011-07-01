// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var AGILE = (function(){
	
	var log = function(item){
		if(window.console && window.console.log){
			window.console.log(item);
		}
	};	
		
	var dir = function(item){
		if(window.console && window.console.dir){
			window.console.dir(item);
		}
	};
	
	var countPoints = function(slowCount){
		var pointsContainer = $("#backlog-point-count"),
				pointElements = null,
				points = 0;
		if(pointsContainer.length == 0) return false;
		
		pointElements = $(".points");
		
		pointElements.each(function(index){
			var point = parseInt( $(this).text() );
			if (point) {
				points += point;
				if(slowCount) {
					pointsContainer.text(points);
				}
			}			
		});
		if(!slowCount)
			pointsContainer.text(points);
	};
		
	var setupToggle = function()	{
		$(".toggle-block").click(function(){
				var selectorToToggle = $(this).attr("data-toogle");
				$(selectorToToggle).show();
				//hack to test out - refactor
				if(selectorToToggle === '#new_backlog_item_form')
					backlogItem.setupForm();
				return false;
		});
	}	
	
	var backlogItem = {
		form : null,
		list : null,
		itemsCount : null,
		item : "<li class='backlog-item' data-id='#i#'><a href='#' class='button right delete'>Delete</a><a href='#' class='button right edit'>Edit</a><p class='points' title='Points: #points#'>#points#</p>#tags#<p>##id# <span class='title'>#t#</span></p><p class='timestamp'>Created #c# ago.</p></li>",
		init : function()	{
			this.formContainer = this.formContainer || $("#new_backlog_item_form");
			this.form = this.form || $("#new_backlog_item");
			this.list = this.list || $("#backlog-items-list");
			this.itemsCount = this.itemsCount || $("#backlog-items-count");
			
			if(this.list.length > 0){
				this.setupList();
			}
		},
		setupList: function(){
			var that = this;
			this.list.sortable({
				update : function(event, ui){
					that.sortItems(event, ui);
				}
			});

			this.list.click(function(e){
				var clickedOn = $(e.target);
				
				if( $.isFunction( that[clickedOn.data("event")] ) )	{
					return that[clickedOn.data("event")]( clickedOn.parent() );
				}
			});
		},
		onDeleteBacklogItem : function(item){
			if(confirm("Are you sure you want to delete?"))
			{
				this.deleteItem(item);
			}					
			return false;			
		},
		onEditBacklogItem : function(item){
			this.edit(item);
			return false;		
		},
		sortItems: function(event, ui){
			var newParentId = ui.item.prev().data("id") || 0,
					currentItemId = ui.item.data("id");
			$.ajax({
				type: "PUT",
				url : "/backlog_items/" + currentItemId + "/sort",
				data : { "new_parent" : newParentId },
				success : function(data, textStatus, jqXHR){
					log("success");
				},
				error : function(jqXHR, textStatus, errorThrown){
					alert(jqXHR.responseText);
				}
			});
		},
		edit : function(backlogItem)
		{
			var that = this;

			$("#backlog_item_id").val(backlogItem.data("id"));
			$("#backlog_item_title").val( $(".title", backlogItem).text() );
			$("#backlog_item_points").val( $(".points", backlogItem).text() );

			$("li", that.list).removeClass("selected");
			backlogItem.addClass("selected");
			
			this.formContainer.show();
			$("#backlog_item_title").focus();
			this.form.unbind("submit");
			this.form.submit(function(e)	{
				var d = that.getFormData();
				$.ajax({
					type: "PUT",
					data : d,
					url : that.form.attr("action") + "/" + backlogItem.data("id"),
					success : function(data, textStatus, jqXHR){
						that.formContainer.hide();
	 					$(".title", backlogItem).text(d["backlog_item[title]"]);
	 					$(".points", backlogItem).text(d["backlog_item[points]"] || "?"	);
						that.clearForm();
						countPoints(false);
					},
					error : function(jqXHR, textStatus, errorThrown){
						alert(jqXHR.responseText);
					}
				});
				return false;
			});
		},
		deleteItem: function(item){	
			var that = this;
			$.ajax({
				type: "DELETE",
				url : "/backlog_items/" + item.data("id"),
				success : function(data, textStatus, jqXHR){
					item.remove();
					that.decrementItems();
					countPoints(false);
				},
				error : function(jqXHR, textStatus, errorThrown){
					alert(jqXHR.responseText);
				}
			});
		},
		getFormData : function(){
			var data = {};
			$("input, select", this.form).each(function(){
				var field = $(this);
				data[field.attr("name")] = field.val();
			});
			return data;
		},
		setupForm : function(){
			var that = this;
			
			this.clearForm();			
			this.form.unbind("submit");
			this.form.submit(function(e){ that.onSubmitNewItem(); return false; });		
		},
		onSubmitNewItem : function(){
				var that = this,
						formData = this.getFormData();
				
				$.ajax({
					type: "POST",
					data : formData,
					url : that.form.attr("action"),
					success : function(data, textStatus, jqXHR){
						that.onAddedNewItem(data, formData);
					},
					error : function(jqXHR, textStatus, errorThrown){
						alert(jqXHR.responseText);
					}
				});
				
				return false;
		},
		positionNewItemForm: function(){
			var newItemForm = $("#new_backlog_item_form");
			newItemForm.css("top", "50%");
      newItemForm.css("position", "fixed");
      newItemForm.css("left", "50%");
			window.scrollTo(0, document.body.scrollHeight);
		},
		onAddedNewItem: function(data, formData){
			data.points = data.points || formData["backlog_item[points]"] || "?";
			this.deSelectAllItemsInList();
			this.addToUI(data);
			this.incrementItems();
			this.positionNewItemForm();
			this.clearForm();
			countPoints(false);
		},
		addToUI: function(item){			
			this.list.jqoteapp('#backlog_item_template', item);
		},
		incrementItems : function()
		{
			this.itemsCount.html(this.getItemsCount() + 1);
		},
		decrementItems : function()
		{
			this.itemsCount.html(this.getItemsCount() - 1);
		},
		getItemsCount : function()
		{
			return parseInt(this.itemsCount.text());
		},
		deSelectAllItemsInList : function(){
			$("li.selected", this.list).removeClass("selected");
		},
		clearForm : function(){
			var inputs = $("input[type='text']", this.form);
			$("select", this.form).val(0);
			inputs.each(function(){
				var field = $(this);
				field.val("");
			});
			inputs[0].focus();
		}		
	}
	
	init = function()	{
		//init in jquery context
		$(function(){
		
			countPoints(true);
			setupToggle();			
			backlogItem.init();
		});
	}
	
	
	return this.init();	
	
})();
