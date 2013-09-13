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

  def self.period_start_end
    today         = Date.today
    period_start  = Date.new( today.year, today.month, 1 ).strftime( "%Y-%m-%d" )
    period_end    = Date.new( today.year, today.month, -1 ).strftime( "%Y-%m-%d" )

    puts "The current period is #{period_start} to #{period_end}."
    return period_start, period_end
  end
end