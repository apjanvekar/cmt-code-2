require File.dirname(__FILE__) + '/../test_helper'
require 'tellers_controller'

# Re-raise errors caught by the controller.
class TellersController; def rescue_action(e) raise e end; end

class TellersControllerTest < Test::Unit::TestCase
  fixtures :tellers

  def setup
    @controller = TellersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = tellers(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:tellers)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:teller)
    assert assigns(:teller).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:teller)
  end

  def test_create
    num_tellers = Teller.count

    post :create, :teller => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_tellers + 1, Teller.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:teller)
    assert assigns(:teller).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Teller.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Teller.find(@first_id)
    }
  end
end
