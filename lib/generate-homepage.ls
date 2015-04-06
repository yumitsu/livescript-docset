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


actions = [
    html.remove '.side-row'
    makeContentFullWidth
    html.remove '.major-actions'
]

[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink

