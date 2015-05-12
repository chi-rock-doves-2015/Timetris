class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  before_action :require_login, :require_completed_task
  helper_method :current_user, :format_local_time


  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def format_local_time(time)
    return Time.at(time).in_time_zone.strftime("%A, %b %e at %l:%M %p")
  end

  private

  def require_login
    redirect_to welcome_path unless current_user
  end

  def require_completed_task
    if current_user
      tasks = current_user.pending_tasks
      if tasks.any?
        tasks.each do |task|
          redirect_to task if task.task_in_progress
        end
      end
    end
  end

end
