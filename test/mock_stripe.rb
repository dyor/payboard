require 'date'
require_relative 'test_data'

module MockStripe
  
  class TimePeriod
    attr_accessor :start, :end

    def initialize(params)
      params.each {|k,v| send("#{k}=",v)}
    end
  end

  class Subscription
    attr_accessor :interval, :name, :amount, :currency
    attr_accessor :id, :object, :livemode, :interval_count
    attr_accessor :trial_period_days    

    def initialize(params)
      params.each {|k,v| send("#{k}=",v)}
    end
  end

  class LineItem
    attr_accessor :id, :object, :livemode, :amount, :currency
    attr_accessor :period, :quantity, :plan, :description

    def initialize(params)
      params.each {|k,v| send("#{k}=",v) unless k == :plan || k == :period}
      @plan = Subscription.new(params[:plan])
      @period = TimePeriod.new(params[:period])
    end
  end

  class LineItems
    attr_accessor :data, :count, :object, :url

    def initialize(params)
      params.each {|k,v| send("#{k}=",v) unless k == :data}
      @data = []
      params[:data].each do |d|
        @data << LineItem.new(d)
      end
    end
  end
  
  class Invoice
    attr_accessor :id, :object, :livemode, :amount_due
    attr_accessor :attempt_count, :attempted, :closed
    attr_accessor :currency, :customer, :date, :lines
    attr_accessor :paid, :period_end, :period_start
    attr_accessor :starting_balance, :subtotal, :total
    attr_accessor :charge, :discount, :ending_balance
    attr_accessor :next_payment_attempt

    def initialize(params)
      params.each {|k,v| send("#{k}=",v) unless k == :lines}
      @lines = LineItems.new(params[:lines])
    end

    def self.all
      [Invoice.new(MockStripeData.base_invoice)]
    end
  end

end