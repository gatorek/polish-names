defmodule PolishNames.APIClient.HttpClient do
  @moduledoc false

  use HTTPoison.Base

  alias NimbleCSV.RFC4180, as: CSV

  @limit 100
  @urls %{
    male: %{
      surnames:
        "https://api.dane.gov.pl/media/resources/20220207/NAZWISKA_M%C4%98SKIE-OSOBY_%C5%BBYJ%C4%84CE_oAcmDus.csv",
      names:
        "https://api.dane.gov.pl/media/resources/20220207/8_-_WYKAZ_IMION_M%C4%98SKICH_OS%C3%93B_%C5%BBYJ%C4%84CYCH_WG_POLA_IMI%C4%98_PIERWSZE_WYST%C4%98PUJ%C4%84CYCH_W_REJESTRZE_PESEL_BEZ_ZGON%C3%93W.csv"
    },
    female: %{
      surnames:
        "https://api.dane.gov.pl/media/resources/20220207/NAZWISKA_%C5%BBE%C5%83SKIE-OSOBY_%C5%BBYJ%C4%84CE_MjgUyip.csv",
      names:
        "https://api.dane.gov.pl/media/resources/20220207/8_-_WYKAZ_IMION_%C5%BBE%C5%83SKICH_OS%C3%93B_%C5%BBYJ%C4%84CYCH_WG_POLA_IMI%C4%98_PIERWSZE_WYST%C4%98PUJ%C4%84CYCH_W_REJESTRZE_PESEL_BEZ_ZGON%C3%93W.csv"
    }
  }

  def call(gender, datatype) do
    @urls[gender][datatype]
    |> get!()
    |> Map.get(:body)
  end

  def process_response_body(body) do
    body
    |> CSV.parse_string()
    |> Enum.take(@limit)
    |> Enum.map(fn [name | _tl] -> name end)
  end
end
