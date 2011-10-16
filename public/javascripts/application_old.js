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
				return false;
		});
	}	
	
	var backlogItem = {
		form : null,
		list : null,
		itemsCount : null,	
		editForm : null,
		itemWhichIsBeingEdited : false,
		init : function()	{
			this.formContainer = this.formContainer || $("#new_backlog_item_form");
			this.form = this.form || $("#new_backlog_item");
			this.list = this.list || $("#backlog-items-list");
			this.itemsCount = this.itemsCount || $("#backlog-items-count");
			this.editForm = this.editForm || $("#edit_backlog_item_form");
			
			if(this.form.length){
				this.setupSubmitNewItemForm();
			}
			
			if(this.list.length && this.editForm.length){
				this.setupList();
			}
		},
		setupList: function(){
			var that = this;
			this.list.sortable({
				update : function(event, ui){
					that.sortItems(event, ui);
				},
				handle : ".handle"
			});

			

			this.list.click(function(e){
				var clickedOn = $(e.target);
				
				if( $.isFunction( that[clickedOn.data("event")] ) )	{
					return that[clickedOn.data("event")]( clickedOn.parents("li") );
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
			this.toEditMode(item);
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
		onCancelEdit: function(item){
			this.toDisplayMode(item);
			return false;
		},
		toDisplayMode : function(item){
			var displayMode = item.data("clone");
			item.replaceWith(displayMode);
			this.itemWhichIsBeingEdited = false;
		},
		updateItem: function(form, backlogItem)
		{
			var that = this,
					d = that.getFormData(form);
			$.ajax({
				type: "PUT",
				data : d,
				url : form.attr("action"),
				success : function(data, textStatus, jqXHR){
					that.updatedItem(data, backlogItem);
				},
				error : function(jqXHR, textStatus, errorThrown){
					alert(jqXHR.responseText);
				}
			});
		},
		updatedItem: function(formData, backlogItem){
			var item = $("#backlog_item_template").jqote(formData);
			backlogItem.data("clone",  item );
			this.deSelectAllItemsInList();
			this.toDisplayMode(backlogItem);
			countPoints(false);
		},
		toEditMode : function(backlogItem)
		{
			var that = this;
			if(this.itemWhichIsBeingEdited){
				this.toDisplayMode(this.itemWhichIsBeingEdited);
			}
			this.itemWhichIsBeingEdited = backlogItem;
			var displayMode = backlogItem.clone();
			backlogItem.data("clone", displayMode);
			backlogItem.load("/backlog_items/" + backlogItem.data("id"), function(){
				$("#backlog_item_title", backlogItem).focus();				
				
				$(".removeTag", backlogItem).bind("click.removeTag", that.onRemoveTagClick );
				
				$("#add_new_tag_button").click(function(e){
						var selectBox = $("#backlog_item_category_list"),
								textFieldValue = $("#add_new_tag").val(),
								tagLi = null;
			
						if( !textFieldValue ) return false;
						if( selectBox.children("option[value='"+ textFieldValue +"']").length ) return false;						

						selectBox.append(new Option(textFieldValue, textFieldValue, true, true));
						
						tagLi = $( $("#edit_backlog_tag_template").jqote({ name : textFieldValue }) );
						$(".removeTag", tagLi).bind("click.removeTag", that.onRemoveTagClick);
						$("#edit_backlog_item_tags").append(tagLi);						
				});
				
				that.setupEditItemForm( backlogItem.children("form"), backlogItem );
			});
		},
		onRemoveTagClick : function(e){
			$("#backlog_item_category_list")
						.find("option[value='" + $(this).data("tag") + "']")
						.remove();
			$(this).parent().remove();
		},
		setupEditItemForm : function(form, backlogItem)
		{
			var that = this;
			form.submit(function(e)	{
				var form = $(this);
				that.updateItem(form, backlogItem	);
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
		getFormData : function(form){
			form = form || this.form;
			return form.serialize();			
		},
		setupSubmitNewItemForm : function(){
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
		onAddedNewItem: function(data, formData){
			this.deSelectAllItemsInList();
			this.addToUI(data);
			this.incrementItems();
			this.positionNewItemForm();
			this.clearForm();
			countPoints(false);
		},
		positionNewItemForm: function(){
			window.scrollTo(0, document.body.scrollHeight);
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
			inputs.val("");
			$("select", this.form).val(0);
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
