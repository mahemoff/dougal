#!/usr/bin/ruby
# Wrapper for Trello member
module Dougal

  class Member

    PASSTHROUGHS = %w(id username full_name)

    def initialize(trello_member)
      @trello_member = trello_member
    end

    def method_missing(meth, *args)
      @trello_member.send(meth) if PASSTHROUGHS.include?(meth.to_s)
    end

  end

end
