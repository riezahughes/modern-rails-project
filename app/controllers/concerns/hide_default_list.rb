module HideDefaultList
  extend ActiveSupport::Concern

  included do
    before_action :set_show_all, only: [:index]
  end

  private
  def hidden_results(search, &block)
    if params[:show_all].to_s == 'true' || !params[:q].nil?
      if block_given?
        yield search.result(distinct: true)
      else
        search.result(distinct: true)
      end
     else
       search.result().none
     end
  end

  def set_show_all
    @show_all = params[:show_all].to_s == 'true'
  end
end
