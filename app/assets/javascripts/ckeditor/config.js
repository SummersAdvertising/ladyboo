CKEDITOR.editorConfig = function( config ) {

  config.filebrowserBrowseUrl = "/admin/ckeditor/attachment_files";
  config.filebrowserFlashBrowseUrl = "/admin/ckeditor/attachment_files";
  config.filebrowserFlashUploadUrl = "/admin/ckeditor/attachment_files";
  config.filebrowserImageBrowseLinkUrl = "/admin/ckeditor/pictures";
  config.filebrowserImageBrowseUrl = "/admin/ckeditor/pictures";
  config.filebrowserImageUploadUrl = "/admin/ckeditor/pictures";
  config.filebrowserUploadUrl = "/admin/ckeditor/attachment_files";

  config.extraPlugins = 'youtube';
  config.youtube_width = '560';
  config.youtube_height = '315';
  config.youtube_related = false;
  config.youtube_older = false;
  config.youtube_privacy = false;
  config.toolbar_Pure = [
    '/', {
      name: 'basicstyles',
      items: ['Bold', 'Italic', 'Underline', 'Strike', 'Subscript', 'Superscript', '-', 'RemoveFormat']
    }, {
      name: 'paragraph',
      items: ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent', '-', 'Blockquote', '-', 'JustifyLeft', 'JustifyCenter', 'JustifyRight', 'JustifyBlock', '-', 'BidiLtr', 'BidiRtl']
    }, {
      name: 'links',
      items: ['Link', 'Unlink']
    }, '/', {
      name: 'styles',
      items: ['Styles', 'Format', 'Font', 'FontSize']
    }, {
      name: 'colors',
      items: ['TextColor', 'BGColor']
    }, {
      name: 'insert',
      // items: ['Image', 'HorizontalRule', 'PageBreak', 'Youtube']
      items: ['Image', 'HorizontalRule', 'PageBreak','-', 'Youtube']
    }
  ];
  config.toolbar = 'Pure';
  config.allowedContent = true;
  return true;
};
