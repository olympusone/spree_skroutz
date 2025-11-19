Spree::Core::Engine.add_routes do
  get '/skroutz/products', to: 'skroutz#products', defaults: { format: :xml }
  get '/skroutz/products.xml.gz', to: 'skroutz#products'
end
