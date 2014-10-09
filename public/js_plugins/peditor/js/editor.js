var editor = {
	settings: {
		articleModel: "article",
		articleAttr: "content",
		photoModel: "photo",
		photoColumn: "image",
		photoUpload: "uploadPhoto",
		photoDestroy: "/admin/peditor/deletePhoto",
		articleSection: "#articleContent",
		elements: ["p", "img", "video"],
		
		linkedp: false,
		linkedimg: false,
		p_selectList: ["paragraphFontClass", "paragraphFontColor", "paragraphFontSize"],
		paragraphFontClass: { "內文": "part-content"}, 
		paragraphFontColor: { "顏色": "default", "黑色": "#000", "藍色": "#00F" }, 
		paragraphFontSize: { "大小": "default", 14:14, 28:28 }
	},
	init: function(settings){
		editor.setEditor(settings);
		var prevEvent = null;
		editor.settings.articleSection.addClass("sortable");
		$( ".sortable" ).sortable({
			placeholder: "space",
			disable: true,
			update: function( event, ui ) {
			      	
			if(event.timeStamp == prevEvent){
				return null;
			}
			
			prevEvent = event.timeStamp;	},
			stop: function( event, ui ) {editor.save();}
		});

		//段落選單
		if($(".tab").length > 0){
			//bind自訂選單
			var sectionList = $(".tab");
			$("#editorPanel").append(sectionList);
		}
		else{
			//插入預設選單
			var editorList = $('<ul>');
			editorList.addClass("editorList");

			var sectionList = $("<div>").addClass("tab").append(editorList); //especially modified for ebs
			$("#editorPanel").append(sectionList);

			for(var index in editor.settings.elements){
				var element = editor[editor.settings.elements[index]];
				if(element){
					element.initTab();
				}
			}
		}

		//選單內容
		if($(".post").length > 0){
			//使用自訂的editorContent
			var editorContent = $(".post");
			var editorContentForm = $("<div class='form'>")
			
			editorContent.addClass("editorContent");
			$("#editorPanel").append(editorContent);
			$("#editorPanel").append(editorContentForm);
			
			$.each(editor.settings.elements, function(index, value){
				var tab = $("#tab-"+value);
				if(tab.length > 0){
					var editorChild =  editorContent.children("#post-"+value); //
					if(editorChild.length > 0 && !editorChild.hasClass("editorChild") ){
						editorChild.addClass("editorChild");
						$(".editorContent").append(editorChild);
						//$(".editorContent > form").append(editorChild);
						//alert(1);
					}
					else if(editorChild.length > 0 && editorChild.hasClass("editorChild") ){
						$(".editorContent").append(editorChild);
						//$(".editorContent > form").append(editorChild);
							//					alert(2);
					}
					else if(editorChild.length == 0){
						editor[value].initPost();
					}
				}	
			});
		}
		else{
			//插入預設editorContent
			var editorContent = $("<section>");
			editorContent.addClass("editorContent post");
			$("#editorPanel").append(editorContent);

			for(var index in editor.settings.elements){
				var element = editor[editor.settings.elements[index]];
				if(element){
					element.initPost();
				}
			}
		}

		/*
		if($(".button").length > 0){
			var editorAdd = $(".button");
		}
		else{
			var editorAdd = $("<section>");
			editorAdd.addClass("editorAdd button");
			var btnAdd = $("<a>");
			btnAdd.attr("href", "#");
			var icon = $("<img>").attr("src", "/peditor/img/add.png");
			btnAdd.append(icon).append("新增");

			editorAdd.append(btnAdd);
		}
		$("#editorPanel").append(editorAdd);
		*/
		
		editor.bindPanelControl();
		editor.show();
	},
	save: function(callback){
		if(callback){
			callback();
		}
		else{
			editor.pack();
		}
		$(".action").show();
	},
	ajaxupdate: function(){
		$.ajax({
			type: "POST",

			url: $(".edit_"+ editor.settings.articleModel).attr("action"),
			data: $(".edit_"+ editor.settings.articleModel).serialize(),
			success: function() {				
				editor.alert("文章變更已儲存", "success");
				$(window).trigger('peditor-updated');
			}
		});
	},
	pack: function(upload){
		var article = new Array();
		editor.settings.articleSection.children("div.paragraphContainer").each(function(){
			article.push(editor[$(this).data("type")].pack(this));
		});

		if(upload){
			article.push(upload);
		}

		$("#"+editor.settings.articleModel+"_"+editor.settings.articleAttr).val(editor.filter(JSON.stringify(article), editor.parsequot));

		editor.save(editor.ajaxupdate);
	},
	show: function(){
		var content = $("#"+editor.settings.articleModel+"_"+editor.settings.articleAttr).val();
		var article = content? JSON.parse(content):"";
		for(var i = 0, length = article.length; i < length; i++)
		{
			var paragraph = article[i];
			editor[paragraph.type].show(paragraph);
		}
	},
	output:function(content, articleSection){
		//read-only
		editor.settings.articleSection = $(articleSection? articleSection : editor.settings.articleSection);

		var content = content? content : $("#"+editor.settings.articleModel+"_"+editor.settings.articleAttr).val();
		//alert(content + "$$$"+editor.settings.articleModel.toString()+"$$"+editor.settings.articleAttr.toString());
		var article = JSON.parse((content && content.length>0)? content: "{}");

		
		for(var i = 0, length = article.length; i < length; i++)
		{
			var paragraph = article[i];
			//alert(paragraph.type.toString()+"$$$"+JSON.stringify(paragraph));
			editor[paragraph.type].output(paragraph);
		}
	},
	resetChild: function(){
		$(".editorChild.active").find("*").each(function(){
			switch(this.tagName){
				case "SELECT":
				$(this).prop('selectedIndex',0);
				break;
				case "OPTION":
				break;
				default:
					if($(this).is(':not(:hidden)') ) {
						$(this).val("");
					}
				break;
			}
		});
	},
	setEditor: function(settings){
		editor.settings.articleSection = $(editor.settings.articleSection);
		for(setting in settings){
			editor.settings[setting] = settings[setting];
		}
		if(editor.img){
			editor.img.setEditor();
		}
	},
	bindPanelControl: function(){
		var listBtns = new String();
		var listChildren = new String();
		
		$.each(editor.settings.elements, function(index, value){
			listBtns += "#tab-" + value + (index == editor.settings.elements.length-1? "": ", ");
			listChildren += "#post-" + value + (index == editor.settings.elements.length-1? "": ", ");
		});

		$(listChildren).hide();
		$($(listChildren)[0]).addClass("active").fadeIn();
		$($(listBtns)[0]).addClass("active");
		
		$(listBtns).click(function(event){
			$(listBtns+", "+listChildren).removeClass("active");
			$(listChildren).hide();
			$(this).addClass("active");

			$("#post-" + $(this).data("type")).addClass("active").fadeIn();

			event.preventDefault();
		});

		$(".editorAdd").click(function(event){
			var element = $(".tab").find(".active").data("type");
			editor[element].add();

			event.preventDefault();
		});
	},
	alert: function(alertMsg, type){
		if(window["Alertify"]){
			Alertify.log[type](alertMsg);
		} else if (window["alertify"]) {
			alertify.log(alertMsg, type);
		} else{
			//alert(alertMsg);
		}
	},
	HTMLfilter: function(text){
		return String(text).replace(/[&<>]/g, function(all){
			return "&" + {
				'&': 'amp',
				'<': 'lt',
				'>': 'gt'
			}[all] + ";";
		});
	},
	HTMLparser: function(text){
		return text.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&amp;/g, '&');
	},
	br2n: function(text){
		return text.replace(/<br>/g, '\n');
	},
	n2br: function(text){
		return text.replace(/\n/g, '<br>');
	},
	parsequot: function(text){
		return text.replace(/\\"/g,"&quot;").replace(/'/g,"&#39;").replace(/  /g, "&nbsp;&nbsp;");
	},

	filter: function(text){
		for(var i = 1, length = arguments.length; i<length; i++){
			text = arguments[i](text);
		}
		return text;
	},

	isPostNotSent: function(){
		var result = false;
		switch($(".post .active:first").attr("id")){
			case "post-p":
				result = $("#newParagraphContent").val();
			break;
			case "post-img":
				result = $("input[type=file]:first").val();
			break;
			case "post-video":
				result = $("#newVideoContent").val();
			break;
			case "post-list":
				var hasContent = false;
				$("#newListContent li input").each(function(){
					if($(this).val()){
						hasContent = true;
						return;
					}
				});

				result = hasContent;
			break;
		}

		return result;
	}
};