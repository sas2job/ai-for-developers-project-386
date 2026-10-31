require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "home page links to booking and calendar management" do
    get root_path

    assert_response :success
    assert_select "h1", "Запись на звонок"
    assert_select "a[href='/book']", text: "Записаться", count: 2
    assert_select "a[href='/admin']", text: "Управление календарём"
    assert_select "h2", "Возможности"
  end

  test "booking catalog shows an empty state when no event types exist" do
    get book_path

    assert_response :success
    assert_select "h1", "Каталог типов встреч"
    assert_select "h2", "Пока нет типов встреч"
    assert_select "a[href='/']", text: "На главную"
  end

  test "health endpoint responds successfully" do
    get "/api/health"

    assert_response :success
    assert_equal({ "status" => "ok" }, response.parsed_body)
  end
end
