module Dougal

  module Report

    class CardReport

      def initialize(card)
        @card = card
      end

      def generate
        return if @card.list.nil?
        list_name = @card.list.name
        task = @card.name.gsub(/[_~\*]+/, '') # remove formatting
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
      end

    end

  end

end
