require! {
    cheerio
    ramda:r
}

remove = (selector, $) --> $(selector).remove()
hide = (selector, $) --> $(selector).css 'display', 'none'

defaultActions = [
]
process = (actions) ->
    taps = r.map r.tap, r.concat(defaultActions, actions)
    r.pipe(
        cheerio.load
        r.apply r.pipe, taps
        ($) -> $.html()
    )

module.exports = {
    process
    remove
    hide
}
