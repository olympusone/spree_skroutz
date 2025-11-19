xml.instruct! :xml, version: "1.0", encoding: "UTF-8"

xml.mywebstore do
  cache [storefront_products_scope, current_currency] do
    xml.created_at Time.current.strftime("%Y-%m-%d %H:%M")

    xml.products do
      storefront_products_scope.find_each do |product|
        xml.product do
          xml.tag! "id", product.id
          xml.tag! "name" do
            xml.cdata! product.name
          end
          xml.tag! "link" do
            xml.cdata! spree_storefront_resource_url(product)
          end

          if product.default_image.present?
            xml.tag! "image" do
              xml.cdata! spree_image_url(product.featured_image, width: 500, height: 500)
            end
          end

          xml.tag! "category" do
            xml.cdata! product_breadcrumb_taxons(product).map(&:name).join(' > ')
          end
          xml.tag! "price_with_vat", format('%.2f', product.display_amount.to_d)

          if product.tax_category.present?
            tax_rate = product.tax_category.tax_rates.first
            xml.tag! "vat", format('%.2f', tax_rate&.amount_percentage || 0)
          else
            xml.tag! "vat", 0
          end

          if product.brand.present?
            xml.tag! "manufacturer" do
              xml.cdata! product.brand.name
            end
          end

          xml.tag! "mnp", product.sku if product.sku.present?
          xml.tag! "ean", product.barcode if product.barcode.present?
          xml.tag! "availability", product.in_stock? ? "In stock" : "Out of stock"
          # TODO: add size
          xml.tag! "weight", "#{product.weight} #{product.weight_unit}" if product.weight.present?
          # xml.tag! "shipping_cost", format('%.2f', product.shipping_cost.to_d) if product.respond_to?(:shipping_cost) && product.shipping_cost.present?
          # xml.tag! "color", product.color if product.respond_to?(:color) && product.color.present?
          xml.tag! "description", product.storefront_description&.truncate(10000) if product.storefront_description.present?
          xml.tag! "quantity", product.total_on_hand

          if product.variants.any?
            xml.variations do
              product.variants.each do |variant|
                xml.variation do
                  xml.tag! "variationid", variant.id
                  xml.tag! "link" do
                    xml.cdata! spree_storefront_resource_url(variant)
                  end
                  xml.tag! "availability", variant.in_stock? ? "In stock" : "Out of stock"
                  xml.tag! "manufacturersku", variant.sku if variant.sku.present?
                  xml.tag! "ean", variant.barcode if variant.barcode.present?
                  xml.tag! "price_with_vat", format('%.2f', variant.display_amount.to_d)
                  # TODO: add size
                  xml.tag! "quantity", variant.total_on_hand
                end
              end
            end
          end
        end
      end
    end
  end
end
