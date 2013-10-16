require_relative '../get_dates'

describe GetDates do

  it 'finds the beginning and end of the year' do

    d = Date.new( 2013, 10, 16 )
    
    y1 = Date.new( 2013, 9, 1 )
    y2 = Date.new( 2014, 8, -1 )

    expect( GetDates::yearly_start_end ).to eq( [ y1, y2 ] )
  end

  it 'finds the beginning and end of the quarter' do

    d = Date.new( 2013, 10, 16 )

    q1 = Date.new( 2013, 9, 1 )
    q2 = Date.new( 2013, 11, -1 )

    expect( GetDates::quarterly_start_end ).to eq( [ q1, q2 ] )

  end

  it 'finds the beginning and end of the month' do

    d = Date.new( 2013, 10, 16 )

    m1 = Date.new( d.year, d.month, 1 )
    m2 = Date.new( d.year, d.month, -1 )

    expect( GetDates::monthly_start_end ).to eq( [ m1, m2 ] )

  end

end