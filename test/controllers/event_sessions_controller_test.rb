require 'test_helper'

class EventSessionsControllerTest < ActionController::TestCase
  setup do
    @event_session = event_sessions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:event_sessions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create event_session" do
    assert_difference('EventSession.count') do
      post :create, event_session: { end_date: @event_session.end_date, end_time: @event_session.end_time, event_id: @event_session.event_id, location: @event_session.location, speaker: @event_session.speaker, start_date: @event_session.start_date, start_time: @event_session.start_time, status: @event_session.status, topic: @event_session.topic }
    end

    assert_redirected_to event_session_path(assigns(:event_session))
  end

  test "should show event_session" do
    get :show, id: @event_session
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @event_session
    assert_response :success
  end

  test "should update event_session" do
    patch :update, id: @event_session, event_session: { end_date: @event_session.end_date, end_time: @event_session.end_time, event_id: @event_session.event_id, location: @event_session.location, speaker: @event_session.speaker, start_date: @event_session.start_date, start_time: @event_session.start_time, status: @event_session.status, topic: @event_session.topic }
    assert_redirected_to event_session_path(assigns(:event_session))
  end

  test "should destroy event_session" do
    assert_difference('EventSession.count', -1) do
      delete :destroy, id: @event_session
    end

    assert_redirected_to event_sessions_path
  end
end
