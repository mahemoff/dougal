#!/usr/bin/ruby
# Wrapper for Trello member
module Dougal

  module Trello

    class Member < Wrapper

      PASSTHROUGHS = %w(id username full_name)

      def initialize(trello_member)
        super trello_member
      end

    end

  end

end
