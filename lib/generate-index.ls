require! [sqlite3, q, path]

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

q createIndex()
.done()
