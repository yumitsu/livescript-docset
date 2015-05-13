require! {
    sqlite3, q, path
    ramda: {head, keys}
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

    getNoOfSections = ->
        deferred = q.defer()
        db.get 'select count(*) from searchIndex where type = "Section";', (err, row) ->
            if err then throw err
            firstColumnName = keys row |> head
            deferred.resolve noOfEntries = row[firstColumnName]
        deferred.promise

    getNoOfAllEntries = ->
        deferred = q.defer()
        db.get 'select count(*) from searchIndex;', (err, row) ->
            if err then throw err
            firstColumnName = keys row |> head
            deferred.resolve noOfEntries = row[firstColumnName]
        deferred.promise

    that.recreate = recreate
    that.addSection = addSection
    that.getNoOfSections = getNoOfSections
    that.getNoOfAllEntries = getNoOfAllEntries
    that



module.exports = {
    fromScratch: (docsetPath) -> DashIndex(docsetPath).recreate()
    open: (docsetPath) -> DashIndex(docsetPath)
}
