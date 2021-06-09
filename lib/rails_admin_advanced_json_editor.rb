require "rails_admin_advanced_json_editor/engine"

module RailsAdminAdvancedJsonEditor
end

require 'rails_admin/config/fields'
require 'rails_admin/config/fields/base'

module RailsAdmin
  module Config
    module Fields
      module Types
        class AdvancedJsonEditor < RailsAdmin::Config::Fields::Base
          RailsAdmin::Config::Fields::Types::register(self)


          register_instance_option :formatted_value do
            value ? JSON.pretty_generate(value) : nil
          end

          register_instance_option :pretty_value do
            bindings[:view].content_tag(:pre) { formatted_value }.html_safe
          end

          register_instance_option :export_value do
            formatted_value
          end

          def json
            puts bindings[:object][name]
            puts bindings[:object][name].to_json

            puts bindings[:object][name].as_json
            bindings[:object][name].to_json
          end

          def parse_value(value)
            value.present? ? JSON.parse(value) : nil
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name].is_a?(::String)
          end

          def sanitized_object_name(object_name)
            object_name.gsub(/]\[|[^-a-zA-Z0-9:.]/,"_").sub(/_$/,"")
          end

          def form_tag_id(object_name, field)
            "#{sanitized_object_name(object_name.to_s)}_#{field.to_s}"
          end

          def dom_name
            @dom_name ||= "#{form_tag_id(bindings[:form].object_name, @name)}_#{name}"
          end
      
          def json_dom_name
            form_tag_id(bindings[:form].object_name, name)
          end
          
          register_instance_option :render do
            bindings[:view].render partial: "rails_admin/main/form_advanced_json_editor", locals: {field: self, form: bindings[:form]}
          end
        end
      end
    end
  end
end