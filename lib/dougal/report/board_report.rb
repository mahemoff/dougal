module Dougal

  module Report

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
        add_message "*DAILY REPORT: #{now}*\n"
        generate_lists(@project_config.members)
        add_message "\n_Made for you by Dougal 🐶_"
        @messages.join("\n"); 
      end

      def generate_lists(per_member)
        if per_member
          @board.members.each { |member|
            cards = @board.cards_by_member_id[member.id]
            if cards.present?
              add_message "\n*#{member.full_name}*\n\n"
              add_messages(cards.map { |card| CardReport.new(card).generate })
            end
          }
        else
          cards = @board.cards.each { |card|
            add_message CardReport.new(card).generate
          }
        end
      end

      def generate_list(for_member=nil)
        @board.cards_by_id.values.each { |card|
          if for_member.nil? || for_member.in?(card.members)
            add_message(CardReport.new(card).generate)
          end
        }
      end

    #########################################################################
    # MESSAGE GENERATION
    #########################################################################

      def add_message(message, options={})
        print '.'
        @messages << message
      end 

      def add_messages(messages, options={})
        print '.'
        messages.each { |message| @messages << message }
      end

    end

  end

end
