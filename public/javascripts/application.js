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
				$(selectorToToggle).toggle();					
				return false;
		});
	}
	
	var backlogItem = {
		form : null,
		list : null,
		item : "<li class='backlog-item' data-id='#i#'><a href='#' class='button right delete'>Delete</a><p class='title'>#t#</p><p class='timestamp'>Created #c# ago.</p></li>",
		init : function()	{
			this.form = this.form || $("#new_backlog_item");
			this.list = this.list || $("#backlog-items-list");
			if(this.form.length > 0){
				this.setupForm();
			}
			if(this.list.length > 0){
				this.setupList();
			}
		},
		setupList: function(){
			this.list.click(function(e){
				var clickedOn = $(e.target);
				if(clickedOn.is("a") && clickedOn.hasClass("delete"))
				{
					var currentItem =	clickedOn.parent();
					$.ajax({
						type: "DELETE",
						url : "/backlog_items/" + currentItem.data("id"),
						success : function(data, textStatus, jqXHR){
							currentItem.remove();
						},
						error : function(jqXHR, textStatus, errorThrown){
							alert(jqXHR.responseText);
						}
					});
					return false;
				}
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
			this.form.submit(function(e)	{
				var d = that.getFormData();
				$.ajax({
					type: "POST",
					data : d,
					url : that.form.attr("action"),
					success : function(data, textStatus, jqXHR){
						var item = that.item.replace(/#t#/, d["backlog_item[title]"]);
						item = item.replace(/#i#/, data.id);
						item = item.replace(/#c#/, data.created);
						$("#backlog-items-list").append(item);
						that.clearForm();
					},
					error : function(jqXHR, textStatus, errorThrown){
						alert(jqXHR.responseText);
					}
				});
				return false;
			});
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
