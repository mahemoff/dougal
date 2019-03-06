#!/usr/bin/ruby

require 'byebug'

module Dougal

  class CLI

    ##########################################################################
    # RUN FROM COMMAND LINE ARGS
    ##########################################################################

    def run(*args)
      command = args.first
      if command=='report'
        report
      elsif command=='version'
        die "Dougal #{Dougal::VERSION}"
      elsif !command || command=='' || command=='help'
        help
      else
        puts "Unknown command: #{command}"
        help
      end
    end

    ##########################################################################
    # HELP COMMAND
    ##########################################################################

    def help
      die <<~END
        Dougal helps you manage Trello projects.

        dougal report - generate reports
        dougal version - show version
        dougal help - get help (you are here)

        See https://github.com/playerfm/dougal/README.md for more.
      END
    end

    ##########################################################################
    # REPORT COMMAND
    ##########################################################################

    def report
      Dougal::Config.init
      projects = Dougal::Config.get(:projects)
      puts "Dougal will now generate #{projects.size} projects"
      projects.each { |project_config|
        board = Trello::Board.create_from_config(project_config.trello_board)
        message = Report::BoardReport.new(board, project_config).generate
        if project_config.slack_channel
          Dougal::Utils::Slacker.post project_config.slack_channel, message
        else
          puts message
        end
      }
    end

  ##############################################################################
  # OUTPUT HELPERS
  ##############################################################################

    def die(message, status=0)
      puts message
      exit status
    end

  end

end
