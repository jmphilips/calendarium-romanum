module CalendariumRomanum

  # a date not bound to a particular year
  class AbstractDate
    include Comparable

    def initialize(month, day)
      validate! month, day
      @month = month
      @day = day
    end

    def self.from_date(date)
      new(date.month, date.day)
    end

    attr_reader :month, :day

    def <=>(other)
      if month != other.month
        month <=> other.month
      else
        day <=> other.day
      end
    end

    def hash
      (month * 100 + day).hash
    end

    def eql?(other)
      month == other.month && day == other.day
    end

    def concretize(year)
      Date.new(year, month, day)
    end

    private

    def validate!(month, day)
      unless month >= 1 && month <= 12
        raise RangeError.new("Invalid month #{month}.")
      end

      day_lte = case month
                when 2
                  29
                when 1, 3, 5, 7, 8, 10, 12
                  31
                else
                  30
                end

      unless day > 0 && day <= 31
        raise RangeError.new("Invalid day #{day}.")
      end
      unless day <= day_lte
        raise RangeError.new("Invalid day #{day} for month #{month}.")
      end
    end
  end
end
