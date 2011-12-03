$ ->
	$('#photo_file').fileupload
    dataType: 'script'
    url: $(this).parents('form').attr('action')
    type: 'POST'