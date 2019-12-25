require! {
    path
    hamjest:{assertThat, promiseThat, equalTo}:_
    './hamjest-fs': {isFile}
    ramda: {keys, map}
    '../lib/dashIndex': DashIndex
}

docsetPath = process.env.DOCSET_PATH
pathInDocset = (relativePath) ->
    path.join docsetPath, relativePath

describe 'LiveScript docset' ->
    resourcesToCheck =
        'low-res icon': 'icon.png'
        'high-res icon': 'icon@2x.png'
        'Info.plist': 'Contents/Info.plist'
        'homepage': 'Contents/Resources/Documents/index.html'
        index: 'Contents/Resources/docSet.dsidx'
    expectResourceToExist = (resourceName) ->
        specify "contains #resourceName", ->
            promiseThat pathInDocset(resourcesToCheck[resourceName]), isFile()
    keys resourcesToCheck |> map expectResourceToExist


describe 'Index' ->
    var index
    beforeEach ->
        index := DashIndex.open(docsetPath)

    specify 'contains all sections', (done) ->
        index.getNoOfSections().then ->
            assertThat it, equalTo 26
            done()
        .done()

    specify 'contains nothing else', (done) ->
        index.getNoOfAllEntries().then ->
            assertThat it, equalTo 26
            done()
        .done()
