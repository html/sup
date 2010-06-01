module UsersHelper
  def text_field_for(form, name, args = {})
    content_tag 'span', form.text_field(name, args.merge(:class => :text_6, :size => nil)), :class => 'zagolov'
  end
end
