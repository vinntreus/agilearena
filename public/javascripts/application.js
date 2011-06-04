// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
var AGILE = (function(){
	
	var log = function(item){
		if(window.console && window.console.log){
			window.console.log(item);
		}
	}
	
		
	var dir = function(item){
		if(window.console && window.console.dir){
			window.console.dir(item);
		}
	}
	
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
		item : "<li class='backlog-item' data-id='#i#'><a href='#' class='button right delete'>Delete</a><a href='#' class='button right edit'>Edit</a><p>##id# <span class='title'>#t#</span></p><p class='timestamp'>Created #c# ago.</p></li>",
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
				}
			});

			this.list.click(function(e){
				var clickedOn = $(e.target);
				
				if(clickedOn.is("a") && clickedOn.hasClass("edit"))
				{
					that.edit(clickedOn.parent());
					return false;
				}
				else if(clickedOn.is("a") && clickedOn.hasClass("delete"))
				{
					if(confirm("Are you sure you want to delete?"))
					{
						(function(currentItem){
							$.ajax({
								type: "DELETE",
								url : "/backlog_items/" + currentItem.data("id"),
								success : function(data, textStatus, jqXHR){
									currentItem.remove();
									that.decrementItems();
								},
								error : function(jqXHR, textStatus, errorThrown){
									alert(jqXHR.responseText);
								}
							});
						}(clickedOn.parent()));
					}				
					
					return false;
				}
			});
		},
		edit : function(backlogItem)
		{
			var that = this;

			$("#backlog_item_id").val(backlogItem.data("id"));
			$("#backlog_item_title").val( $(".title", backlogItem).text() );

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
						that.clearForm();
					},
					error : function(jqXHR, textStatus, errorThrown){
						alert(jqXHR.responseText);
					}
				});
				return false;
			});
		},
		getFormData : function(){
			var data = {};
			$("input", this.form).each(function(){
				var field = $(this);
				data[field.attr("name")] = field.val();
			});
			return data;
		},
		setupForm : function(){
			var that = this;
			this.clearForm();
			$("li", that.list).removeClass("selected");
			this.form.unbind("submit");
			this.form.submit(function(e)	{
				var d = that.getFormData();
				$.ajax({
					type: "POST",
					data : d,
					url : that.form.attr("action"),
					success : function(data, textStatus, jqXHR){
						var item = that.item.replace(/#t#/, d["backlog_item[title]"]);
						item = item.replace(/#id#/, data.id);
						item = item.replace(/#i#/, data.id);
						item = item.replace(/#c#/, data.created);
						that.list.append(item);
						that.incrementItems();
						$("li", that.list).removeClass("selected");
						var newItem = that.list.find("li:last");
						newItem.addClass("selected");
						var newItemForm = $("#new_backlog_item_form");
						newItemForm.css("top", "50%");
            newItemForm.css("position", "fixed");
            newItemForm.css("left", "50%");

						window.scrollTo(0, document.body.scrollHeight);
						that.clearForm();
					},
					error : function(jqXHR, textStatus, errorThrown){
						alert(jqXHR.responseText);
					}
				});
				return false;
			});
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
		clearForm : function(){
			var inputs = $("input[type='text']", this.form);
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
		
			setupToggle();			
			backlogItem.init();
		});
	}
	
	
	return this.init();	
	
})();
