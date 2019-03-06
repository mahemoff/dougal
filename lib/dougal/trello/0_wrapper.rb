#!/usr/bin/ruby
# Wrapper for Trello member
module Dougal

  module Trello

    class Wrapper

      def initialize(direct)
        @direct = direct
      end

      def method_missing(meth, *args)
        if self.class.const_get(:PASSTHROUGHS)&.include?(meth.to_s)
          @direct.send(meth) 
        elsif self.instance_variables.include?("@#{meth}_by_id".to_sym)
          self.instance_variable_get("@#{meth}_by_id").values
        else
          super
        end
      end

    end

  end

end
