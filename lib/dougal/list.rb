#!/usr/bin/ruby
# Wrapper for Trello list
module Dougal

  class List

    attr_accessor :board, :cards

    PASSTHROUGHS = %w(id name)

    def initialize(board, trello_list)
      @board = board
      @trello_list = trello_list
      @cards = trello_list.cards.map { |c| Card.new(self, c) }
    end

    def method_missing(meth, *args)
      @trello_list.send(meth) if PASSTHROUGHS.include?(meth.to_s)
    end

  end

end
