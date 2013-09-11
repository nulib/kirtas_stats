require 'date'

module GetDates
  def self.fiscal_start_end
    fiscal_start  = Date.parse( "2013-09-01" ).strftime( "%Y-%m-%d" )
    fiscal_end    = Date.parse( "2014-08-31" ).strftime( "%Y-%m-%d" )

    puts "The current fiscal year is #{fiscal_start} to #{fiscal_end}."
    return fiscal_start, fiscal_end
  end

  def self.prev_month_start_end
    prev_month        = Date.today.prev_month.month
    prev_month_year   = Date.today.prev_month.year
    prev_month_start  = Date.new( prev_month_year, prev_month, 1 ).strftime( "%Y-%m-%d" )
    prev_month_end    = Date.new( prev_month_year, prev_month, -1 ).strftime( "%Y-%m-%d" )
    return prev_month_start, prev_month_end
  end

  def self.period_start_end
    period_start  = prev_month_start_end.first
    period_end    = prev_month_start_end.last

    puts "The current period is #{period_start} to #{period_end}."
    return period_start, period_endl
  end
end