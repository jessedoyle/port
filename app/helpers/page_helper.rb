module PageHelper
  def edit_visibility_link(page)
    if page.public?
      link_to 'Make Private', toggle_page_visibility_path(page), remote: true, method: :patch
    else
      link_to 'Make Public', toggle_page_visibility_path(page), remote: true, method: :patch
    end
  end
end