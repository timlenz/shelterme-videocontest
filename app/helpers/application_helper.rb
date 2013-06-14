module ApplicationHelper
  
  # Returns the full title on a per-page basis.
  def full_title(page_title)
    base_title = "Shelter Me Contest"
    if page_title.empty?
      base_title
    else
      "#{page_title} @ #{base_title}"
    end
  end
  
  def canonical_link_tag
    tag(:link, rel: :canonical, href: @canonical_url) if @canonical_url
  end

end
