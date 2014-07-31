module Formtastic
  module Helpers
    module InputHelper

      def question_input(attribute, question, options = {})
        options.reverse_merge!(
          :as => question.field_type,
          :label => question.name,
          :collection => question.options,
          :input_html => { :rows => 4 },
          :include_blank => false
        )
        input(attribute, options)
      end

    end
  end
end
