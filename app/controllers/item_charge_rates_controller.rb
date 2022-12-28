class ItemChargeRatesController < AuthoritativeController
  before_action :set_item_charge_rate, only: [:show, :edit, :update, :destroy]
  # GET /item_charge_rates
  def index
    @search = ItemChargeRate.ransack(params[:q])
    @item_charge_rates = @search.result(distinct: true).paginate(per_page: 10, page: params[:page])
  end

  # GET /item_charge_rates/1
  def show
  end

  # GET /item_charge_rates/new
  def new
    @item_charge_rate = ItemChargeRate.new
  end

  # GET /item_charge_rates/1/edit
  def edit
  end

  # POST /item_charge_rates
  def create
    @item_charge_rate = ItemChargeRate.new(item_charge_rate_params)

    if @item_charge_rate.save
      redirect_to @item_charge_rate, notice: 'Item charge rate was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /item_charge_rates/1
  def update
    if @item_charge_rate.update(item_charge_rate_params)
      redirect_to @item_charge_rate, notice: 'Item charge rate was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /item_charge_rates/1
  def destroy
    @item_charge_rate.destroy
    redirect_to item_charge_rates_url, notice: 'Item charge rate was successfully destroyed.'
  end

  private

  def create_item_charge_rate
    @item_charge_rate = ItemChargeRate.new(item_charge_rate_params)

    if @item_charge_rate.save
      redirect_to @item_charge_rate, notice: 'Item charge rate was successfully created.'
    else
      render :new
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_item_charge_rate
    @item_charge_rate = ItemChargeRate.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def item_charge_rate_params
    params.require(:item_charge_rate).permit(:chargeable_item_name,
                                             :qualification_type,
                                             :fixed_fee,
                                             :initial_block_duration_mins,
                                             :initial_block_charge,
                                             :block_duration_mins,
                                             :block_charge,
                                             :block_distance_miles,
                                             :block_distance_charge,
                                             :block_word_length,
                                             :block_word_length_charge,
                                             :account_type_id)
  end

end
