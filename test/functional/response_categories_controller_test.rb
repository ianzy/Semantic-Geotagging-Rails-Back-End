require 'test_helper'

class ResponseCategoriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:response_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create response_category" do
    assert_difference('ResponseCategory.count') do
      post :create, :response_category => { }
    end

    assert_redirected_to response_category_path(assigns(:response_category))
  end

  test "should show response_category" do
    get :show, :id => response_categories(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => response_categories(:one).to_param
    assert_response :success
  end

  test "should update response_category" do
    put :update, :id => response_categories(:one).to_param, :response_category => { }
    assert_redirected_to response_category_path(assigns(:response_category))
  end

  test "should destroy response_category" do
    assert_difference('ResponseCategory.count', -1) do
      delete :destroy, :id => response_categories(:one).to_param
    end

    assert_redirected_to response_categories_path
  end
end
