module Dougal

  class BoardReport

    def initialize(board, project_config)
      @board = board
      @project_config = project_config
      @messages = []
    end

    #########################################################################
    # MESSAGE GENERATION
    #########################################################################

    def generate
      #now = Time.now.in_time_zone('Europe/London').strftime '%A, %B %d, %Y'
      now = Time.now.strftime '%A, %B %d, %Y'
      message "*DAILY REPORT: #{now}*\n"
      if @project_config.members
        @board.members_by_id.values.each { |member| generate_member_list(member) }
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
      message "\n*#{member.full_name}*\n\n"
      @board.lists_by_id.values.each { |list|
        list.cards.each { |card|
          message(CardReport.new(card).generate) if card.members.include?(member)
        }
      }
    end

  #########################################################################
  # MESSAGE GENERATION
  #########################################################################

    def message(m, options={})
      print '.'
      @messages << m
    end 

  end

end
