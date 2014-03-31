#= require jquery
#= require bootstrap

jQuery ($) ->
  # $('#container').on 'click', '[rel=push-gimmick]', (e) ->
  $('[rel=push-gimmick]').on 'click', (e) ->
    e.preventDefault()
    newGimmick e
    off

  newGimmick = (event) ->
    $(event.currentTarget).before '<input type="text" name="gimmick" placeholder="new gimmick" autofocus />'
