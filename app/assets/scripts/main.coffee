playing = false
checkforState = (id,cb)->
	if $(id)[0].readyState is 0
		setTimeout ->
			checkforState id,cb
		,5
	else cb()

toPlay = (id,caller)->
	k = id.split('_')[1]
	if playing is false
		$(id)[0].play()
		checkforState id,->
			len = $(id)[0].duration*1000 - $(id)[0].currentTime*1000
			$("#progress_#{k} .fuller").animate({
				width:'100%'
			},len, 'linear')
			$(caller).addClass('playing')
			playing = id
	else
		if playing is id
			$(id)[0].pause()
			$("#progress_#{k} .fuller").stop()
			$(caller).removeClass('playing')
			playing = false
		else
			$(playing)[0].pause()
			k2 = playing.split('_')[1]
			$("#progress_#{k2} .fuller").stop()
			$("#player_#{k2}").removeClass('playing')
			playing = false
			toPlay id,caller
	
$ ->
	$('audio').each ()->
		$(@)[0].addEventListener 'ended', ->
			k = $(@).attr('id').split('_')[1]
			$("#player_#{k}").removeClass('playing')
			$("#progress_#{k} .fuller").animate({width:0,5,'linear'})
			playing = false
		,false