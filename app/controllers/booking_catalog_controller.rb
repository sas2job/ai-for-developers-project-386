class BookingCatalogController < ApplicationController
  def index
    @event_types = EventType.order(:id)
  end
end
