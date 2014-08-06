include ApplicationHelper

def full_banner_css(status)
  "div.alert.alert-" + status
end

def enter_form(formHash = {})
  formHash.each do |key, value|
    fill_in key, with: value
  end
end
