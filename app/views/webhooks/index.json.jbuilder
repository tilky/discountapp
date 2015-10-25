json.array!(@webhooks) do |webhook|
  json.extract! webhook, :id, :wb_id, :ord_cnt, :ord_id, :dscnt
  json.url webhook_url(webhook, format: :json)
end
