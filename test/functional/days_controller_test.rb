require 'test_helper'

class DaysControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:days)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_day
    assert_difference('Day.count') do
      post :create, :day => { }
    end

    assert_redirected_to day_path(assigns(:day))
  end

  def test_should_show_day
    get :show, :id => days(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => days(:one).id
    assert_response :success
  end

  def test_should_update_day
    put :update, :id => days(:one).id, :day => { }
    assert_redirected_to day_path(assigns(:day))
  end

  def test_should_destroy_day
    assert_difference('Day.count', -1) do
      delete :destroy, :id => days(:one).id
    end

    assert_redirected_to days_path
  end
end
