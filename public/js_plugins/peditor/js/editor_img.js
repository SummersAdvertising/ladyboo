editor.img = {
	setEditor: function(){
		editor.img.photoModel = editor.settings.photoModel;
		editor.img.fileinputID = editor.settings.photoModel + "_" + editor.settings.photoColumn;
		editor.img.fileinputName = editor.settings.photoModel + "[" + editor.settings.photoColumn + "]";
		editor.img.photoUpload = editor.settings.photoUpload;
		editor.img.photoDestroy = editor.settings.photoDestroy;
		editor.img.photoDefaultHeight = editor.settings.photoDefaultHeight ? editor.settings.photoDefaultHeight: 800;
		editor.img.photoDefaultWidth = editor.settings.photoDefaultWidth? editor.settings.photoDefaultWidth: 800;
	},
	initTab: function(){
		var li = $("<li>");
		li.attr("data-type", "img").attr("id", "tab-img");
		var a = $("<a>").append("圖片");
		var icon = $("<img>").attr("src", "/images/photo.png");
		a.prepend(icon);

		li.append(a);
		$(".editorList").append(li);
	},
	initPost: function(){
		var editorChild = $("<div>");
		editorChild.attr("id", "post-img");
		editorChild.addClass("editorChild");
		
		var divwrap = $("<div class='upload'></div>");
		var form = $("<form>");
		form.attr("accept-charset", "UTF-8").attr("action", editor.img.photoUpload).attr("data-remote", "true").attr("enctype", "multipart/form-data").attr("id", "new_"+editor.img.photoModel).attr("method", "post");
		
		//var explain = $('<p>請先選擇圖片後點選加入內文</p>');
		
		var input = $("<input>");
		input.attr("id", editor.img.fileinputID).attr("name", editor.img.fileinputName).attr("type", "file").attr('class', 'file');
		// input.change(function(event){
		// 	//$(this).addClass("afterselected");
		// 	$(this).addClass('afterselected');
		// });
		// input.bind("click", function(event){
		// 	console.log('in1');
		// });
		// input.on("click", function(event) {
  //     console.log('in2');
  //   });
	
		var span = $('<span id="imageAttributes">');
		/*
		var inputWidth = $("<input>");
		inputWidth.attr("id", 'PeditorPhotoWidth').attr('placeholder', '輸入寬度或不填使用預設').attr("name", 'photo[width]').attr("type", "text");
		inputWidth.css('width', '20%')
		
		
		var inputHeight = $("<input>");
		inputHeight.attr("id", 'PeditorPhotoheight').attr('placeholder', '輸入高度或不填使用預設').attr("name", 'photo[height]').attr("type", "text");
		inputHeight.css('width', '20%')
		
		span.append( inputWidth ).append( ' * ' ).append( inputHeight );
		*/
		
		var preview = $('<div id="peditorPhotoPreview">');
		
		$('#previewContainer').append(preview);
		
		//form.append(explain).append(input).append($("<br>")).append($("input[name='authenticity_token']").eq(0).clone().change(function() {  }));
		form.append(input).append($("<br>")).append($("input[name='authenticity_token']").eq(0).clone().change(function() {  }));
		if(editor.settings.linkedimg){
			var link = $("<input>");
			link.attr("type", "text").attr("id", "newImageLink").attr("placeholder", "此段落連結至何處（若無請勿輸入）").attr("size", "80");
			form.append(link);
		}

		//var table = $('<table width="100%" border="0" cellspacing="0" cellpadding="0"></table>');
		
		form.appendTo(divwrap);
		//table.append($('<tr>').append($('<td width="100%" valign="top">').append(divwrap)));

		$(".editorContent > .form").append(editorChild.append(divwrap));
	},
	add: function(){
		if(!$("#"+editor.img.fileinputID).val()){
			editor.alert("請選擇要上傳的圖片", "error");
			return ;
		}

		if(editor.img.validate()){
			$("#new_" + editor.img.photoModel).submit();
			
		}
		$("#"+editor.img.fileinputID).val("");

	},
	update: function(image){
		
		$('#peditorPhotoPreview').children().remove();
		$('[class^=imgareaselect]').hide()
		editor.pack(image);
		editor.img.show(image);
	},
	setup: function(image, resize_url){
	
		var resize_data;
		
		$('#peditorPhotoPreview').children().remove();
		
		$('#peditorPhotoPreview').append(image);
		
		var a = image.imgAreaSelect({
	        handles: true,
	        aspectRatio: '0',
	        instance: true,
	        onSelectEnd: function(img, selection) {
	        	resize_data = selection;
	        }
        });
	
		var btn = $('<button>完成截圖</button>').click(function(event){
			
			event.preventDefault();
			
        	$.ajax({
	        	method: 'POST',
	        	url: resize_url,
	        	data: resize_data,
	        	success: function(  ) {	        			
		        	$('#peditorPhotoPreview').children().remove();
		        	$('[class^=imgareaselect]').remove();
		        	a.setSelection(1, 1, 1, 1, true);
		        	a.update();
	        	}
        	});
		
       });
		$('#peditorPhotoPreview').append('<br />').append(btn);
		
		var showResizeArea = function() {
			 $.colorbox({ inline: true, href: '#previewContainer' });
			 
		}
		
		// delay for image load
		setTimeout(showResizeArea, 500);
	},
	reset: function() {			
		$('#peditorPhotoPreview').children().remove();
		$('[class^=imgareaselect]').remove()
	},
	show: function(paragraph){
		var paragraphBox = this.output(paragraph);
		paragraphBox.addClass("paragraphContainer part");

		this.bindControl(paragraphBox, paragraph.id);
	},
	output: function(paragraph){
		var paragraphBox = $("<div class='part'>"); //especially modified for ebs
		paragraphBox.attr("data-type", "img");

		var img = $("<img>");
		img.attr("alt", paragraph.id);
		img.attr("src", paragraph.path);
		img.attr("title", paragraph.id);
		img.addClass('img-responsive');

		if(paragraph.link){
			var a = $("<a>");
			a.attr("href", paragraph.link).attr("target", "_blank");
			a.append(img);

			paragraphBox.append(a);
		}
		else{
			paragraphBox.append(img);
		}

		editor.settings.articleSection.append(paragraphBox);

		return paragraphBox;
	},
	pack: function(paragraphContainer){
		var paragraph = new Object();
		var content = $(paragraphContainer).find("img:first");
		if(content.parent("a")){
			paragraph.link = content.parent("a").attr("href");
		}

		paragraph.type = "img";
		paragraph.id = $(content).attr("alt");
		paragraph.path = $(content).attr("src");

        return paragraph;
	},
	validate: function(){
		//validate image upload
		var isSubmit = true;

		var fileinput = document.getElementById(editor.img.fileinputID);
		var uploadSize, uploadType;
        
        if(navigator.userAgent.indexOf("MSIE")>-1){
        	//IE: do nothing.

            // var obj = new ActiveXObject("Scripting.FileSystemObject");
            // uploadSize = obj.getFile(fileinput.value).size;
            // uploadType = obj.getFile(fileinput.value).type;
        }
        else{
        	uploadSize = fileinput.files.item(0).size;
            uploadType = fileinput.files.item(0).type;

            switch(uploadType){
            	case "image/gif":
            	case "image/png":
            	case "image/jpg":
            	case "image/jpeg":
            		isSubmit = true;
            	break;

            	default:
            		isSubmit = false;
            		editor.alert("只能上傳 gif/png/jpg 圖片檔", "error");
            	break;
            }

            if(uploadSize > 5 * 1024 *1024){
            	editor.alert("檔案大小不能超過5MB", "error");
            	isSubmit = false;
            }
        }
        
        return isSubmit;
	},
	bindControl: function(paragraphBox, photoID){
		var controlPanel = $("<div>");
		controlPanel.addClass("controlPanel tool-b tool");

		if(editor.settings.linkedimg){
			var edit = $("<a>");
			edit.append("編輯").attr("data-control", "edit").addClass("edit");
			controlPanel.append(edit);
			editor.img.bindEdit(edit);
		}

		var del = $("<a>");
		del.attr("href", editor.img.photoDestroy+"/"+photoID);
		del.attr("data-method", "delete");
		del.attr("data-remote", "true");
		del.addClass("delete")
		del.append(""); //刪除
		del.click(function(){
			paragraphBox.remove();
			editor.save();
		});

		controlPanel.append(del);
		paragraphBox.prepend(controlPanel);

	},
	bindEdit: function(edit){
		$(edit).bind("click", function(){
			$(".action").hide();
			var controlPanel = $(this).parents(".controlPanel");
			var paragraphContainer = $(this).parents(".paragraphContainer");
			editor.img.edit(paragraphContainer, controlPanel);
		});
	},
	edit: function(paragraphContainer, controlPanel){
		controlPanel.hide();
		$(".controlPanel a[data-control = edit]").each(function(){
			$(this).unbind();
		});

		var editPanel = $("<div>");
		editPanel.addClass("editbox");

		var imgLink = paragraphContainer.children("a:first");
		var textarea = $("<input type='text' size='50'>");
		textarea.addClass("autogrow").attr("placeholder", "段落尚未建立連結。");
		
		if(imgLink.length>0){
			imgLink.hide();
			textarea.val(imgLink.attr("href"));
		}
		else{
			imgLink = $("<a href='#'>");
			imgLink.append(paragraphContainer.children("img:first"));
		}

		var cancel = $("<a>");
		cancel.append("取消");
		cancel.click(function(){
			editPanel.remove();
			controlPanel.removeAttr("style");
			if(imgLink.attr("href").length>1){
				imgLink.show();
			}
			else{
				paragraphContainer.append(imgLink.html());
				imgLink.remove();
			}

			$(".controlPanel a[data-control = edit]").each(function(){
				var type = $(this).parents(".paragraphContainer").data("type");
				editor[type].bindEdit(this);
			});

			editor.save();
		});

		var save = $("<a>");
		save.append("完成");
		save.click(function(event){
			
		
			if(textarea.val()){
				imgLink.attr("href", textarea.val()).show();
				paragraphContainer.append(imgLink);
			}
			else{
				paragraphContainer.append(imgLink.html());
				imgLink.remove();
			}

			editPanel.remove();
			controlPanel.removeAttr("style");

			editor.save();

			$(".controlPanel a[data-control = edit]").each(function(){
				var type = $(this).parents(".paragraphContainer").data("type");
				editor[type].bindEdit(this);
			});
			
		});

		var editbtnBar = $("<div>");
		editbtnBar.addClass("tool-a").append(save).append(cancel);
		editPanel.append(textarea).append($("<br>")).append(editbtnBar);
		paragraphContainer.append(editPanel);
	}
};