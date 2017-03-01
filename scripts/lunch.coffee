# Description:
#   Avoid fights! Here's a lunch picker, you indecisive fools.
#
# Commands:
#   hubot lunch - picks a lunch option
#   hubot lunch add <option> - adds an option to the list
#   hubot lunch options - shows available options
#   hubot lunch del <option> - removes option
#
# Examples:
#   hubot lunch add chipotle

module.exports = (robot) ->

  # GET.
  robot.respond /lunch$/i, (msg) ->
    opts = robot.brain.get('lunches')
    if not opts
      msg.send 'No lunches specified. You shall have Chipotle.'
    else
      msg.send 'You shall eat ' + msg.random(opts) + '!'

  # CREATE.
  robot.respond /lunch add (.*)$/i, (msg) ->
    opts = robot.brain.get('lunches')
    newOpt = msg.match[1].trim().toLowerCase()
    if not opts
      opts = [newOpt]
    else
      opts.push(newOpt)
    robot.brain.set('lunches', opts)
    msg.send 'Very well. You shall have ' + newOpt + '. Maybe.'

  # GET.
  robot.respond /lunch (opts|options)$/i, (msg) ->
    if robot.brain.get('lunches')
      opts = robot.brain.get('lunches')
      msg.send 'Your available lunches: ' + opts.join(', ')
    else
      msg.send 'You need to add some lunch options or else... Chipotle.'

  # DESTROY.
  robot.respond /lunch (del|delete) (.*)$/i, (msg) ->
    opts = robot.brain.get('lunches')
    if not opts
      msg.send 'No lunches specified.'
    else
      opt = msg.match[2].trim().toLowerCase()
      found = opts.indexOf(opt)
      if found > -1
        opts.splice(found, 1)
        robot.brain.set('lunches', opts)
        msg.send 'You shall never eat at ' + opt + ' again.'
      else
        msg.send opt + ' was not found.'
