require 'date'

module GetDates

  def self.yearly_start_end
    today = Date.today

    if today.month < 9
        fiscal_start = Date.new( today.prev_year.year, 9, 1 )
        fiscal_end   = Date.new( today.year, 8, -1 )
    else
        fiscal_start = Date.new( today.year, 9, 1 )
        fiscal_end   = Date.new( today.next_year, 8, -1 )
    end

    return [ fiscal_start, fiscal_end ]
  end

  def self.quarterly_start_end
    today = Date.today

    if today.month < 9
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

  def self.monthly_start_end
    today = Date.today

    monthly_start  = Date.new( today.year, today.month, 1 )
    monthly_end    = Date.new( today.year, today.month, -1 )

    return [ monthly_start, monthly_end ]
  end

end
