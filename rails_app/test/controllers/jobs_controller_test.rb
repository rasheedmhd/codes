require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get jobs_create_url
    assert_response :success
  end

  test "should get index" do
    get jobs_index_url
    assert_response :success
  end

  test "should get new" do
    get jobs_new_url
    assert_response :success
  end

  test "should get edit" do
    get jobs_edit_url
    assert_response :success
  end
end
