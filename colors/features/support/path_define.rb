module PathDefine
  def fixtures_path
    @fixtures_path ||= "#{::Rails.root}/spec/fixtures"
  end
end

World(PathDefine)

