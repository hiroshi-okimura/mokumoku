# frozen_string_literal: true

class Events::AttendancesController < ApplicationController
  before_action :only_woman, only: :create

  def create
    @event = Event.find(params[:event_id])
    event_attendance = current_user.attend(@event)
    (@event.attendees - [current_user] + [@event.user]).uniq.each do |user|
      NotificationFacade.attended_to_event(event_attendance, user)
    end
    redirect_back(fallback_location: root_path, success: '参加の申込をしました')
  end

  def destroy
    @event = Event.find(params[:event_id])
    current_user.cancel_attend(@event)
    redirect_back(fallback_location: root_path, success: '申込をキャンセルしました')
  end

  def only_woman
    unless current_user.female?
      redirect_to root_path, alert: 'このイベントは女性限定です'
    end
  end
end
