require 'test_helper'

class WisesScrapesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wises_scrapes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wises_scrape" do
    assert_difference('WisesScrape.count') do
      post :create, :wises_scrape => { }
    end

    assert_redirected_to wises_scrape_path(assigns(:wises_scrape))
  end

  test "should show wises_scrape" do
    get :show, :id => wises_scrapes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => wises_scrapes(:one).to_param
    assert_response :success
  end

  test "should update wises_scrape" do
    put :update, :id => wises_scrapes(:one).to_param, :wises_scrape => { }
    assert_redirected_to wises_scrape_path(assigns(:wises_scrape))
  end

  test "should destroy wises_scrape" do
    assert_difference('WisesScrape.count', -1) do
      delete :destroy, :id => wises_scrapes(:one).to_param
    end

    assert_redirected_to wises_scrapes_path
  end
end
