module NotifyContentPresenter
  def h2(text)
    "# #{text}" << br
  end

  def add_line(text)
    text << br
  end

  def br
    "\n"
  end

  def hr
    br << '---' << br
  end

  def link_to(text, url)
    "[#{text}](#{url})"
  end
end
