@FAQ = new Meteor.Collection("FAQ")

FAQ.allow({
  insert:->
    if this.userId
      return true
    return false
  update:->
    if this.userId
      return true
    return false
})