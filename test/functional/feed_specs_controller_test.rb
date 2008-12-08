require 'test_helper'

class FeedSpecsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:feed_specs)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_feed_spec
    assert_difference('FeedSpec.count') do
      post :create, :feed_spec => { }
    end

    assert_redirected_to feed_spec_path(assigns(:feed_spec))
  end

  def test_should_show_feed_spec
    get :show, :id => feed_specs(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => feed_specs(:one).id
    assert_response :success
  end

  def test_should_update_feed_spec
    put :update, :id => feed_specs(:one).id, :feed_spec => { }
    assert_redirected_to feed_spec_path(assigns(:feed_spec))
  end

  def test_should_destroy_feed_spec
    assert_difference('FeedSpec.count', -1) do
      delete :destroy, :id => feed_specs(:one).id
    end

    assert_redirected_to feed_specs_path
  end
end
