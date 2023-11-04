class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :update, :destroy, :tds]

  # GET /employees
  def index
    @employees = Employee.all

    render json: @employees
  end

  # GET /employees/1
  def show
    render json: @employee
  end

  # POST /employees
  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      render json: @employee, status: :created, location: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /employees/1
  def update
    if @employee.update(employee_params)
      render json: @employee
    else
      render json: @employee.errors, status: :unprocessable_entity
    end
  end

  # DELETE /employees/1
  def destroy
    @employee.destroy
  end

  def tds
    render json: tds_response, status: :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def employee_params
      params.require(:employee).permit(:first_name, :last_name, :eid, :email, :salary, :doj, phone_numbers_attributes: [:number])
    end

    def tds_response
      {
        first_name: @employee.first_name,
        last_name: @employee.last_name,
        yearly_salary: @employee.salary_for_fy,
        tax_amount: @employee.tax_calculation,
        cess: @employee.cess
      }.to_json
    end
end
