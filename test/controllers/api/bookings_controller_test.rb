require "test_helper"

class Api::BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event_type = EventType.create!(name: "Consultation", description: "Talk", duration_minutes: 30)
  end

  test "creates a booking and computes its end from the event type" do
    starts_at = available_start

    post api_bookings_path,
      params: {
        eventTypeId: @event_type.id.to_s,
        startsAt: starts_at,
        guestName: "Guest",
        guestEmail: "guest@example.com"
      },
      as: :json

    assert_response :created
    assert_equal (Time.iso8601(starts_at) + 30.minutes).utc.iso8601, response.parsed_body.fetch("endsAt")
    assert_equal "guest@example.com", response.parsed_body.fetch("guestEmail")
  end

  test "returns 404 when the event type does not exist" do
    post api_bookings_path,
      params: {
        eventTypeId: "999999",
        startsAt: "2030-01-07T09:00:00Z",
        guestName: "Guest",
        guestEmail: "guest@example.com"
      },
      as: :json

    assert_response :not_found
    assert_equal "not_found", response.parsed_body.dig("error", "code")
  end

  test "returns 409 when the requested interval overlaps an existing booking" do
    starts_at = Time.iso8601(available_start)
    @event_type.bookings.create!(
      starts_at: starts_at,
      ends_at: starts_at + 30.minutes,
      guest_name: "First guest",
      guest_email: "first@example.com",
    )

    post api_bookings_path,
      params: {
        eventTypeId: @event_type.id.to_s,
        startsAt: starts_at.utc.iso8601,
        guestName: "Second guest",
        guestEmail: "second@example.com"
      },
      as: :json

    assert_response :conflict
    assert_equal "slot_unavailable", response.parsed_body.dig("error", "code")
    assert_equal 1, Booking.count
  end

  test "rejects timestamps without the UTC Z suffix" do
    post api_bookings_path,
      params: {
        eventTypeId: @event_type.id.to_s,
        startsAt: "2030-01-07T09:00:00+00:00",
        guestName: "Guest",
        guestEmail: "guest@example.com"
      },
      as: :json

    assert_response :unprocessable_entity
    assert_equal "validation_error", response.parsed_body.dig("error", "code")
  end

  test "rejects starts outside the booking window" do
    post api_bookings_path,
      params: {
        eventTypeId: @event_type.id.to_s,
        startsAt: "2030-01-07T06:00:00Z",
        guestName: "Guest",
        guestEmail: "guest@example.com"
      },
      as: :json

    assert_response :unprocessable_entity
    assert_equal "validation_error", response.parsed_body.dig("error", "code")
  end

  private

  def available_start
    timezone = ActiveSupport::TimeZone[Availability::Slots::TIME_ZONE]
    now = Time.current.in_time_zone(Availability::Slots::TIME_ZONE)
    date = Availability::Slots.window_dates.find do |candidate|
      next false if candidate.saturday? || candidate.sunday?

      timezone.local(candidate.year, candidate.month, candidate.day, 9) > now
    end

    timezone.local(date.year, date.month, date.day, 9).utc.iso8601
  end
end
