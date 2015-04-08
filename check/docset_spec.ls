require! {
    path
    hamjest:{promiseThat}:_
    './hamjest-fs': {isFile}
}

docsetPath = process.env.DOCSET_PATH
pathInDocset = (relativePath) ->
    path.join docsetPath, relativePath

describe 'LiveScript docset' ->
    specify 'contains index' ->
        promiseThat pathInDocset('Contents/Resources/docSet.dsidx'), isFile()

