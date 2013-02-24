Events = new Meteor.Collection("events")

Events.allow
  insert: (userId, event) =>
    false

  remove: (userId, event) =>

Meteor.methods
  createEvent: (options) =>
    Events.insert
      owner: @userId
      title: options.title

  invitePeople: (eventId, invitees) =>
    Events.update(eventId, {$set: { 'invitees': invitees }})
    # Send email from here.
