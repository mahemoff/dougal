#!/usr/bin/ruby
module Dougal

  module Trello

    class Board < Wrapper

      PASSTHROUGHS = %w(id name)

      attr_accessor :members_by_id # has_many
      attr_accessor :lists_by_id # has_many
      attr_accessor :cards_by_id # has_many through lists
      attr_accessor :cards_by_member_id

      ALL_LISTS_RE = /todo|doing|reviewing|testing|done/i 

      ##############################################################################
      # INITIALISE AND READ CONFIG
      ##############################################################################

      def self.create_from_config(board_url)
        if board_url =~ %r(\Ahttps://trello.com/b/(.*?)/)
          self.new(::Trello::Board.find($1))
        else
          raise("Could not determine board ID from #{id}")
        end
      end

      # Get credentials from instructions at https://github.com/jeremytregunna/ruby-trello
      # And store them in your environment (e.g. via bashrc)
      def initialize(direct)

        super direct

        @members_by_id = @direct.members
          .map { |member| [member.id, Member.new(member)] }
          .to_h

        @lists_by_id = @direct.lists
          .select { |trello_list| trello_list.name =~ ALL_LISTS_RE }
          .map { |trello_list| [trello_list.id, List.new(self, trello_list)] }
          .to_h

        @cards_by_id = @lists_by_id.values
          .map { |list| list.cards }
          .flatten
          .map { |card| [card.id, card] }
          .to_h

        @cards_by_member_id = @cards_by_id.values.each_with_object({}) { |card, all|
          card.members.each { |member|
            all[member.id] ||= []
            all[member.id] << card
          }
        }

      end

    end

  end

end
