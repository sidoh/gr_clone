module ApplicationHelper
  def render_modal(partial, click_element)
    render :partial => 'layouts/js_helpers/modal', :locals => {:partial => partial, :elmt => click_element}
  end

  def ajax_loading_gif
    image_tag 'loading.gif'
  end
end
