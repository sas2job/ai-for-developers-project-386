require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "shows the event type form and an empty state" do
    get admin_path

    assert_response :success
    assert_select "h1", "Управление календарём"
    assert_select "form[action='#{admin_event_types_path}']"
    assert_select "p", text: "Вы ещё не создали ни одного типа встречи."
  end

  test "creates an event type from the owner page" do
    assert_difference("EventType.count", 1) do
      post admin_event_types_path, params: {
        event_type: { name: "Консультация", description: "Обсудить вопрос", duration_minutes: 30 }
      }
    end

    assert_redirected_to admin_path
    follow_redirect!
    assert_select "li", text: /Консультация/
  end

  test "shows validation errors beside invalid fields" do
    post admin_event_types_path, params: {
      event_type: { name: "", description: "", duration_minutes: 0 }
    }

    assert_response :unprocessable_entity
    assert_select ".field-error", minimum: 3
  end
end
