#!/usr/bin/ruby
module Dougal

  class Board

    attr_accessor :messages

    ALL_LISTS_RE = /todo|doing|done/i 

    ##############################################################################
    # INITIALISE AND READ CONFIG
    ##############################################################################

    # Get credentials from instructions at https://github.com/jeremytregunna/ruby-trello
    # And store them in your environment (e.g. via bashrc)
    def initialize(project_config)

      Trello.configure do |config|
        config.developer_public_key = Dougal::Config.get(:trello_api_key) # The "key" from step 1
        config.member_token = Dougal::Config.get(:trello_oauth_token) # The token from step 2.
      end

      @config = project_config
      @messages = []

    end

    def self.extract_short_id(id)
      if id =~ %r(\Ahttps://trello.com/b/(.*?)/)
        $1
      else
        raise "Could not determine board ID from #{id}"
      end
    end

    ##############################################################################
    # CAPTURE BOARD'S DATA
    ##############################################################################

    def read_board
      @board = Trello::Board.find(self.class.extract_short_id(@config.trello_board))

      @lists_by_id = @board\
      .lists
      .select { |list| list.name =~ ALL_LISTS_RE }
      .map { |list| [list.id, list] }.to_h

      @all_cards = @board.cards.select { |card|
        @lists_by_id.keys.include?(card.list_id)
      }

      all_member_ids = @all_cards.map(&:member_ids).flatten.uniq
      @all_members = all_member_ids.map { |id| Trello::Member.find(id) }
    end

    ##############################################################################
    # GENERATE REPORT
    ##############################################################################

    def generate
      #now = Time.now.in_time_zone('Europe/London').strftime '%A, %B %d, %Y'
      read_board
      now = Time.now.strftime '%A, %B %d, %Y'
      message "*DAILY REPORT: #{now}*\n"
      if @config.members
        @all_members.each { |member| generate_member_list(member) }
      else
        generate_global_list
      end
      message "\n_Made for you by Dougal 🐶_"
      @messages.join("\n"); 
    end

    def generate_global_list
      @all_cards.each { |card|
        card_message(card)
      }
    end

    def generate_member_list(member)
      message "\n*#{member.username}*\n\n"
      @all_cards.each { |card|
        card_message(card) if card.member_ids.include?(member.id)
      }
    end

    def card_message(card)
      list_name = @lists_by_id[card.list_id]&.name
      task = card.name.gsub(/[_~\*]+/, '') # remove formatting
      message(
        if list_name =~ /todo/i
          "🕑 #{task}"
        elsif list_name =~ /doing/i
          "➡️  *#{task}*"
        elsif list_name =~ /done/i
          "✔  ~#{task}~"
        elsif list_name =~ /abandoned/i
          "🤷 ~#{task}~"
        else
          "❓ (#{task})" # dougal has a bug; should never happen
        end
      )
    end

  ##############################################################################
  # MESSAGE GENERATION
  ##############################################################################

    def message(m, options={})
      print '.'
      @messages << m
    end 

  end

end
