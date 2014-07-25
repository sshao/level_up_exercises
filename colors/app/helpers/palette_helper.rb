module PaletteHelper
  def palette_exists(&block)
    yield if @palette
  end

  def output_colors(colors, classes = nil)
    classes = ["swatch"].concat(Array(classes)).join(" ")

    colors.each do |color|
      haml_tag(:div, class: classes, style: "background-color: #{color};")
    end
  end
end

