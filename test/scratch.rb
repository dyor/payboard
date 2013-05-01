require_relative 'mock_stripe'

invoices = MockStripe::Invoice.all
puts "DONE"