require "test_helper"

class RaritiesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rarities_index_url
    assert_response :success
  end

  test "should get show" do
    get rarities_show_url
    assert_response :success
  end

  test "should get new" do
    get rarities_new_url
    assert_response :success
  end

  test "should get edit" do
    get rarities_edit_url
    assert_response :success
  end

  test "should get create" do
    get rarities_create_url
    assert_response :success
  end

  test "should get update" do
    get rarities_update_url
    assert_response :success
  end

  test "should get destroy" do
    get rarities_destroy_url
    assert_response :success
  end
end
