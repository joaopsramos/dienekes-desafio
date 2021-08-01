defmodule Dienekes.Workers.RetryPagesTest do
  use ExUnit.Case

  alias Dienekes.Workers.RetryPages

  test "add_page_to_retry/1 add pages and pop_pages/0 pop pages" do
    RetryPages.add_page_to_retry(1)
    RetryPages.add_page_to_retry(2)

    assert RetryPages.pop_pages() == [2, 1]
  end
end
