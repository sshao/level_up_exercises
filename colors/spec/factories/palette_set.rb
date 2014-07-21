FactoryGirl.define do
  factory :palette_set do
    source "charlie"
  end

  factory :invalid_palette_set, parent: :palette_set do 
    source nil
  end
end

