# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $("#txt-micropost-content").bind 'keyup', ->
    textElement = $(this)
    microValue = textElement.val()
    currentCount = microValue.length
    remainingCount = 140 - currentCount
    $('.word-countdown').html(remainingCount)
