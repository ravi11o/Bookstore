defmodule Bookstore.Resource.Book do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bookstore.Resource.{Book, Category, BookCategory, Recommendation, Person}

  schema "books" do
    field :afffiliate_link, :string
    field :author, :string
    field :description, :string
    field :name, :string
    field :publisher, :string
    field :slug, :string
    many_to_many :categories, Category, join_through: BookCategory
    many_to_many :persons, Person, join_through: Recommendation

    timestamps()
  end

  @doc false
  def changeset(%Book{} = book, attrs) do
    book
    |> cast(attrs, [:name, :slug, :author, :publisher, :description, :afffiliate_link])
    |> validate_required([:name, :author, :publisher, :description, :afffiliate_link])
    |> unique_constraint(:slug)
  end
end
