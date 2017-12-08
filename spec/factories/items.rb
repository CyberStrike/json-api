FactoryBot.define do
  factory :item do
    name { Faker::StarWars.character }
    done false
    association :todo, factory: :todo
  end
end