#!/usr/bin/ruby
# Wrapper for Trello list
module Dougal

  module Trello

    class List < Wrapper

      attr_accessor :board, :cards

      PASSTHROUGHS = %w(id name)

      def initialize(board, list)
        @board = board
        @cards = list.cards.map { |c| Card.new(self, c) }
        super list
      end

    end

  end

end
