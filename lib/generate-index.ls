require! {
    sqlite3, q, path, cheerio
    ramda:r
    './util':{readFile}
}

docsetPath = process.env.DOCSET_PATH
pathInDocset = (relativePath) ->
    path.join docsetPath, relativePath

createIndex = ->
    db = new sqlite3.Database pathInDocset('Contents/Resources/docSet.dsidx')
    deferred = q.defer()
    db.serialize ->
        db.run 'DROP TABLE IF EXISTS searchIndex;'
        db.run 'CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);'
        db.run 'CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);'
        deferred.resolve db
    deferred.promise

prepareInsert = (db, type) ->
    db.prepare "INSERT INTO searchIndex(name, type, path) VALUES (?, '#{type}', ?)"

writeSectionAnchorsToIndex = (sectionAnchors, db) ->
    stmt = prepareInsert db, 'Section'
    for name, anchor of sectionAnchors
        stmt.run name, 'index.html#'+anchor

extractSectionAnchors = (html) ->
    $ = cheerio.load html
    sectionAnchors = {}
    $('.content .section').each (_, el) ->
        section = $(el)
        name = section.find('h2').text()
        sectionAnchors[name] = "//apple_ref/Section/#{encodeURIComponent name}"
    sectionAnchors

apiPagePath = process.argv[2]
getHtml = r.always readFile apiPagePath


q [getHtml().then(extractSectionAnchors), createIndex()]
    .spread writeSectionAnchorsToIndex
    .done()
