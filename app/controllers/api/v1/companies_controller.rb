class Api::V1::CompaniesController < ApiController
before_action :set_company , only: %i[show update destroy]
  def index
    @companies = current_user.companies.all
    if @companies.present?
        render json: @companies , status: :ok
    else
        render json: {
          message: "No Companies Found"
        }
    end
  end

  def create
    # @company = Company.new(company_params)
    @company = current_user.companies.new(company_params)
    if @company.save
      render json: @company, status: :ok
    else
      render json: {
        data: @company.errors.full_messages
      }, status: :unprocessable_entity
    end
  end
  def show
      render json: {
        "company": @company,
        "user": current_user
      }, status: :ok
  end

  def update
    if @company.update(company_params)
      render json: {
        company: @company ,
        message: "Updated Successfully"
      }, status: :ok
    else
      render json: {
        data: @company.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if @company.destroy
      render json: {
        message: "Destroyed Successfully"
      },
      status: :ok
    else
      render json: {
        message: @company.errors.full_messages
      },
      status: :unprocessable_entitys
    end
  end
private
  def set_company
      @company = current_user.companies.find(params[:id])
    rescue ActiveRecord::RecordNotFound => error
      render json: error.message , status: :unauthorized
  end

  def company_params
    params.require(:company).permit(:name, :established_year, :address    )
  end
end
