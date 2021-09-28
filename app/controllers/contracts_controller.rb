class ContractsController < ApplicationController
  before_action :set_contract, only: [:show, :update, :destroy]

  # GET /contracts
  def index

    if current_user.admin?
      @contracts = Contract.includes([:user, :customer, :elevators, :services]).where(status: :active).order(:contract_number)
      @total_records = Contract.count
    elsif current_user.customer?
      @contracts = current_user.customer_contracts.where(status: :active).order(:contract_number)
      @total_records = current_user.customer_contracts.count
    elsif current_user.technician?
      @contracts = current_user.technician_contracts.where(status: :active).order(:contract_number)
      @total_records = current_user.technician_contracts.count
    end
    
    @contracts = @contracts.where(service_day: params[:service_day]) if params[:service_day].present?

    @contracts = @contracts.where(contract_number: params[:contract_number]) if params[:contract_number].present?
    
    if params[:customer_name].present?
      ids = @contracts.select {|c| c.customer.full_name.include? params[:customer_name]}
      @contracts = @contracts.where(id: ids.map(&:id))
    end

    if params[:sort]
      return if params[:sort] == "service_dept" || params[:sort] == "customer_name"
      if params[:desc] == "true"
        @contracts = Contract.where(id: @contracts.map {|con| con.id}.uniq).order("#{params[:sort]}::integer DESC")
      else
        @contracts = Contract.where(id: @contracts.map {|con| con.id}.uniq).order("#{params[:sort]}::integer ASC")
      end
    end

    result = @contracts.paginate(page: params[:page], per_page: params[:per_page])

    

    render json: {
      result: ActiveModelSerializers::SerializableResource.new(result),
      total_page: (@total_records.to_f / params[:per_page].to_f).ceil,
      total_records: @total_records
    }
  end

  # GET /contracts/1
  def show
    render json: @contract
  end

  # POST /contracts
  def create
    @contract = Contract.new(contract_params)
    if @contract.save!
      params[:elevators].each do |el|
          Elevator.create(
            contract_id: @contract.id,
            name: el[:name], 
            serial_number: el[:serial_number], 
            elevator_type: el[:elevator_type], 
            usage: el[:usage], 
            capacity: el[:capacity], 
            floors: el[:floors], 
            stops: el[:stops], 
            swing: el[:swing], 
            automatic: el[:automatic], 
            door_type: el[:door_type], 
            door_name: el[:door_name], 
            engine_room: el[:engine_room], 
            suspension_type: el[:suspension_type], 
            engine_type: el[:engine_type], 
            engine: el[:engine], 
            power: el[:power], 
            panel_type: el[:panel_type], 
            panel_name: el[:panel_name], 
            drive: el[:drive], 
            feedback: el[:feedback], 
            car_communication: el[:car_communication], 
            speed: el[:speed], 
            emergency_system: el[:emergency_system], 
            insurance_id: el[:insurance_id], 
            insurance_finish_date: (el[:insurance_finish_date] == "")? nil : el[:insurance_finish_date], 
            insurance_date: (el[:insurance_date] == "")? nil : el[:insurance_date], 
            standard_id: el[:standard_id], 
            standard_finish_date: (el[:standard_finish_date] == "")? nil : el[:standard_finish_date],  
            standard_type: el[:standard_type]
          )
      end
      render json: @contract, status: :created, location: @contract
    else
      render json: @contract.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /contracts/1
  def update
    if @contract.update(contract_params)
      @contract.elevators.destroy_all
      params[:elevators].each do |el|
        Elevator.create(
          contract_id: @contract.id,
          name: el[:name], 
          serial_number: el[:serial_number], 
          elevator_type: el[:elevator_type], 
          usage: el[:usage], 
          capacity: el[:capacity], 
          floors: el[:floors], 
          stops: el[:stops], 
          swing: el[:swing], 
          automatic: el[:automatic], 
          door_type: el[:door_type], 
          door_name: el[:door_name], 
          engine_room: el[:engine_room], 
          suspension_type: el[:suspension_type], 
          engine_type: el[:engine_type], 
          engine: el[:engine], 
          power: el[:power], 
          panel_type: el[:panel_type], 
          panel_name: el[:panel_name], 
          drive: el[:drive], 
          feedback: el[:feedback], 
          car_communication: el[:car_communication], 
          speed: el[:speed], 
          emergency_system: el[:emergency_system], 
          insurance_id: el[:insurance_id], 
          insurance_finish_date: (el[:insurance_finish_date] == "")? nil : el[:insurance_finish_date], 
          insurance_date: (el[:insurance_date] == "")? nil : el[:insurance_date], 
          standard_id: el[:standard_id], 
          standard_finish_date: (el[:standard_finish_date] == "")? nil : el[:standard_finish_date], 
          standard_type: el[:standard_type]
        )
    end
      render json: @contract
    else
      render json: @contract.errors, status: :unprocessable_entity
    end
  end

  # DELETE /contracts/1
  def destroy
    @contract.destroy
  end

  def create_today_services
    Contract.create_services
    render json: [], status: :created
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.includes([:elevators, :customer, :user]).find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def contract_params
      params.require(:contract).permit(
        :building_number, :user_id, :customer_id, :contract_number,
        :description, :start_date, :finish_date, :service_day, :stops,
        :total_price, :address, :payment_type, :lat, :lng, :dept
      )
    end
end
