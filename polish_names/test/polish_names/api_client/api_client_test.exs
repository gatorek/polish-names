defmodule PolishNames.APIClientTest do
  @moduledoc false

  use PolishNames.DataCase

  setup do
    api_client_call =
      Hammox.protect({PolishNames.APIClient.impl(), :call, 2}, PolishNames.APIClient)

    [api_client_call: api_client_call]
  end

  test "male names", %{api_client_call: api_client_call} do
    response = api_client_call.(:male, :names)
    assert length(response) == 100
    assert Enum.take(response, 3) == ["PIOTR", "KRZYSZTOF", "ANDRZEJ"]
  end

  test "male surnames", %{api_client_call: api_client_call} do
    response = api_client_call.(:male, :surnames)
    assert length(response) == 100
    assert Enum.take(response, 3) == ["NOWAK", "KOWALSKI", "WIŚNIEWSKI"]
  end

  test "female names", %{api_client_call: api_client_call} do
    response = api_client_call.(:female, :names)
    assert length(response) == 100
    assert Enum.take(response, 3) == ["ANNA", "KATARZYNA", "MARIA"]
  end

  test "female surnames", %{api_client_call: api_client_call} do
    response = api_client_call.(:female, :surnames)
    assert length(response) == 100
    assert Enum.take(response, 3) == ["NOWAK", "KOWALSKA", "WIŚNIEWSKA"]
  end
end
