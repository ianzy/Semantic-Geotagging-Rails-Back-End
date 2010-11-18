require 'test_helper'

class CommentCategoriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comment_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create comment_category" do
    assert_difference('CommentCategory.count') do
      post :create, :comment_category => { }
    end

    assert_redirected_to comment_category_path(assigns(:comment_category))
  end

  test "should show comment_category" do
    get :show, :id => comment_categories(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => comment_categories(:one).to_param
    assert_response :success
  end

  test "should update comment_category" do
    put :update, :id => comment_categories(:one).to_param, :comment_category => { }
    assert_redirected_to comment_category_path(assigns(:comment_category))
  end

  test "should destroy comment_category" do
    assert_difference('CommentCategory.count', -1) do
      delete :destroy, :id => comment_categories(:one).to_param
    end

    assert_redirected_to comment_categories_path
  end
end
