module Spree
  module Integrations
    class Skroutz < Spree::Integration
      def self.integration_group
        'marketing'
      end

      def self.icon_path
        'integration_icons/skroutz-logo.webp'
      end
    end
  end
end
