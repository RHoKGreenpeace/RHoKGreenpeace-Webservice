module.exports = class HashTable
    table: {}
    size: 0

    get: (hash) ->
        @table[hash]

    set: (hash, value) ->
        ++@size if not @contains hash
        @table[hash] = value
        @

    remove: (hash) ->
        if @contains hash
            delete @table[hash]
            --@size
        @

    contains: (hash) ->
        @table[hash]?

    size: ->
        @size

    purge: ->
        delete @table
        delete @size

        @table = {}
        @size = 0

        @