module Spree
  module ProductDecorator
    def skroutz_availability
      private_metadata['skroutz_availability'].presence
    end

    def skroutz_availability=(value)
      self.private_metadata = private_metadata.merge('skroutz_availability' => value.presence)
    end

    Spree::Product.prepend self
  end
end
