class ServicesController < ApplicationController
  skip_before_action :authenticate_request

  def index
    @services = Service.where.not(status: :denied)
    @total_records = @services.count

    if params[:contract_id]
      @services = @services.where(contract_id: params[:contract_id])
      @total_records = Service.where(contract_id: params[:contract_id]).count
    else
      @total_records = Service.where(user: current_user).where(status: params[:status]).count
    end

    if current_user.role == "technician"
      @services = @services.where(user: current_user).where(status: params[:status].to_i)
    elsif current_user.role == "customer"
      @services = @services.where(status: params[:status].to_i)
    end
    @services = @services.paginate(page: params[:page], per_page: params[:page_size])
    render json: {data: ActiveModelSerializers::SerializableResource.new(@services), total_records: @total_records }
  end

  def open_services
    @services = Service.where(user: current_user)
      .where(status: :open)
      .paginate(page: params[:page], per_page: params[:page_size])

    @total_records = Service.where(contract_id: params[:contract_id]).count
    render json: {data: ActiveModelSerializers::SerializableResource.new(@services), total_records: @total_records }
  end

  def open_services_count
    count = Service.where(user: current_user).where(status: 0).count
    render json: {data: count }
  end

  def show
    @service = Service.includes(:items).find(params[:id])
    @items = Item.all
    @reasons = DenyReason.all
    render json: {
      service: ActiveModelSerializers::SerializableResource.new(@service), 
      items: @items, 
      reasons: @reasons 
    }
  end

  def request_repair
    @contract = Contract.find(params[:contract_id])
    Service.create(
      contract_id: params[:contract_id],
      reason_id: params[:reason_id],
      request_type: 1,
      user_id: @contract.user.id,
      service_date: Date.today,
      status: 0
    )
  end

  def create_services
    Contract::create_services
    Contract::create_services(true)
  end

  def complete_service
    @service = Service.find(params[:service_id])
    ServiceItem.where(service: @service).destroy_all
    ServicePart.where(service: @service).destroy_all

    params[:items].each do |item|
      ServiceItem.create(service: @service, item_id: item)
    end

    params[:parts].each do |item|
      ServicePart.create(
        service: @service,
        name: item[:name],
        price: item[:price],
        qty: item[:qty]
      )
    end

    @service.status = :done
    @service.lat = params[:lat] if params[:lat]
    @service.lng = params[:lng] if params[:lng]
    @service.save
    render json: @service
  end

  def deny_service
    @service = Service.find(params[:service_id])
    @service.status = :denied
    @service.save
    DenyService.create(
      service: @service,
      deny_reason_id: params[:deny_reason_id],
      user: @service.contract.user
    )

    render json: @service
  end

  def delay_service
    @service = Service.find(params[:service_id])
    @service.service_date = params[:service_date]
    @service.save
    render json: @service
  end
end
