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

  def self.quarterly_start_end

    today = Date.today

    if today < Date.new( today.year, 9, 1 ) then
      q1_start = Date.new( today.prev_year.year, 9, 1 )
      q1_end   = Date.new( today.prev_year.year, 11, -1 )
      q2_start = Date.new( today.prev_year.year, 12, 1 )
      q2_end   = Date.new( today.year, 2, -1 )
      q3_start = Date.new( today.year, 3, 1 )
      q3_end   = Date.new( today.year, 5, -1 )
      q4_start = Date.new( today.year, 6, 1 )
      q4_end   = Date.new( today.year, 8, -1 )
    else
      q1_start = Date.new( today.year, 9, 1 )
      q1_end   = Date.new( today.year, 11, -1 )
      q2_start = Date.new( today.year, 12, 1 )
      q2_end   = Date.new( today.next_year.year, 2, -1 )
      q3_start = Date.new( today.next_year.year, 3, 1 )
      q3_end   = Date.new( today.next_year.year, 5, -1 )
      q4_start = Date.new( today.next_year.year, 6, 1 )
      q4_end   = Date.new( today.next_year.year, 8, -1 )
    end

    q1 = ( q1_start..q1_end )
    q2 = ( q2_start..q2_end )
    q3 = ( q3_start..q3_end )
    q4 = ( q4_start..q4_end )

    if q1.include?( today )
      return [ q1_start, q1_end ]
    elsif q2.include?( today )
      return [ q2_start, q2_end ]
    elsif q3.include?( today )
      return [ q3_start, q3_end ]
    else
      return [ q4_start, q4_end ]
    end

  end


  def self.period_start_end
    today         = Date.today
    period_start  = Date.new( today.year, today.month, 1 ).strftime( "%Y-%m-%d" )
    period_end    = Date.new( today.year, today.month, -1 ).strftime( "%Y-%m-%d" )

    puts "The current period is #{period_start} to #{period_end}."
    return period_start, period_end
  end

end