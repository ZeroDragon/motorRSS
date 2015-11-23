podcasts = CT_LoadModel 'podcasts'

exports.home = (req,res)->
	res.render config.static + '/main/index.jade'

exports.admin = (req,res)->
	podcasts.getpocastInfo (info)->
		res.render config.static + '/main/admin.jade',{
			info : info
		}

exports.getPodcasts = (req,res)->
	podcasts.getPodcasts (podcasts)->
		res.render config.static + '/main/podcasts.jade',{
			pods : podcasts
		}

exports.getNewPodcast = (req,res)->
	res.render config.static + '/main/editPodcast.jade',{
		podcast : podcasts.newItem
	}

exports.editPodcast = (req,res)->
	podcasts.getPodcast req.body.id, (podcast)->
		res.render config.static + '/main/editPodcast.jade',{
			podcast : podcast
		}

exports.rss = (req,res)->
	podcasts.rss (data)->
		res.header 'Content-Type', 'application/xml'
		res.render config.static + '/main/rss.jade',{
			data:data.data
			pods:data.items
			pretty:true
		}

exports.deletePodcast = (req,res)->
	podcasts.deletePodcast req.body.id, (resp)->
		res.sendStatus resp

exports.savePodcast = (req,res)->
	podcasts.savePodcast req.body.item, (resp)->
		res.sendStatus resp

exports.saveMetaData = (req,res)->
	podcasts.saveMetaData req.body.item, (resp)->
		res.sendStatus resp