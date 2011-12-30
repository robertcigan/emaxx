$ ->
	$('#photo_file').fileupload
    sequentialUploads: true
    dataType: 'script'
    url: $(this).parents('form').attr('action')
    type: 'POST'