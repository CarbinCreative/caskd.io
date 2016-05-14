# encoding: utf-8
require 'test_helper'

class Api::DistilleriesControllerTest < ActionController::TestCase

  include AssertJson

  setup do
    @distillery = Distillery.create(name: 'Ardbeg', title: 'Ardbeg', slug: 'ardbeg', phonetic: '/ɑːrdˈbɛɡ/', respelling: 'ard-beg', meaning: 'small headland')
  end

  test "should get all existing resources" do
    get :index, format: :json
    assert_response :success
    assert_json @response.body do
      has :meta do
        has :resourceCount, Distillery.count
      end
    end
  end

  test "should get one existing resource" do
    get :show, id: @distillery.id, format: :json
    assert_response :success
    assert_json @response.body do
      has :meta do
        has :resourceCount, 1
      end
    end
  end

end
