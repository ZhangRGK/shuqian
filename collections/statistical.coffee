@Statistical = new Meteor.Collection('statistical')
BookMarks.allow({
  insert: (userId, data)->
    return true;
  update: (userId, data)->
    return true;
})