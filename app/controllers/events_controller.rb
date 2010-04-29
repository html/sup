class EventsController < ApplicationController
  def new
    @item = Event.new
    @places = Place.roots
    @subjects = Subject.roots
  end

  def create
    @item = Event.new(params[:event])
    @places = Place.roots
    @subjects = Subject.roots
    
    if @item.place && @item.place.parent
      @root_place_id = @item.place.parent.id
      @place_id = @item.place.id
      @child_places = @item.place.parent.children.collect { |p| [p.title, p.id] }
    end

    if @item.subject && @item.subject.parent
      @root_subject_id = @item.subject.parent.id
      @subject_id = @item.subject.id
      @child_subjects = @item.subject.parent.children.collect { |p| [p.title, p.id] }
    end

    #XXX
    begin
      [:start_time, :end_time].each do |t|
        if params[:event][t] && !params[:event][t].empty?
          @item.send("#{t}=", parse_date(params[:event][t]).to_datetime + params[:event]["#{t}(4i)"].to_i.hours + params[:event]["#{t}(5i)"].to_i.minutes)
        else
          @item.send("#{t}=", nil)
        end
      end
    rescue
    end

    if @item.save
      flash[:notice] = "Событие успешно добавлено"
      redirect_to url_for(@item)
    else
      render :new
    end
  end

  def show
    @item = Event.find(params[:id])
  end

  def index
    if params[:from] && params[:to]
      @items = Event.all_in_range(
        @date_from = parse_date(params[:from].to_s).to_datetime, 
        @date_till = parse_date(params[:to].to_s).to_datetime, params[:page]
      )
    else
      @items = Event.paginate :per_page => 5, :page => params[:page], :order => 'start_time DESC, id DESC'
      last_date = date_till

      @date_from = last_date - 7.days
      @date_till = last_date
    end
  end

  def cities
    default_object = params[:empty_text] ? [{ :label => 'Любой город', :id => 0 }] : []
    @event = Place.find params[:events][:root_place]

    render :text => (default_object + @event.children.collect { |p| ({ :id => p.id, :label => p.title })}).to_json
  rescue
    render :text => default_object.to_json
  end

  def subjects
    default_object = params[:empty_text] ? [{ :label => 'Любая специализация', :id => 0 }] : []
    @event = Subject.find params[:events][:root_subject]

    render :text => (default_object + @event.children.collect { |p| ({ :id => p.id, :label => p.title })}).to_json
  rescue
    render :text => default_object.to_json
  end

  def search
    @places = Place.roots
    @subjects = Subject.roots
  end

  protected
    def date_till
      Event.last_event_date || Date.today
    end
    
    def parse_date(date)
      Date.parse(date)
    rescue
      Date.strptime(date, '%d.%m.%Y')
    end
end
