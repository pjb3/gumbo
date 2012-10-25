$ =>
  $('#add-todo').submit (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('#todos').append(JST["templates/todo"](name: $('#todo').val()))
    false

