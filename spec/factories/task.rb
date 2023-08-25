FactoryBot.define do
  factory :task do
    title { 'Default Title' }
    description { 'Default Description' }
    tags { ['tag'] }
    status { 'start' }
  end
end
