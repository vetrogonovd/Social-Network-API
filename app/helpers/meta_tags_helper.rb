module MetaTagsHelper

  def save_meta_tags(object)
    object.create_meta_tags meta_tag_params
  end

  def update_meta_tags(object)
    params_meta = check_params params
    if object.meta_tags.blank? && params_meta.present?
      object.create_meta_tags meta_tag_params
    elsif object.meta_tags.present? && params_meta.blank?
      object.meta_tags.destroy
    elsif object.meta_tags.present? && params_meta.present?
      object.meta_tags.update_attributes meta_tag_params
    end
  end

  private

  def check_params(params)
    res = params[:post] || params[:comment]
    res[:meta]
  end

  def meta_tag_params
    if params[:post]
      params.require(:post).require(:meta).permit(:meta_title, :meta_description,
                                                  :meta_image, :meta_link)
    elsif params[:comment]
      params.require(:comment).require(:meta).permit(:meta_title, :meta_description,
                                                     :meta_image, :meta_link)
    end
  end
end