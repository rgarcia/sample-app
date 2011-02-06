module ApplicationHelper

  # Return a title on a per-page basis
  # title method will be available in all of our views
  def title
    base_title = "RoR Tutorial Sample App"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  
  # return the logo image
  def logo
    image_tag("logo.png", :alt => "Sample App", :class => "round")
  end

end
