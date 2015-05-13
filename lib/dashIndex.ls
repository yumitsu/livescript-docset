require! {
    sqlite3, q, path
}

DashIndex = (docsetPath) ->
    db = new sqlite3.Database path.join(
        docsetPath, 'Contents/Resources/docSet.dsidx')
    that = {}

    recreate = ->
        deferred = q.defer()
        db.serialize ->
            db.run 'DROP TABLE IF EXISTS searchIndex;'
            db.run 'CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);'
            db.run 'CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);'
            deferred.resolve that
        deferred.promise

    addSection = (name, link) ->
        statement = db.prepare "INSERT INTO searchIndex(name, type, path) VALUES (?, 'Section', ?)"
        statement.run name, link

    prepare = (statement) ->
        db.prepare statement

    that.recreate = recreate
    that.addSection = addSection
    that


fromScratch = (docsetPath) ->
    DashIndex(docsetPath).recreate()

module.exports = {
    fromScratch
}
