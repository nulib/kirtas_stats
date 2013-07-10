require 'date'

module GetDates
  def self.fiscal_start_end
    fiscal_start  = Date.parse( "2012-09-01" ).strftime( "%Y-%m-%d" )
    fiscal_end    = Date.parse( "2013-08-31" ).strftime( "%Y-%m-%d" )

    puts "The current fiscal year is #{fiscal_start} to #{fiscal_end}."
    print "Enter a new fiscal start date (Enter to keep default): "
    new_fiscal_start = gets.chomp
    return fiscal_start, fiscal_end if new_fiscal_start.empty?
    print "Enter a new fiscal end date: "
    new_fiscal_end = gets.chomp
    
    fiscal_start  = Date.parse( new_fiscal_start ).strftime( "%Y-%m-%d" )
    fiscal_end    = Date.parse( new_fiscal_end ).strftime( "%Y-%m-%d" )
    
    return fiscal_start, fiscal_end
  end

  def self.prev_month_start_end
    prev_month      = Date.today.prev_month.month
    prev_month_year   = Date.today.prev_month.year
    prev_month_start  = Date.new( prev_month_year, prev_month, 1 ).strftime( "%Y-%m-%d" )
    prev_month_end    = Date.new( prev_month_year, prev_month, -1 ).strftime( "%Y-%m-%d" )
    return prev_month_start, prev_month_end
  end

  def self.period_start_end
    period_start  = prev_month_start_end.first
    period_end    = prev_month_start_end.last

    puts "The current period is #{period_start} to #{period_end}."
    print "Enter a new period start date (Enter to keep default): "
    new_period_start = gets.chomp
    return period_start, period_end if new_period_start.empty?
    print "Enter a new period end date: "
    new_period_end = gets.chomp

    period_start  = Date.parse( new_period_start ).strftime( "%Y-%m-%d" )
    period_end    = Date.parse( new_period_end ).strftime( "%Y-%m-%d" )
    return period_start, period_endl
  end
end