if Meteor.isClient
  Session.set "showCreateEvent", false

  Template.chronos.events =
    'click .create-event': =>
      Session.set("showCreateEvent", true)

  Template.chronos.userLoggedIn = ->
    !! Meteor.userId()

  Template.chronos.showCreateEvent = =>
    Session.get("showCreateEvent")

  Template.chronos.showInvitePeople = =>
    Session.get("showInvitePeople")

  Template.chronos.invitesSent = =>
    Session.get('invitesSent')

  Template.modalCreateEvent.events =
    'click .create-event': (event, template) =>
      title = template.find('.event-name').value
      minPeople = template.find('.event-minimum-people').value
      maxPeople = template.find('.event-maximum-people').value
      date = template.find('.event-date').value

      if title
        Meteor.call "createEvent", {
          title: title
          minPeople: minPeople
          maxPeople: maxPeople
          date: date
        }, (error, eventId) =>
          Session.set('showCreateEvent', false)
          Session.set('showInvitePeople', true)
          Session.set('currentParty', eventId)


  Template.modalInvitePeople.currentEventTitle = =>
    eventId = Session.get('currentParty')
    event = Events.findOne(eventId)
    event.title

  Template.modalInvitePeople.events =
    'click .send-invites': (event, template) =>
      invitees = _.compact(template.find('.invitees').value.split("\n"))
      eventId = Session.get("currentParty")
      Meteor.call("invitePeople", eventId, invitees)

      Session.set('showInvitePeople', false)
      Session.set('invitesSent', true)

if Meteor.isServer
  Meteor.startup = =>
