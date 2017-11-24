FactoryBot.define do
  factory :todo do
    title { Faker::Lorem.word }
    user

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