# Handles human-friendly time formats
# e.g. extract `blah (5h)` to a duration of 5 hours
module Dougal

  module Utils

    class Timer

      UNITS_BY_INITIAL = %w(minutes hours days weeks).map { |unit|
        [unit.first, unit]
      }.to_h

      def self.parse_duration(str, default_unit: 'h')
        str = str.to_s.downcase
        if str =~ /\(\s*([0-9.,]+)\s*([mhdw]).*\)/
          unit_initial = $2&.first || default_unit
          unit = UNITS_BY_INITIAL[unit_initial]
          $1.to_f.send(unit)
        end
      end

    end

  end

end
