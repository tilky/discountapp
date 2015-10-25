class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!
  before_action :set_webhook, only: [:show, :edit, :update, :destroy]
  before_action :save_wbhook, only: [:create]

  respond_to :html

  def index
    @webhooks = Webhook.all
    respond_with(@webhooks)
  end

  def show
    respond_with(@webhook)
  end

  def new
    @webhook = Webhook.new
    respond_with(@webhook)
  end

  def edit
  end

  def create
    data = ActiveSupport::JSON.decode(request.body.read)
    @webhook = Webhook.new(:wb_id => data["id"],:ord_cnt => data["line_items"]["quantity"], :ord_id => request.headers['X-Request-Id'] )
    @webhook.save
    respond_with(@webhook)
  end

  def update
    @webhook.update(webhook_params)
    respond_with(@webhook)
  end

  def destroy
    @webhook.destroy
    respond_with(@webhook)
  end

  private
    def set_webhook
      @webhook = Webhook.find(params[:id])
    end

    def webhook_params
      params.require(:webhook).permit(:wb_id, :ord_cnt, :ord_id)
    end
	
	def save_wbhook
		if defined? storemsg
			storemsg.enqueue(request)
			head :ok
			request.body.rewind
		else
			storemsg = Queue.new
			storemsg.enqueue(request)
			head :ok
            request.body.rewind			
	end
	end
	
end
