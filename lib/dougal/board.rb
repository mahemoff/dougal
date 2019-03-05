#!/usr/bin/ruby
module Dougal

  class Board

    attr_accessor :members_by_id, :lists_by_id, :cards_by_id

    ALL_LISTS_RE = /todo|doing|done/i 

    ##############################################################################
    # INITIALISE AND READ CONFIG
    ##############################################################################

    # Get credentials from instructions at https://github.com/jeremytregunna/ruby-trello
    # And store them in your environment (e.g. via bashrc)
    def initialize(project_config)

      @project_config = project_config

      @trello_board = Trello::Board.find(self.class.extract_short_id(@project_config.trello_board))

      @members_by_id = @trello_board.members
        .map { |member| [member.id, Member.new(member)] }
        .to_h

      @lists_by_id = @trello_board.lists
        .select { |trello_list| trello_list.name =~ ALL_LISTS_RE }
        .map { |trello_list| [trello_list.id, List.new(self, trello_list)] }
        .to_h

      #@cards_by_id = @lists_by_id.values
        #.map { |list| list.cards }
        #.flatten
        #.map { |card| [card.id, card] }
        #.to_h

    end

    def self.extract_short_id(id)
      if id =~ %r(\Ahttps://trello.com/b/(.*?)/)
        $1
      else
        raise "Could not determine board ID from #{id}"
      end
    end

  end

end
