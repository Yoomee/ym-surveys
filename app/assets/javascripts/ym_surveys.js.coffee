$(document).ready ->
  setPageNumberOfFirstQuestionGroup()
  initQuestionLogic()
  $("ul.js-sortable-question-options").sortable()
  $(".js-question-group ul").sortable()

  $(".js-editor-container").on "click", '.js-remove-option', ->
    $(this).parents(".js-question-option").remove()

  $(".js-editor-container").on "change", '.js-logic-question', ->
    logicQuestionChanged(this)

  $(".js-editor-container").on 'cocoon:after-insert', (e, insertedItem) ->
    if insertedItem.hasClass('js-question-group')
      addPageNumberAndPositionToQuestionGroup(insertedItem)
    else if insertedItem.hasClass('js-question-fields')
      addPositionToQuestion(insertedItem)

  $(".js-editor-container").on 'cocoon:after-insert', '.js-question-group', ->
    initQuestionLogic()

  $(".js-editor-container").on 'cocoon:after-insert', ->
    initQuestionLogic()

  $(".js-editor-container").on "blur", ".js-question-fields", ->
    initQuestionLogic()

  $(".js-editor-container").on "change", '.js-logic-answer', ->
    group = $(this).parents(".js-question-group")
    updateDependenceLogic(group)

  $(".js-editor-container").on "change", '.js-field-type', ->
    showOptions = $(":selected", this).data('options') == true
    optionsDiv = $(this).parents(".form-group").siblings(".options")
    optionsDiv.toggle(showOptions)
    if optionsDiv.find("li").length == 0
      optionsDiv.find(".js-add-other").click()

  $(".js-editor-container").on "click", '.js-add-other', ->
    $this = $(this)
    newOption = newOptionHTML.call($this)
    $this.closest(".row").before(newOption)
    $("input", newOption).val("Option #{$('li', $this.parents("ul.question-options")).length}").select()
    options = getQuestionOptions($this.parents(".js-question-fields"))
    $this.closest(".js-question-fields").trigger("optionRowAdded", [options]);

setPageNumberOfFirstQuestionGroup = () ->
  $('.js-question-group').first().find('h3.js-page-number').html("Page 1")

addPageNumberAndPositionToQuestionGroup = (questionGroup) ->
  numberOfPages = $('.js-question-group').length
  questionGroup.find('h3.js-page-number').append(" " + numberOfPages)
  questionGroup.find('input.js-question-group-position').val(numberOfPages)

addPositionToQuestion = (question) ->
  numberOfQuestions = question.parents('.js-question-group').find('.js-question-fields').length
  question.find('input.js-question-position').val(numberOfQuestions)

newOptionHTML = () ->
  coccoonIds = getCocoonIds(this.parents(".inputs").first().find("[id^='survey_question_groups_attributes']").first().attr("id"))
  $("<li>")
    .append $("<div>").addClass("row js-question-option")
      .append $("<div>").addClass("col-lg-6")
        .append $("<div>").addClass("input-group")
          .append(reorderBarsHTML())
          .append(textInputHTML(coccoonIds[1], coccoonIds[2]))
          .append(removeButtonHTML())

reorderBarsHTML = ->
  $("<span>").addClass("input-group-addon")
    .append $("<i>").addClass("fa fa-bars reorder-bars")

textInputHTML = (questionGroupId, questionId) ->
  $("<input>").addClass("form-control js-option-input")
              .attr("name", "survey[question_groups_attributes][#{questionGroupId}][questions_attributes][#{questionId}][options][]")
              .attr("size", "30")
              .attr("type", "text")

removeButtonHTML = ->
  $("<span>").addClass("input-group-btn pl-1")
    .append $("<button>").addClass("close js-remove-option")
      .append $("<span>").attr("aria-hidden", "true").text('×')
      .append $("<span>").addClass("sr-only").text("Close")

getCocoonIds = (str, id) ->
  str.match(/survey_question_groups_attributes_(\d*)_questions_attributes_(\d*)\w*/)

initQuestionLogic = ->
  $(".js-question-group:not(:first)").each ->
    $this = $(this)
    questions = $this.prevAll(".js-question-group").find(".js-question-fields").map ->
      isOptions = $(".js-field-type option:selected", $(this)).data("options")
      $("[name$='[name]']", $(this)).val() if isOptions
    questionField = $(".js-logic-question", $this)
    groupValue = $(".js-dependence-logic", $this).val().split('#')
    replaceSelectOptionsWithArray(questionField, questions, groupValue[0])
    logicQuestionChanged(questionField, groupValue[1])


replaceSelectOptionsWithArray = (select, array, selected) ->
  output = []
  output.push("<option value=''></option>");
  array.each (key, value) ->
    output.push("<option value='#{value}' #{if selected == value then 'selected=true' else ''}>#{value}</option>");
  select.html(output.join(''))

findQuestionWithName = (name) ->
  $(".js-question-name")
    .filter ->
      this.value == name
    .parents(".js-question-fields")

getQuestionOptions = (question) ->
  $(".js-option-input", question).map ->
    $(this).val()

updateDependenceLogic = (group) ->
  question = $(".js-logic-question", group).val()
  answer = $(".js-logic-answer", group).val()
  if ((question.length > 0) && (answer.length > 0))
    $(".js-dependence-logic", group).val("#{question}##{answer}")


logicQuestionChanged = (select, answer) ->
  question = findQuestionWithName($(":selected", select).text())
  options = getQuestionOptions(question)
  group = $(select).parents(".js-question-group")
  replaceSelectOptionsWithArray(group.find(".js-logic-answer"), options, answer)
  updateDependenceLogic(group)
