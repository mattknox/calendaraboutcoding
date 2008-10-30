require 'test_helper'

class CheckinsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:checkins)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_checkin
    assert_difference('Checkin.count') do
      post :create, :checkin => { }
    end

    assert_redirected_to checkin_path(assigns(:checkin))
  end

  def test_should_show_checkin
    get :show, :id => checkins(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => checkins(:one).id
    assert_response :success
  end

  def test_should_update_checkin
    put :update, :id => checkins(:one).id, :checkin => { }
    assert_redirected_to checkin_path(assigns(:checkin))
  end

  def test_should_destroy_checkin
    assert_difference('Checkin.count', -1) do
      delete :destroy, :id => checkins(:one).id
    end

    assert_redirected_to checkins_path
  end
end
