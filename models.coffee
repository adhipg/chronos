Events = new Meteor.Collection("events")

Events.allow
  insert: (userId, event) =>
    false

  remove: (userId, event) =>

Meteor.methods
  createEvent: (options) ->
    Events.insert
      owner: @userId
      title: options.title

  invitePeople: (eventId, invitees) ->
    Events.update(eventId, {$set: { 'invitees': invitees }})

    if Meteor.isServer
      return # FIXME Disable emails for now.
      event = Events.findOne(eventId)
      user = Meteor.users.findOne(@userId)
      from = user.emails?[0].address
      _.each invitees, (invitee) =>
        Email.send
          from: 'robot@chronos.meteor.com'
          to: invitee
          subject: '[Chronos] Invitation!'
          text: "You've been invited to '#{event.title}' by '#{from}'"
