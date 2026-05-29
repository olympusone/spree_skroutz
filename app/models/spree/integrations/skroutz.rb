module Spree
  module Integrations
    class Skroutz < Spree::Integration
      OUT_OF_STOCK_AVAILABILITY_OPTIONS = [
        'Available from 4 to 6 days',
        'Available up to 12 days'
      ].freeze

      AVAILABILITY_OPTIONS = [
        'In Stock',
        'Available from 1 to 3 days', 
        *OUT_OF_STOCK_AVAILABILITY_OPTIONS
      ].freeze

      preference :express_delivery, :boolean, default: false
      preference :default_availability, :string

      def self.integration_group
        'marketing'
      end

      def self.icon_path
        'integration_icons/skroutz-logo.webp'
      end
    end
  end
end
