module MockStripeData
  TP_VAL = "hahaha"
  def self.base_invoice
    {
      :id => 'in_test_invoice',
      :object => 'invoice',
      :livemode => false,
      :amount_due => 1000,
      :attempt_count => 0,
      :attempted => false,
      :closed => false,
      :currency => 'usd',
      :customer => 'c_test_customer',
      :date => 1349738950,
      :lines => {
        :data => [
          {
            :id => 'ii_test_invoice_item',
            :object => 'line_item',
            :livemode => false,
            :amount => 1000,
            :currency => 'usd',
            :period => {
              :start => 1367301074,
              :end => 1369893074
            },
            :quantity => 1,
            :plan => {
              :interval => 'month',
              :name => 'Basic',
              :amount => 199,
              :currency => 'usd',
              :id => 1,
              :object => 'plan',
              :livemode => false,
              :interval_count => 1,
              :trial_period_days => 30
            },
            :description => "A Test Invoice Item",              
          },
        ],
        :count => 1,
        :object => 'list',
        :url => '/v1/invoices/in_1k0gKCrwgSQahH/lines'
      },
      :paid => false,
      :period_end => 1349738950,
      :period_start => 1349738950,
      :starting_balance => 0,
      :subtotal => 1000,
      :total => 1000,
      :charge => nil,
      :discount => nil,
      :ending_balance => nil,
      :next_payment_attempt => 1349825350,
    }
  end
end