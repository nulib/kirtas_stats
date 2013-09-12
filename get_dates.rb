require 'date'

module GetDates
  def self.fiscal_start_end

    current = Date.today
    if current.month >= 9
        fiscal_start = Date.parse( "#{ current.year }-09-01" ).strftime( "%Y-%m-%d" )
        fiscal_end   = Date.parse( "#{ current.next_year.year }-08-31" ).strftime( "%Y-%m-%d" )
    else
        fiscal_start = Date.parse( "#{ current.prev_year.year }-09-01" ).strftime( "%Y-%m-%d" )
        fiscal_end   = Date.parse( "#{ current.year }-08-31" )
    end

    puts "The current fiscal year is #{fiscal_start} to #{fiscal_end}."
    return fiscal_start, fiscal_end
  end

  def self.prev_month_start_end
    prev_month        = Date.today.prev_month
    prev_month_start  = Date.new( prev_month.year, prev_month.month, 1 ).strftime( "%Y-%m-%d" )
    prev_month_end    = Date.new( prev_month.year, prev_month.month, -1 ).strftime( "%Y-%m-%d" )
    return prev_month_start, prev_month_end
  end

  def self.period_start_end
    period_start  = prev_month_start_end.first
    period_end    = prev_month_start_end.last

    puts "The current period is #{period_start} to #{period_end}."
    return period_start, period_endl
  end
end