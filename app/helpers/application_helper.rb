module ApplicationHelper
  # Return a title on a per-page basis
  def title
    base_title = "Micropost"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def logo
    image_tag('Micropost.png', :alt => 'Micropost', :class => 'round')
  end
end
