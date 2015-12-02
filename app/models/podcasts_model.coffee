selectDB = (cb)->
	db = new sqlite3.Database "#{__dirname}/../data/database.db"
	db.serialize ->
		db.run """
			CREATE TABLE if not exists podcast_data (
				title TEXT,
				link TEXT,
				language TEXT,
				copyright TEXT,
				subtitle TEXT,
				author TEXT,
				summary TEXT,
				owner_name TEXT,
				owner_email TEXT,
				image TEXT,
				category TEXT,
				itunes_link TEXT,
				itunes_image TEXT
			)
		"""
		db.run """
			CREATE TABLE if not exists podcasts (
				id INTEGER PRIMARY KEY,
				title TEXT,
				author TEXT,
				subtitle TEXT,
				summary TEXT,
				image TEXT,
				enclosure_url TEXT,
				enclosure_length TEXT,
				guid TEXT,
				pubDate TEXT,
				duration TEXT
			)
		"""
	cb db

class Item
	schema : [
		{k:"title",name:"Título"},
		{k:"author",name:"Autor"},
		{k:"subtitle",name:"Subtítulo"},
		{k:"summary",name:"Resumen"},
		{k:"image",name:"Imagen"},
		{k:"enclosure_url",name:"Url"},
		{k:"enclosure_length",name:"Peso"},
		{k:"guid",name:"ID"},
		{k:"pubDate",name:"Fecha"},
		{k:"duration",name:"Duración"},
	]
	constructor: (def)->
		for item in @.schema
			@[item.k] = if def? then def[item.k] ?= '' else ''

exports.newItem = do -> return new Item

class Podcast
	schema : [
		{k:"title",name:"Título"}
		{k:"link",name:"Link"}
		{k:"language",name:"Lenguaje"}
		{k:"copyright",name:"Copyright"}
		{k:"subtitle",name:"Subtítulo"}
		{k:"author",name:"Autor"}
		{k:"summary",name:"Resumen"}
		{k:"owner_name",name:"Nombre de Dueño"}
		{k:"owner_email",name:"Email de Dueño"}
		{k:"image",name:"Imagen"}
		{k:"category",name:"Categoría"}
		{k:"itunes_link",name:"Link en iTunes"}
		{k:"itunes_image",name:"Banner de iTunes"}
	]
	constructor: (def)->
		for item in @.schema
			@[item.k] = if def? then def[item.k] ?= '' else ''

exports.getpocastInfo = (cb)-> selectDB (db)->
	query = "SELECT * FROM podcast_data"
	db.get query, {}, (err,row)->
		unless row?
			resp = new Podcast
		else
			resp = new Podcast(row)
		cb resp

exports.getPodcasts = (cb)-> selectDB (db)->
	query = """
		SELECT id,title,subtitle,pubDate FROM podcasts ORDER BY pubDate DESC
	"""
	db.all query, {}, (err,rows)->
		cb rows

exports.deletePodcast = (id,cb)-> selectDB (db)->
	db.run "DELETE FROM podcasts WHERE id=#{id}"
	cb 200

exports.getPodcast = (id,cb)-> selectDB (db)->
	query = """
		SELECT * FROM podcasts WHERE id=$id
	"""
	db.get query, {$id:id}, (err,item)->
		item = new Item item
		item.id = id
		cb item

exports.savePodcast = (values,cb)-> selectDB (db)->
	if values.id
		id = values.id
		delete values.id
		queryArr = []
		queryArr.push("#{k}=$#{k}") for own k,v of values
		query = "UPDATE podcasts SET #{queryArr.join(', ')} WHERE id=#{id}"
	else
		query = """
			INSERT INTO podcasts (#{Object.keys(values).join(',')}) VALUES (#{Object.keys(values).map((e)->'$'+e).join(',')})
		"""
	vals = {}
	for own k,v of values
		vals["$#{k}"] = v
	db.run query,vals
	cb 200

exports.saveMetaData = (values,cb)-> selectDB (db)->
	db.serialize ->
		db.run "DELETE FROM podcast_data"
		query = """
			INSERT INTO podcast_data (#{Object.keys(values).join(',')}) VALUES (#{Object.keys(values).map((e)->'$'+e).join(',')})
		"""
		vals = {}
		for own k,v of values
			vals["$#{k}"] = v
		db.run query,vals
	
	cb 200

exports.rss = (cb)-> selectDB (db)->
	db.get "SELECT * FROM podcast_data", (err,data)->
		db.all "SELECT * FROM podcasts ORDER BY pubDate DESC LIMIT 30", (err,items)->
			cb {data:data,items:items}