Mix.install([
  {:httpoison, "~> 1.8"},
  {:floki, "~> 0.34"},
  {:jason, "~> 1.4"}
])

defmodule SimpleCrawler do
  @base_url System.get_env("BASE_URL") || "https://api.example.com/products"

  def fetch_products do
    case HTTPoison.get(@base_url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body)}

      {:ok, %HTTPoison.Response{status_code: status}} ->
        {:error, "Erro HTTP: #{status}"}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def list_products do
    with {:ok, %{"data" => %{"products" => products}}} <- fetch_products() do
      Enum.map(products, fn p ->
        %{
          id: p["id"],
          name: p["name"],
          price: p["price"]["priceWithDiscount"],
          link: "https://url-product/#{p["id"]}"
        }
      end)
    end
  end
end
