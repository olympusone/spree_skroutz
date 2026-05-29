Rails.application.config.after_initialize do
  Spree.integrations << Spree::Integrations::Skroutz

  Spree::PermittedAttributes.product_attributes.push(:skroutz_availability)

  Rails.application.config.spree_admin.product_form_partials << 'spree/admin/products/skroutz_availability'
end
