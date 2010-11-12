require 'test_helper'

class RespsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:resps)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create resp" do
    assert_difference('Resp.count') do
      post :create, :resp => { }
    end

    assert_redirected_to resp_path(assigns(:resp))
  end

  test "should show resp" do
    get :show, :id => resps(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => resps(:one).to_param
    assert_response :success
  end

  test "should update resp" do
    put :update, :id => resps(:one).to_param, :resp => { }
    assert_redirected_to resp_path(assigns(:resp))
  end

  test "should destroy resp" do
    assert_difference('Resp.count', -1) do
      delete :destroy, :id => resps(:one).to_param
    end

    assert_redirected_to resps_path
  end
end
