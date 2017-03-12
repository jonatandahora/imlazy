defmodule Imlazy.Api do
  @moduledoc """
  The boundary for the Api system.
  """

  import Ecto.{Query, Changeset}, warn: false
  alias Imlazy.Repo

  alias Imlazy.Api.Access

  @doc """
  Returns the list of access.

  ## Examples

      iex> list_access()
      [%Access{}, ...]

  """
  def list_access do
    Repo.all(Access)
  end

  @doc """
  Gets a single access.

  Raises `Ecto.NoResultsError` if the Access does not exist.

  ## Examples

      iex> get_access!(123)
      %Access{}

      iex> get_access!(456)
      ** (Ecto.NoResultsError)

  """
  def get_access!(id), do: Repo.get!(Access, id)

  @doc """
  Creates a access.

  ## Examples

      iex> create_access(access, %{field: value})
      {:ok, %Access{}}

      iex> create_access(access, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_access(attrs \\ %{}) do
    %Access{}
    |> access_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a access.

  ## Examples

      iex> update_access(access, %{field: new_value})
      {:ok, %Access{}}

      iex> update_access(access, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_access(%Access{} = access, attrs) do
    access
    |> access_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Access.

  ## Examples

      iex> delete_access(access)
      {:ok, %Access{}}

      iex> delete_access(access)
      {:error, %Ecto.Changeset{}}

  """
  def delete_access(%Access{} = access) do
    Repo.delete(access)
  end

  def delete_all_access() do
    Repo.delete_all(Access)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking access changes.

  ## Examples

      iex> change_access(access)
      %Ecto.Changeset{source: %Access{}}

  """
  def change_access(%Access{} = access) do
    access_changeset(access, %{})
  end

  defp access_changeset(%Access{} = access, attrs) do
    access
    |> cast(attrs, [:device_code, :user_code, :access_token])
    |> validate_required([:device_code, :user_code, :access_token])
  end
end
