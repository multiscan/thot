# http://stackoverflow.com/questions/5007785/how-do-i-write-a-cleaner-date-picker-input-for-simpleform/5079761#5079761
class DatePickerInput < SimpleForm::Inputs::StringInput
  def input
    value = input_html_options[:value]
    value ||= object.send(attribute_name) if object.respond_to? attribute_name
    input_html_options[:value] ||= I18n.localize(value) if value.present?
    input_html_classes << "datepicker"

    super # leave StringInput do the real rendering
  end
end
