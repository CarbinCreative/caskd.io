# encoding: utf-8
class Api::DistilleriesController < Api::ApplicationController

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  before_action :set_distillery, only: [:show]

  def index
    @distilleries = Distillery.published.paginate(page: params[:page], per_page: Api::ApplicationController::RESOURCES_PER_PAGE).order(updated_at: :desc)
    if params[:search]
      @distilleries = @distilleries.search(params[:search])
    end
    render json: @distilleries, meta: resources_meta(@distilleries)
  end

  def show
    render json: [@distillery], meta: resource_meta(@distillery)
  end

  private

  def not_found
    render status: 404, json: {
      errors: {
        resource: [ "Distillery does not exist." ]
      }
    }
  end

  def set_distillery
    @distillery = Distillery.published.where('id = :id OR token = :id OR slug = :id', id: params[:id])
  end

  def distillery_params
    params.require(:distillery).permit(
      :name,
      :title,
      :slug,
      :phonetic,
      :respelling,
      :meaning,
      :description,
      :status,
      :state
    )
  end

end
