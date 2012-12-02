express     = require 'express'
mongoose    = require 'mongoose'
consolidate = require 'consolidate'
gcm         = require 'node-gcm'

dateFormat  = require 'dateformat'
dateFormat.i18n.monthNames = ["Jan.", "Feb.", "Marts", "April", "Maj", "Juni", "Juli", "Aug.", "Sep.", "Okt.", "Nov.", "Dec."];

app = express()

##Web Config
app.use express.compress()
app.use     express.static "#{__dirname}/resources/public"
app.use express.bodyParser()
app.use express.methodOverride()
app.use app.router

app.configure 'development', ->
    app.use express.logger ':method :url'
    app.use express.errorHandler { dumpExceptions: true, showStack: true }

app.configure 'production', ->
    app.use express.errorHandler()

app.engine 'html', consolidate.hogan
app.set 'view engine', 'html'
app.set 'views', "#{__dirname}/application/templates"
##End Web Config

##Database
db  = mongoose.connect require './database' #This file will not be on Github
EventSchema = mongoose.Schema
    title: String
    description: String
    eventTime: Date
    geoLocation: [Number]
    range: Number
    humanLocation: String

EventModel = db.model 'events', EventSchema


sender = new gcm.Sender require './gcmKey' #This file will not be on Github
GCMIDs = [];


populateEvents = (req, res, next) ->
    EventModel.find {}, (err, evs) ->
        res.locals.events = for ev, i in evs
            {
                index:          i
                title:          ev.title
                description:    ev.description
                eventTime:      dateFormat(ev.eventTime, 'hh:mm, d mmm yyyy')
                geoLocation:    ev.geoLocation
                humanLocation:  ev.humanLocation
            }

        res.locals.json = JSON.stringify res.locals.events

        next()


app.get '/events/list', populateEvents, (req, res) ->
    res.render 'index'

app.get '/events/new', populateEvents, (req, res) ->
    res.locals.method = 'put'
    res.render 'form'

app.put '/events/save', (req, res) ->
    (new EventModel(req.body)).save (err) ->
        message = new gcm.Message()

        message.addData('range', req.body.range)
        message.addData('geoLocation', req.body.geoLocation)

        sender.send message, GCMIDs, 4, (result) ->
            res.redirect '/events/new'

app.get '/gcm/register/:regid', (req, res) ->
    GCMIDs.push req.params.regid
    res.send 200, ''


app.get '/gcm/debug', (req, res) ->
    res.send GCMIDs

app.get '/events/send', (req, res) ->
    message = new gcm.Message()

    message.addData('range', 30)
    message.addData('geoLocation', [30, 20])

    message.delayWhileIdle = true;

    sender.send message, GCMIDs, 4, (result) ->
        console.log result
        res.end()






app.listen 8080
