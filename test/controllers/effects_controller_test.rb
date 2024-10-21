require "test_helper"

class EffectsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get effects_index_url
    assert_response :success
  end

  test "should get show" do
    get effects_show_url
    assert_response :success
  end

  test "should get new" do
    get effects_new_url
    assert_response :success
  end

  test "should get edit" do
    get effects_edit_url
    assert_response :success
  end
end
