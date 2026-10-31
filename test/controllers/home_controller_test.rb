require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "home page responds successfully" do
    get root_path

    assert_response :success
    assert_select "h1", "Запись на звонок"

    get "/api/health"
    assert_response :success
    assert_equal({ "status" => "ok" }, response.parsed_body)
  end
end
