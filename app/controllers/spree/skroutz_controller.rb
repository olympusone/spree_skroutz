module Spree
  class SkroutzController < StoreController
    include BaseHelper
    include StorefrontHelper

    def products
      respond_to do |format|
        format.xml
        format.gzip do
          gz_xml = ActiveSupport::Gzip.compress(render_to_string(template: 'spree/skroutz/products', formats: [:xml]))
          send_data(gz_xml, filename: 'products.xml.gz', type: 'application/x-gzip', disposition: 'inline')
        end
      end
    end
  end
end
