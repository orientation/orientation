module ArticlesHelper
  def search_title_only?
    params.key?(:search) && params.key?(:search_title_only) && params[:search_title_only] == '1'
  end

  def search_body?
    params.key?(:search) && !params[:search].blank? && !params.key?(:search_title_only)
  end
end
