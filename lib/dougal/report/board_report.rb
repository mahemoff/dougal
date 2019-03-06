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
        add_message "_Made for you by Dougal 🐶_", pre: 1
        @messages.join("\n"); 
      end

      def generate_lists(per_member)
        if per_member
          @board.members.each { |member|
            durations_by_list = {}
            cards = @board.cards_by_member_id[member.id]
            if cards.present?
              add_message "*#{member.full_name}*", pre: 1, post: 2
              cards.each { |card|
                add_message CardReport.new(card).generate
                durations_by_list[card.list.id]||=0
                durations_by_list[card.list.id] += Utils::Timer.parse_duration(card.name)||0
              }
            end
            add_blank_line
            generate_durations durations_by_list
          }
        else
          durations_by_list = {}
          cards = @board.cards.each { |card|
            add_message CardReport.new(card).generate
            durations_by_list[card.list.id]||=0
            durations_by_list[card.list.id] += Utils::Timer.parse_duration(card.name)||0
          }
          add_blank_line
          generate_durations durations_by_list
        end
      end

      def generate_list(for_member=nil)
        @board.cards_by_id.values.each { |card|
          if for_member.nil? || for_member.in?(card.members)
            add_message(CardReport.new(card).generate)
          end
        }
      end

      def generate_durations(durations_by_list)
        add_messages durations_by_list.map { |list_id, duration|
          "#{@board.lists_by_id[list_id].name} - #{(duration.to_f/3600).round(1)}h"
        }
      end

    #########################################################################
    # MESSAGE GENERATION
    #########################################################################

      def add_blank_line
        @messages << "\n"
      end

      def add_message(message, options={})
        print '.'
        (options[:pre]||0).times { @messages << "\n" }
        @messages << message
        (options[:pre]||0).times { @messages << "\n" }
      end 

      def add_messages(messages, options={})
        print '.'
        messages.each { |message| @messages << message }
      end

    end

  end

end
