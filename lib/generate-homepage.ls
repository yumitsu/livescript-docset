require! {
    ramda:r
    './util': u
    './html'
}

makeContentFullWidth = ($) ->
    $('.content-row .span2').remove()
    $('.content')
        .removeClass 'span6'
        .css 'margin-left' '1em'
        .css 'margin-right' '1em'
        .css 'padding-top' '1em'

removeReferenceToReplAndFrenchDocs = ($) ->
    $('#overview h3').prev('p').remove()

removeTwitterWidgetScript = ($) ->
    $('.site script').first().remove()

markSectionsForToc = ($) ->
    sections = $('.content .section').each (_, el) ->
        section = $(el)
        name = section.find('h2').text()
        section.find('a').first()
            .addClass 'dashAnchor'
            .attr 'name' "//apple_ref/Section/#{encodeURIComponent name}"

actions = [
    html.remove '.side-row'
    makeContentFullWidth
    html.remove '.major-actions'
    removeReferenceToReplAndFrenchDocs
    removeTwitterWidgetScript
    markSectionsForToc
]

[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink

