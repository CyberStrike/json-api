FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.word }
    created_by { Faker::Number.number(10) }

    factory :todo_with_items do
      transient do
        item_count 5
      end

      after(:create) do |todo, evaluator|
        create_list(:item, evaluator.item_count, todo: todo)
      end
    end
  end
end