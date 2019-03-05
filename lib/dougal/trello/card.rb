#!/usr/bin/ruby
# Wrapper for Trello list
module Dougal

  module Trello

    class Card

      PASSTHROUGHS = %w(id name)

      attr_accessor :list, :members

      def initialize(list, trello_card)
        @list = list
        @members = Set.new(list.board.members_by_id.slice(*trello_card.member_ids).values)
        @trello_card = trello_card
      end

      def duration
        Timer.parse_duration(card.name)
      end

      def name
        @trello_card.name
      end

      def method_missing(meth, *args)
        @trello_card.send(meth) if PASSTHROUGHS.include?(meth.to_s)
      end

    end

  end

end
