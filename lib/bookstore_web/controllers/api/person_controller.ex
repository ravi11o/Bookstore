defmodule BookstoreWeb.Api.PersonController do
  use BookstoreWeb, :controller

  alias Bookstore.Resource
  alias Bookstore.Repo

  def index(conn, _params) do
    persons = Resource.list_persons()
    render conn, "index.json", persons: persons
  end

  def recommendation(conn, _params) do
    persons = Resource.list_persons_preloaded()
    render conn, "index_preloaded.json", persons: persons
  end

  def show(conn, %{"id" => id}) do
    person = Resource.get_person(id)
    render conn, "show.json", person: person
  end

  def show_slug(conn, %{"slug" => slug}) do
    person = Resource.get_person_by_slug(slug)
    render conn, "edit.json", person: person
  end

  def create(conn, person_params) do
    with {:ok, person} <- Resource.insert_person(person_params) do
      person = person |> Repo.preload(:books)
      updated_person =
        if books = Map.get(person_params, "books") do
            books
            |> Enum.map(fn(id) -> Resource.get_book_preloaded(id) end)
            |> List.flatten
            |> Resource.update_person_with_books(person)
        end
      render conn, "show_with_books.json", person: updated_person || person
    else
      {:error, _changeset} -> json conn, ["This person already exists"]
    end
  end

  def edit(conn, %{"id" => id}) do
    if person = Resource.get_person(id) do
      person = person |> Repo.preload(:books)
      render conn, "edit.json", person: person
    else
      json conn, "No person found for this id"
    end
  end

  def update(conn, %{"id" => id} = person_params) do
    with{:ok, person} <- Resource.update_person(id, person_params) do
      person = person |> Repo.preload(:books)
      updated_person =
        if books = Map.get(person_params, "books") do
            books
            |> Enum.map(fn(id) -> Resource.get_book_preloaded(id) end)
            |> List.flatten
            |> Resource.update_person_with_books(person)
        end
      render conn, "show_with_books.json", person: updated_person || person
    else
      {:error, _changeset} -> json conn, ["This person already exists"]
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:ok, person} <- Resource.delete_person(id) do
      json conn, "#{person.name} deleted successfully"
    else
      {:error, _changeset} -> json conn, "Person could not be deleted"
    end
  end

end
