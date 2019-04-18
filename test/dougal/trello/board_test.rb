require_relative "../../test_helper"

module Dougal::Trello

  class BoardTest < Minitest::Test

    def setup
      @board = Board.create_from_config('https://trello.com/b/mtr0FLcy/vacation-planning')
    end

    def test_board_metadata
      assert @board.present?
      assert_equal 'Vacation Planning', @board.name
    end

    def test_lists

      lists = @board.lists_by_id.values
      assert_equal ['TODO SOON', 'DOING', 'DONE'], lists.map(&:name)

      todo = lists.find { |list| list.name == 'TODO SOON' }
      assert_equal [
        "Book flight (1h)", "Book hotel (1h)", "Book city tour (2h)",
        "Book country tour (2h)",
        "Notify work (10m)"
      ], todo.cards.map(&:name)

    end

  end

end
