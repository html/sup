class EventsController < ApplicationController
  before_filter :assign_places, :only => [:new, :create, :search, :edit, :update]
  before_filter :assign_subjects, :only => [:new, :create, :search, :edit, :update]
  before_filter :require_login, :only => [:new, :create, :my, :edit]

  def new
    @item = Event.new
  end

  def create
    @item = Event.new(params[:event].merge(:owner_id => @current_user.id))
    
    assign_some_stuff

    if @item.save
      flash[:notice] = "Событие успешно добавлено"
      redirect_to url_for(@item)
    else
      render :new
    end
  end

  def update
    @item = Event.find(params[:id])

    return forbidden unless @item.owner_id == @current_user.id
    assign_some_stuff

    data = params[:event]
    data.delete :start_time
    data.delete :end_time

    [:start_time, :end_time].each do |t|
      data.delete "#{t}(1i)"
      data.delete "#{t}(2i)"
      data.delete "#{t}(3i)"
      data.delete "#{t}(4i)"
      data.delete "#{t}(5i)"
    end

    unless params[:set_event_end]
      @item.end_time = nil
    end

    if @item.update_attributes(data)
      debugger;true
      flash[:notice] = "Событие успешно отредактировано"
      redirect_to :back
    else
      @edit = true
      render :action => :new
    end
  end

  def edit
    @item = Event.find(params[:id])

    @edit = true

    return forbidden unless @item.owner_id == @current_user.id
    assign_some_stuff

    render :action => :new
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
    if params[:commit]
      @is_search = true
      new_params = params.merge(params[:event] || {}).merge(params[:events] || {})
      @event_free = new_params[:event_free].to_i
      @root_subject_id = new_params[:root_subject].to_i
      @subject_id = new_params[:subject_id].to_i
      @event_type_id = new_params[:event_type_id].to_i
      @root_place_id = new_params[:root_place].to_i
      @place_id = new_params[:place_id].to_i

      begin
        @start_time = parse_date(new_params[:start_time])
      rescue 
      end

      begin
        @end_time = parse_date(new_params[:end_time])
      rescue 
      end

      @items = Event.search(
        new_params[:page], 
        @root_subject_id, 
        @subject_id,
        @event_type_id,
        @root_place_id,
        @place_id,
        @event_free.to_i,
        @start_time,
        @end_time
      )
    end
  end

  def my
    @items = @current_user.events.paginate(:page => 1, :per_page => 5)
    render :index
  end

  def subjects2
    render '/subjects', :layout => true
  end

  def destroy
    @item = Event.find(params[:id])
    @item.destroy
    flash[:notice] = "Событие успешно удалено"
    redirect_to :back
  end
  protected
    def date_till
      Event.last_event_date || Date.today
    end


    def assign_some_stuff
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
    end
end
