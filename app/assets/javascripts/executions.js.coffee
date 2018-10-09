# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


update_executions = ->
  setTimeout ->
    $.get window.location.pathname + "/executions_list", (data) ->
      $('#executions_list').html(data)

    update_executions()
  ,60000

update_executions()

$(document).ready ->
  $('#language').on 'change', ->
    lang = @options[@selectedIndex].value
    location.href = "?locale=" + lang

  $('#select_all').on 'change', (e) ->
    $('#uploaded_files tbody input[type="checkbox"]').prop("checked", $(@).prop("checked"))

  if ("#contando_modal").length > 0
    $('#contando_modal').modal({})

  $("#use_example_btn").on 'click', (e) ->
    lang = $('#execution_input_parameters_inputs_web_pages').data('lang')
    $('#execution_input_parameters_inputs_web_pages').val("http://contawords-iulaterm.s.upf.edu:3110/docs/" + lang + "/doc1.txt\n" + "http://contawords-iulaterm.s.upf.edu:3110/docs/" + lang + "/doc2.txt")
    $('#execution_input_parameters_inputs_language').val(lang)
    return false

  $('#input_select_buttons button').on 'click', (e) ->
    type = $(e.target).attr("href").replace("#", "")
    $('#execution_type').val(type)

  $('#show_external_files').on 'click', (e) ->
    $('#basic_button').click()

  $($.cookie('tab')).click()

