class DashboardController < ApplicationController
  
  def index
    user_id = current_user.id.to_s
    today = Date.today
    tomorrow = Date.tomorrow

    contracts = Contract.includes([:user, :customer, :services, :elevators]).all
    
    @services = []
    (1..30).each do |item|
      cnt = contracts.where(service_day: item).count
      hash = {key: item, value: cnt}
      @services.push hash
    end

    users = User.where(role: "technician")
    @user_services = []

    users.each do |user|
      cnt = Service.includes(:user).where(status: "done").where(user: user).count
      hash = {key: user.full_name, value: cnt}
      @user_services.push(hash)
    end

    charts = {
      services: @services,
      user_services: @user_services
    }


    render json: {
      today: today.to_s,
      tomorrow: tomorrow.to_s,
      charts: charts,
    }
  end
  
  def map

    repair = Service.where(status: :open).where(request_type: :repair)
    repair_services = []

    repair.each do |r|
      hash = {id: r.id, contract_number: r.contract.contract_number, customer: r.contract.customer.full_name, contract_id: r.contract.id, building_number: r.contract.building_number, lat: r.contract.lat, lng: r.contract.lng}
      repair_services.push(hash)
    end

    monthly = Service.where(status: :open).where(request_type: :monthly)
    monthly_services = []

    monthly.each do |r|
      hash = {id: r.id, contract_number: r.contract.contract_number, customer: r.contract.customer.full_name, contract_id: r.contract.id, building_number: r.contract.building_number, lat: r.contract.lat, lng: r.contract.lng}
      monthly_services.push(hash)
    end


    render json: {
      repair: repair_services,
      monthly: monthly_services
    }
  end

  def contract_report
    contracts = Contract.includes([:customer, :user, :services, :elevators]).order(:created_at)
    render json: contracts
  end

  def contracts
    contracts = Contract.includes([:elevators, :user, :customer, :services]).order(:created_at)

    @due_contracts = contracts.where('finish_date < ?', Date.today + 2.month)
    .map{|c| {
      id: c.id, 
      finish_date: c.finish_date.to_date.to_pdate.to_s, 
      contract_number: c.contract_number, 
      customer: c.customer.full_name,
      cell: c.customer.cell,
      building_number: c.building_number
    } }

    @due_insurances =  Elevator.where('insurance_finish_date < ?', Date.today + 1.month)
    .map {|c| {
      id: c.contract.id, 
      finish_date: c.contract.finish_date.to_date.to_pdate.to_s, 
      contract_number: c.contract.contract_number, 
      building_number: c.contract.building_number,
      customer: c.contract.customer.full_name,
      cell: c.contract.customer.cell,
    }}

    @due_standards = Elevator.where('standard_finish_date < ?', Date.today + 1.month)
    .map{|c| {
      id: c.contract.id, 
      finish_date: c.contract.finish_date.to_date.to_pdate.to_s, 
      contract_number: c.contract.contract_number, 
      building_number: c.contract.building_number,
      customer: c.contract.customer.full_name,
      cell: c.contract.customer.cell,
    }}   
     @no_standards = Elevator.where(standard: nil)
     .map{|c| {
      id: c.contract.id, 
      finish_date: c.contract.finish_date.to_date.to_pdate.to_s, 
      contract_number: c.contract.contract_number, 
      building_number: c.contract.building_number,
      customer: c.contract.customer.full_name,
      cell: c.contract.customer.cell,
     }}  
    @no_insurances = Elevator.where(insurance: nil)
    .map{|c| {
      id: c.contract.id, 
      finish_date: c.contract.finish_date.to_date.to_pdate.to_s, 
      contract_number: c.contract.contract_number, 
      building_number: c.contract.building_number,
      customer: c.contract.customer.full_name,
      cell: c.contract.customer.cell,
    }}  
    
    render json: {
      due_contracts: @due_contracts,
      due_insurances: @due_insurances,
      due_standards: @due_standards,
      no_standards: @no_standards,
      no_insurances: @no_insurances,
    }
  end

  def denied_services
    @denied = DenyService.where(handled: false)
    render json: @denied
  end

  def assign_user
    @service = Service.find params[:deny_service_id]
    @denied = DenyService.find_by(service_id: @service.id)
    @service.user_id = params[:technician_id]
    @denied.handled = true
    @service.status = "open"
    @denied.save
    @service.save
    render json: @denied
  end

  def chart
    contracts = Contract.all
    @services = []
    (1..30).each do |item|
      cnt = Contract.where(service_day: item).count
      hash = {key: item, value: cnt}
      @services.push hash
    end
    render json: { services: @services.to_json }
  end

  def customer_dashboard
    contract_ids = Contract.where(customer: current_user).pluck(:id)
    services = Service.where(contract_id: contract_ids)
      .where(status: :open)
    render json: services
  end




  def services
    today = Date.today
    tomorrow =  Date.tomorrow

    services = Service.includes([:contract, :service_parts, :user, contract: [:customer, :user]]).order(:created_at)

    case params[:type]
      when "today" 
        services = services.where(service_date: today).where(status: :open)
      when "tomorrow"
        services = services.where(service_date: tomorrow).where(status: :open)
      when "denied"
        services = services.where(status: :denied)
      else
    end 

    render json: services
    
  end
end
