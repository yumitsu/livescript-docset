require! {
    path
    hamjest:{promiseThat}:_
    './hamjest-fs': {isFile}
    ramda: {keys, map}
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


