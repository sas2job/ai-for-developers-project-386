require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "home page offers booking links" do
    get root_path

    assert_response :success
    assert_select "h1", "Запись на звонок"
    assert_select "a[href='/book']", text: "Записаться", count: 2
    assert_select "h2", "Возможности"
    assert_select "a", text: "Админка", count: 0
  end

  test "booking catalog placeholder explains that booking is unavailable" do
    get "/book"

    assert_response :success
    assert_select "h1", "Каталог типов встреч"
    assert_select "p", text: /Запись пока недоступна/
    assert_select "a[href='/']", text: "На главную"
  end

  test "health endpoint responds successfully" do
    get "/api/health"

    assert_response :success
    assert_equal({ "status" => "ok" }, response.parsed_body)
  end
end
