task :update_palettes => :environment do
  palettes = PaletteSet.where("updated_at < :three_days", {:three_days => 3.days.ago})

  palettes.each do |palette|
    palette.title = "Data more than three days old; needs updating."
    palette.save
  end
end
