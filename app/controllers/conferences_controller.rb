class ConferencesController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :respond_to_options
  load_and_authorize_resource find_by: :short_title
  load_resource :program, through: :conference, singleton: true, except: [:index, :redirect_to_current]

  def index
    @current = Conference.where('end_date >= ?', Date.current).reorder(start_date: :asc)
    @antiquated = @conferences - @current
  end

  def redirect_to_current
    @current = Conference.where('end_date >= ?', Date.current).first
    if @current
      redirect_to conference_path(id: @current.short_title)
    else
      redirect_to conferences_path
    end
  end

  def show
    @coc = nil
    coc_path = Rails.root.join('conference_policies.md')
    if File.exist?(coc_path)
      @coc = File.read(coc_path)
    end
  end

  private

  def respond_to_options
    respond_to do |format|
      format.html { head :ok }
    end if request.options?
  end
end