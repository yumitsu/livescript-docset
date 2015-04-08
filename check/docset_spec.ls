require! {
    path, sqlite3
    hamjest:{assertThat, promiseThat, equalTo}:_
    './hamjest-fs': {isFile}
    ramda: {head, keys, map}
}

docsetPath = process.env.DOCSET_PATH
pathInDocset = (relativePath) ->
    path.join docsetPath, relativePath

describe 'LiveScript docset' ->
    resourcesToCheck =
        'low-res icon': 'icon.png'
        'Info.plist': 'Contents/Info.plist'
        'homepage': 'Contents/Resources/Documents/index.html'
        index: 'Contents/Resources/docSet.dsidx'
    expectResourceToExist = (resourceName) ->
        specify "contains #resourceName", ->
            promiseThat pathInDocset(resourcesToCheck[resourceName]), isFile()
    keys resourcesToCheck |> map expectResourceToExist


describe 'Index' ->
    specify 'contains no entries', (done) ->
        db = new sqlite3.Database pathInDocset('Contents/Resources/docSet.dsidx')
        err, row <- db.get 'select count(*) from searchIndex;'
        if err then throw err
        firstColumn = keys row |> head
        noOfEntries = row[firstColumn]
        assertThat noOfEntries, equalTo 0
        done()
