activePodcast = {}
activeMetaData = {}
logout = ->
	$.get '/logout'
	window.location.href = '/'
setActiveValue = (key,value)->
	activePodcast[key] = value
	return
setActiveMetaValue = (key,value)->
	activeMetaData[key] = value
	return
glitterMessage = (type,message)->
	$('.glitter .message').removeClass('error, success')
	$('.glitter .message').addClass(type).html message
	$('.glitter').animate(
		{
			top:'10px'
		},500,'linear',->
			setTimeout ->
				$('.glitter').animate({top:'-100%'})
			,3000
	)
	return
guardarMetaData = ->
	$.post '/saveMetaData', {item:activeMetaData},(res)->
		glitterMessage 'success', 'Metadatos guardados'
	return
guardarPodcast = ->
	text = ''
	text += v for own k,v of activePodcast
	return if text.length is 0
	$.post '/savePodcast', {item:activePodcast},(res)->
		glitterMessage 'success', 'Episodio guardado'
		newItem()
		listPodcasts()
	return
listPodcasts = ->
	$.get '/getPodcasts', {item:activePodcast},(res)->
		$('#allItems').html res
	return
editar = (id)->
	$.post '/editPodcast', {id:id}, (html)->
		$('#newItem').html html
newItem = ->
	$.get '/getNewPodcast', (html)-> $('#newItem').html html
borrar = (id)->
	return unless confirm('Confirme eliminar elemento')
	$.post '/deletePodcast', {id:id}, (html)->
		listPodcasts()
$ ->
	newItem()
	listPodcasts()
	return