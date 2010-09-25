class PartialRendererGenerator < Rails::Generator::NamedBase

  def initialize(runtime_args, runtime_options = {})
    super

    if runtime_args[0] == 'go'
      options[:file_name] = 'pagination'
    else
      options[:file_name] = runtime_args[0]
    end

    if options[:format].nil?
      options[:format] = 'haml'
    end

  end

  def manifest

    record do |m|
      m.file "pagination.#{options[:format]}", "app/views/_#{options[:file_name]}.#{options[:format]}"
    end
  end

  def add_options!(opt)
    opt.separator ''
    opt.separator 'Options:'
    opt.on("--haml", "Generate haml template") { |v| options[:format] = "haml"; }
    opt.on("--erb", "Generate erb template") { |v| options[:format] = "erb"; }
    
  end
end
