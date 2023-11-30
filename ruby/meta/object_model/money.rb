require 'money'

bargain_price = Money.from_numeric(99, "USD")
bargain_price.format

standard_price = 100.to_money(99, "USD")
standard_price.format

class Numeric
    def to_money(currency = nil)
        Money.from_numeric( self, currency || Money.default_currency)
    end
end