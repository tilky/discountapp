class ShopifyIntegrationPrivate
	attr_accessor :api_key, :password, :url
    def initialize(params)
		%w(api_key password url).each do |field|
		raise "Missing Parameter #{field}" if params[field.to_sym].blank?
		
		instance_variable_set("@#{field}",params[field.to_sym])
		end
	end
	def connect 
	puts "connecting"
	shop_url = "https://#{api_key}:#{password}@#{url}/admin"
    ShopifyAPI::Base.site = shop_url
	end
  def import_order

    # Local variables
    created = failed = 0
    page = 1


    # Get the first page of orders
    shopify_orders = ShopifyAPI::Order.find(:all, params: {limit: 50, page: page})

    # Keep going while we have more orders to process
    while shopify_orders.size > 0

      shopify_orders.each do |shopify_order|

        # See if we've already imported the order
        order = Order.find_by_shopify_order_id(shopify_order.id)

        unless order.present?

          # If not already imported, create a new order
          order = Order.new(number: shopify_order.name,
                            email: shopify_order.email,
                            first_name: shopify_order.billing_address.first_name,
                            last_name: shopify_order.billing_address.last_name,
                            shopify_order_id: shopify_order.id,
                            order_date: shopify_order.created_at,
                            total: shopify_order.total_price,
                            financial_status: shopify_order.financial_status
                            )

          # Iterate through the line_items


          if order.save
            created += 1
          else
            failed += 1
          end
        end

      end

      # Grab the next page of products
      page += 1
      shopify_orders = ShopifyAPI::Order.find(:all, params: {limit: 50, page: page})


    end

    # Once we are done, return the results
    return {created: created,  failed: failed}
  end
end