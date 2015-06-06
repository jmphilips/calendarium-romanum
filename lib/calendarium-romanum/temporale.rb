require 'date'
require 'easter'

module CalendariumRomanum

  # determine dates of the Temporale feasts of the given year
  class Temporale

    WEEK = 7

    # year is Integer - the civil year when the liturgical year begins
    def initialize(year)
      @year = year
    end

    def weekday_before(weekday, date)
      if date.wday == weekday then
        return date - WEEK
      elsif weekday < date.wday
        return date - (date.wday - weekday)
      else
        return date - (date.wday + WEEK - weekday)
      end
    end

    def weekday_after(weekday, date)
      if date.wday == weekday then
        return date + WEEK
      elsif weekday > date.wday
        return date + (weekday - date.wday)
      else
        return date + (WEEK - date.wday + weekday)
      end
    end

    def method_missing(sym, *args)
      # translate messages like sunday_before and thursday_after
      weekdays = %w{sunday monday tuesday wednesday thursday friday saturday}
      if sym.to_s =~ /^(#{weekdays.join('|')})_(before|after)$/ then
        return send("weekday_#{$2}", weekdays.index($1), *args)
      end

      # first_advent_sunday -> advent_sunday(1)
      four = %w{first second third fourth}
      if sym.to_s =~ /^(#{four.join('|')})_advent_sunday$/ then
        return send("advent_sunday", four.index($1) + 1, *args)
      end
      
      raise NoMethodError.new sym
    end
1
    def advent_sunday(num, year=nil)
      advent_sundays_total = 4
      unless (1..advent_sundays_total).include? num
        raise ArgumentError.new "Invalid Advent Sunday #{num}"
      end

      year ||= @year
      return sunday_before(nativity(year)) - ((advent_sundays_total - num) * WEEK)
    end

    def nativity(year=nil)
      year ||= @year
      return Date.new(year, 12, 25)
    end

    def epiphany(year=nil)
      year ||= @year
      return Date.new(year+1, 1, 6)
    end

    def baptism_of_lord(year=nil)
      year ||= @year
      return sunday_after epiphany(year)
    end

    def ash_wednesday(year=nil)
      year ||= @year
      return easter_sunday(year) - (6 * WEEK + 4)
    end

    def easter_sunday(year=nil)
      year ||= @year
      return Easter.easter(year+1).to_date
    end

    def pentecost(year=nil)
      year ||= @year
      return easter_sunday(year) + 7 * WEEK
    end
  end
end
