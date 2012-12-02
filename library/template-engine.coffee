fs              = require 'fs'
_               = require 'underscore'
TimedHashTable  = require './datastructures/TimedHashTable'
Hogan           = require 'hogan.js'



class TemplateEngine

    render: (path, context) ->

        templateName = @getTemplateName path, context.settings
        template = @getTemplate templateName, context.settings
        options = @getPartials template, context.settings

        template.render context, options

    getTemplate: (templateName, settings) ->
        if settings['view cache']
            return @cache.get(templateName) ? @loadTemplateFromFile templateName, settings

        @loadTemplateFromFile templateName, settings

    getPartials: (template, settings) ->
        tree = Hogan.parse Hogan.scan template.text

        reducer = (memo, elm, list) ->

            if elm.nodes?
                memo.push _.reduce elm.nodes, reducer, []

            if elm.tag? and elm.tag == '>'
                return memo.concat(elm.n)

            return memo

        partialsNames = _.chain(tree).reduce(reducer, []).flatten().unique().value()

        partials = {}
        partials[path] = @getTemplate(path, settings).text for path in partialsNames
        partials


    getTemplateName: (templatePath, settings) ->
        templatePath.substr(settings['views'].replace(/\/$/, '').length).replace(/(\.[^.]+)$/, '')

    loadTemplateFromFile: (templateName, settings) ->
        template = Hogan.compile fs.readFileSync @resolvePath(templateName, settings), 'utf8'
        @cache.set(templateName, template)

        template

    resolvePath: (templateName, settings) ->
        basePath = settings['views'].replace(/\/$/, '')+"/"

        ext = '.'+settings['view engine'].replace /^\./, ''

        basePath+templateName+ext

    __express: (path, context, fn) =>
            try
                if not @cache?
                    @cache = new TimedHashTable(context.settings['view cache lifetime'] ? 1000*60*60*24*7)

                fn null, @render(path, context)
            catch e
                fn e

module.exports = TemplateEngine
