module I18n
  def self.default_exception_handler(exception, locale, key, options)
    return key
  end
end
