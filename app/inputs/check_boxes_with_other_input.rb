# Assumes serialized attribute (can use ActiveRecord Store with Rails 3.2+)
# Splits attribute into hash with key for checkboxes (default 'checks')
# Use with TextFieldsWithOther to add 'other' key for text values ...
#
# symptoms[checks] <-- Array
# symptoms[other] <-- String
#
# For a nested hash, define a top-level method (or with ActiveRecord::Store, define an accessor)
# In model ...
# class Patient < ActiveRecord::Base
# store :symptoms, accessors: [ 'attention', ... ]
# end
#
# Gives you access to ...
# <%= f.input 'attention', :as => :check_boxes_with_other, :collection => my_predefined_values %>
# attention[checks]
# <%= f.input 'attention', :as => :string_as_other %>
# attention[other]
# <%= f.input 'attention', :attr => 'age_of_onset', :as => :string_as_other %>
# attention[age_of_onset]

class CheckBoxesWithOtherInput < FormtasticBootstrap::Inputs::CheckBoxesInput
  def to_html
    form_group_wrapping do
      checkbox_html = label_html + hidden_field_for_all
      checkbox_html << collection.push("Other:"). map { |choice| choice_html(choice)}.join("\n").html_safe
      other_value = ((object.send(method).presence || []) - collection).delete_if(&:empty?).join()
      other_html = template.content_tag(:div, :class => 'checkbox-other') do
        builder.text_field(method, form_control_input_html_options.merge(:multiple => :true, :value => other_value))
      end
      checkbox_html << other_html
    end
  end
end
