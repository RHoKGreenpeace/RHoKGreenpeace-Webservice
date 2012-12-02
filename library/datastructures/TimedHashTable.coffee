module.exports = class TimedHashTable
    table: {}
    timers: {}
    size: 0

    constructor: (@defaultTimeout) ->

    get: (hash) ->
        @table[hash]

    set: (hash, value, timeout = @defaultTimeout) ->

        if not @contains hash
            ++@size
        else
            clearTimeout @timers[hash]

        @table[hash] = value
        @timers[hash] = setTimeout @remove, timeout, hash

        @

    contains: (hash) ->
        @table[hash]?

    size: ->
        @size

    remove: (hash) =>
        if @contains hash
            clearTimeout @timers[hash]

            delete @table[hash]
            delete @timers[hash]

            --@size

        @

    purge: ->
        clearTimeout(timer) for timer of @timers

        delete @table
        delete @timers
        delete @size

        @table = {}
        @timers = {}
        @size = 0

        @