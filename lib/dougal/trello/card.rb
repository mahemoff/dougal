#!/usr/bin/ruby
# Wrapper for Trello list
module Dougal

  module Trello

    class Card < Wrapper

      PASSTHROUGHS = %w(id name)

      attr_accessor :list # belongs_to
      attr_accessor :members # has_many

      def initialize(list, trello_card)
        @list = list
        @members = Set.new(list.board.members_by_id.slice(*trello_card.member_ids).values)
        super trello_card
      end

      def duration
        Timer.parse_duration(card.name)
      end

    end

  end

end
