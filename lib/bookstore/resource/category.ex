defmodule Bookstore.Resource.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bookstore.Resource.{Book, Category, BookCategory}


  schema "categories" do
    field :description, :string
    field :name, :string
    field :slug, :string
    many_to_many :books, Book, join_through: BookCategory, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(%Category{} = category, attrs) do
    attrs = Map.merge(attrs, generate_slug(attrs))
    
    category
    |> cast(attrs, [:name, :description, :slug])
    |> validate_required([:name, :description])
    |> unique_constraint(:name)
  end

  defp generate_slug(%{"name" => name}) do
    slug = Slugger.slugify_downcase(name)
    %{"slug" => slug}
  end
end
