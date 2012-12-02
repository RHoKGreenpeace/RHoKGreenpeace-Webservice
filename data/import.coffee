mongoose    = require 'mongoose'
db  = mongoose.connect 'mongodb://nodejitsu_rhokaarhus:nb3ffupfnb7b4a7js0nl6c5cao@ds043937.mongolab.com:43937/nodejitsu_rhokaarhus_nodejitsudb7367330363'

EventSchema = mongoose.Schema
    title: String
    description: String
    eventTime: Date
    geoLocation: [Number]
    range: Number
    humanLocation: String

EventModel = db.model 'events', EventSchema


EventModel.find({}).remove()

new EventModel
    "title": "New title #1",
    "description": "Description of event 1: Event at den gamle by",
    "eventTime": new Date(2011, 11, 2, 15, 0, 0),
    "geoLocation": [56.159004, 10.191806],
    "humanLocation": "Den gamle by"
    "range": 30
.save((err) -> console.log err)

new EventModel
    "title": "New titlen #2",
    "description": "Description of event 2: Event at strøget Aarhus",
    "eventTime": new Date(2011, 1, 1, 23),
    "geoLocation": [56.151435, 10.204915],
    "humanLocation": "Strøget Aarhus",
    "range": 20
.save((err) -> console.log err)

new EventModel
    "title": "New title #3",
    "description": "Description of event 3: Event at Aarhus lystbådhavn",
    "eventTime": new Date(2011, 2, 2, 23),
    "geoLocation": [56.163315, 10.217735],
    "humanLocation": "Aarhus Lystbådhavn"
    "range": 10
.save((err) -> console.log err)

new EventModel
    "title": "New title #4",
    "description": "Description of event 4: Event at Jyllands Posten",
    "eventTime": new Date(2011, 3, 3, 23),
    "geoLocation": [56.122862,  10.146504],
    "humanLocation": "Jyllands Posten",
    "range": 5
.save((err) -> console.log err)

EventModel.find {}, (err, events) ->
    console.log "here"
    console.log err, events
