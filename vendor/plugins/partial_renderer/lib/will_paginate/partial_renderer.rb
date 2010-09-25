module WillPaginate
  class PartialRenderer < WillPaginate::LinkRenderer
    def prepare(collection, options, template)
      @collection = collection
      @options    = options
      @template   = template

      if !@template.respond_to?(:url_for_page)
        m = method(:url_for)
        @template.instance_eval do |cl|
          @url_for_page = m
          def url_for_page(page)
            @url_for_page.call page
          end
        end
      end
    end

    def to_html
      locals = {
        :first_page => 1,
        :last_page => @collection.total_pages,
        :previous_page => @collection.previous_page,
        :next_page => @collection.next_page,
        :total_pages => @collection.total_pages,
        :current_page => @collection.current_page,
        :per_page => @collection.per_page,
        :options => @options
      }

      @template.render :partial => @options[:partial], :locals => locals
    end
  end
end

WillPaginate::ViewHelpers::pagination_options[:renderer] = 'WillPaginate::PartialRenderer'
WillPaginate::ViewHelpers::pagination_options[:partial] = '/pagination'
