class DashboardController < ApplicationController
  before_action :import_orders
  def index
	@orders = Order.all
  end
end
private
def import_orders
@account = Account.first
shopcon = ShopifyIntegrationPrivate.new(api_key: @account.shopify_api_key,
                           shared_secret: @account.shopify_shared_secret,
                           url: @account.shopify_account_url,
                           password: @account.shopify_password)
	shopcon.connect()					   
	shop = ShopifyAPI::Shop.current
	shopcon.import_order()	
end