require "application_system_test_case"

class GuestBookingTest < ApplicationSystemTestCase
  setup do
    Booking.delete_all
    EventType.delete_all
    @event_type = EventType.create!(name: "Консультация", description: "Обсудить вопрос", duration_minutes: 30)
    @date = available_date
    visit book_path(event_type_id: @event_type.id, date: @date.iso8601)
  end

  teardown do
    Booking.delete_all
    EventType.delete_all
  end

  test "guest can create a booking and see a confirmation without email or call link delivery" do
    choose_first_slot
    fill_in "Имя", with: "Анна"
    fill_in "Email", with: "anna@example.com"
    click_button "Подтвердить запись"

    assert_text "Запись подтверждена"
    assert_text "Консультация"
    assert_text "Письмо-приглашение и ссылка на звонок не отправляются."
    assert_equal 1, Booking.count
  end

  test "guest keeps contacts and selects another time after a slot conflict" do
    choose_first_slot
    starts_at = page.first("button[data-booking-target='slot']")["data-starts-at"]
    fill_in "Имя", with: "Анна"
    fill_in "Email", with: "anna@example.com"

    competing_start = Time.iso8601(starts_at)
    @event_type.bookings.create!(
      starts_at: competing_start,
      ends_at: competing_start + @event_type.duration_minutes.minutes,
      guest_name: "Другой гость",
      guest_email: "other@example.com"
    )

    click_button "Подтвердить запись"

    assert_text "Это время только что заняли. Выберите другой свободный слот."
    assert_equal "Анна", page.find_field("Имя").value
    assert_equal "anna@example.com", page.find_field("Email").value
    assert_no_selector "button[data-starts-at='#{starts_at}']"

    choose_first_slot
    click_button "Подтвердить запись"

    assert_text "Запись подтверждена"
    assert_equal 2, Booking.count
  end

  test "guest sees validation errors beside contact fields" do
    choose_first_slot
    page.execute_script("document.querySelector('#guest-name').removeAttribute('required'); document.querySelector('#guest-email').type = 'text';")
    fill_in "Имя", with: ""
    fill_in "Email", with: "invalid-email"
    click_button "Подтвердить запись"

    assert_selector "#guest-name + .field-error:not([hidden])"
    assert_selector "#guest-email + .field-error:not([hidden])"
    assert_equal 0, Booking.count
  end

  private

  def available_date
    Availability::Slots.window_dates.find do |date|
      next false if date.saturday? || date.sunday?

      ActiveSupport::TimeZone[Availability::Slots::TIME_ZONE]
        .local(date.year, date.month, date.day, 9) > Time.current.in_time_zone(Availability::Slots::TIME_ZONE)
    end
  end

  def choose_first_slot
    page.first("button[data-booking-target='slot']").click
  end
end
