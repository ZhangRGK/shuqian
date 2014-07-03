@Statistical = new Meteor.Collection('statistical')
Statistical.allow({
  insert: (userId, data)->
    return true;
  update: (userId, data)->
    return true;
})