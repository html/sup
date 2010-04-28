class EventsController < ApplicationController
  def new
    @item = Event.new
    @places = Place.roots
  end

  def create
    @item = Event.new(params[:event])
    @places = Place.roots

    #XXX
    begin
      [:start_time, :end_time].each do |t|
        @item.send("#{t}=", Date.parse(params[:event][t]).to_datetime + params[:event]["#{t}(4i)"].to_i.hours + params[:event]["#{t}(5i)"].to_i.minutes)
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
    @items = Event.paginate :per_page => 5, :page => params[:page], :order => 'start_time DESC, id DESC'

    last_date = date_till

    @date_from = last_date - 7.days
    @date_till = last_date
  end

  def cities
    @event = Place.find params[:events][:root_place]

    render :text => (@event.children.collect { |p| ({ :id => p.id, :label => p.title })}).to_json
  rescue
    render :text => [].to_json
  end

  protected
    def date_till
      Event.last_event_date || Date.today
    end
end
