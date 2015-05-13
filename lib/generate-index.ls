require! {
    q, cheerio
    ramda:r
    './util':{readFile}
    './dashIndex': DashIndex
}

docsetPath = process.env.DOCSET_PATH

writeSectionAnchorsToIndex = (sectionAnchors, db) ->
    for name, anchor of sectionAnchors
        db.addSection name, 'index.html#'+anchor

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


q [getHtml().then(extractSectionAnchors), DashIndex.fromScratch(docsetPath)]
    .spread writeSectionAnchorsToIndex
    .done()
