main = CT_LoadController 'main'
basicAuth = require 'basic-auth'

unauthorized = (res) ->
	res.set 'WWW-Authenticate', 'Basic realm=Authorization Required'
	res.sendStatus(401)
auth = (req, res, next)->
	user = basicAuth(req)
	if (!user || !user.name || !user.pass)
		return unauthorized res
	if (user.name is 'foo' && user.pass is 'bar')
		return next()
	else
		return unauthorized res

app.get '/', main.home
app.get '/admin', auth, main.admin
app.get '/getNewPodcast', auth, main.getNewPodcast
app.get '/getPodcasts', auth, main.getPodcasts
app.get '/rss', main.rss
app.get '/logout', (req,res)-> return unauthorized res

app.post '/savePodcast', auth, main.savePodcast
app.post '/saveMetaData', auth, main.saveMetaData
app.post '/editPodcast', auth, main.editPodcast
app.post '/deletePodcast', auth, main.deletePodcast