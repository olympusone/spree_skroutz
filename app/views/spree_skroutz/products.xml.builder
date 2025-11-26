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

          if product.featured_image.present?
            xml.tag! "image" do
              xml.cdata! spree_image_url(product.featured_image, width: 500, height: 500)
            end
          end

          product.master_images.each do |image|
            next if product.featured_image == image

            xml.tag! "additionalimage" do
              xml.cdata! spree_image_url(image, width: 500, height: 500)
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

          xml.tag! "availability", product.in_stock? ? "In stock" : "Out of stock"

          if product.brand.present?
            xml.tag! "manufacturer" do
              xml.cdata! product.brand.name
            end
          end

          xml.tag! "ean", product.barcode if product.barcode.present?

          size = product.option_values.select{|ov| ov.option_type.name.downcase == 'size' }
            .map(&:presentation)
            .uniq
          xml.tag! "size", size.join(',') if size.any?

          xml.tag! "weight", "#{product.weight} #{product.weight_unit}" if product.weight.present?

          colors = product.option_values.select{|ov| ov.option_type.name.downcase == 'color' }
            .map(&:presentation)
            .uniq
          xml.tag! "color", colors.join(',') if colors.any?

          if product.storefront_description.present?
            xml.tag! "description" do
              xml.cdata! product.storefront_description&.truncate(10000)
            end
          end

          xml.tag! "quantity", product.total_on_hand

          if product.has_variants?
            xml.variations do
              product.variants.each do |variant|
                xml.variation do
                  xml.tag! "variationid", variant.id
                  xml.tag! "availability", variant.in_stock? ? "In stock" : "Out of stock"
                  xml.tag! "ean", variant.barcode if variant.barcode.present?
                  xml.tag! "price_with_vat", format('%.2f', variant.display_amount.to_d)

                  size = variant.option_values.select{|ov| ov.option_type.name.downcase == 'size' }
                    .map(&:presentation)
                    .uniq
                  xml.tag! "size", size.join(',') if size.any?

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
