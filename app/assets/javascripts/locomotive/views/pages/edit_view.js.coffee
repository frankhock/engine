Locomotive.Views.Pages ||= {}

class Locomotive.Views.Pages.EditView extends Locomotive.Views.Pages.FormView

  save: (event) ->
    event.stopPropagation() & event.preventDefault()

    form = $(event.target).trigger('ajax:beforeSend')

    @clear_errors()

    @model.save {},
      success: (model, response) =>
        form.trigger('ajax:complete')

        model._normalize()

        if model.get('template_changed') == true
          @reset_editable_elements()
        else
          @refresh_editable_elements()

        # refresh the show link
        fullpath = @model.get('localized_fullpaths')[window.content_locale]
        @$('#local-actions-bar > a.show').attr('href', "/#{fullpath}")

      error: (model, xhr) =>
        form.trigger('ajax:complete')

        errors = JSON.parse(xhr.responseText)

        @show_errors errors
