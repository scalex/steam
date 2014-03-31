#= require jquery
#= require bootstrap
#= require dropzone

# Dropzone.options.myAwesomeDropzone = {
#   init: function() {
#     this.on("addedfile", function(file) { alert("Added file."); });
#   }
# };
Dropzone.autoDiscover = false

jQuery ($) ->
  $('[rel=push-gimmick]').on 'click', (e) ->
    e.preventDefault()
    newGimmick e
    off

  newGimmick = (event) ->
    $(event.currentTarget).before '<input class="gimmick-input" type="text" name="gimmick" placeholder="new gimmick" autofocus />'

  fotoUploaded = (file, response) ->
    console.debug file, response, file.previewElement

  $('.dropzone').each ->
    new Dropzone(@, {
      uploadMultiple: false
      success: fotoUploaded
    })
