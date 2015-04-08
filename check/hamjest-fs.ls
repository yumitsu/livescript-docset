require! {
    fs, q
}

isFile = ->
    matches: (path) ->
        deferred = q.defer()
        fs.stat path, (err, stats) ->
            if not err
                deferred.resolve stats.isFile()
            else if err.code is 'ENOENT'
                deferred.resolve false
            else deferred.reject(err)
        deferred.promise
    describeTo: (description) ->
        description.append 'a file'
    describeMismatch: (path, description) ->
        description.appendValue path
            .append ' was not a file'

module.exports = {
    isFile
}
