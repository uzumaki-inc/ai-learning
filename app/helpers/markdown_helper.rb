module MarkdownHelper
  require "rouge"
  require "rouge/plugins/redcarpet"

  class RougeHTML < Redcarpet::Render::HTML
    include Rouge::Plugins::Redcarpet
  end

  def markdown(text)
    renderer_options = {
      filter_html: true,
      hard_wrap: true,
      space_after_headers: true
    }
    extensions = {
      link_attributes: { rel: "nofollow", taget: "_blank" },
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      tables: true,
      lax_spacing: true,
      underline: true,
      highlight: true,
      quote: true,
      footnotes: true
    }
    renderer = RougeHTML.new(renderer_options)
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    sanitize(markdown.render(text))
  end
end
