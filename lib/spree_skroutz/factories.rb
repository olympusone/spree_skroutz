FactoryBot.define do
  factory :skroutz_integration, class: Spree::Integrations::Skroutz do
    active { true }
    store { Spree::Store.default }
  end
end
