require! {
    ramda:r
    './util': u
    './html'
}

actions = [
    html.remove '.compiler'
]

[source, sink] = process.argv[2, 3]

u.readFile source
.then html.process actions
.then u.writeToFile sink

