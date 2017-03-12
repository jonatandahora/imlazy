defmodule Imlazy.ApiTest do
  use Imlazy.DataCase

  alias Imlazy.Api
  alias Imlazy.Api.Access

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:access, attrs \\ @create_attrs) do
    {:ok, access} = Api.create_access(attrs)
    access
  end

  test "list_access/1 returns all access" do
    access = fixture(:access)
    assert Api.list_access() == [access]
  end

  test "get_access! returns the access with given id" do
    access = fixture(:access)
    assert Api.get_access!(access.id) == access
  end

  test "create_access/1 with valid data creates a access" do
    assert {:ok, %Access{} = access} = Api.create_access(@create_attrs)
    
  end

  test "create_access/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Api.create_access(@invalid_attrs)
  end

  test "update_access/2 with valid data updates the access" do
    access = fixture(:access)
    assert {:ok, access} = Api.update_access(access, @update_attrs)
    assert %Access{} = access
    
  end

  test "update_access/2 with invalid data returns error changeset" do
    access = fixture(:access)
    assert {:error, %Ecto.Changeset{}} = Api.update_access(access, @invalid_attrs)
    assert access == Api.get_access!(access.id)
  end

  test "delete_access/1 deletes the access" do
    access = fixture(:access)
    assert {:ok, %Access{}} = Api.delete_access(access)
    assert_raise Ecto.NoResultsError, fn -> Api.get_access!(access.id) end
  end

  test "change_access/1 returns a access changeset" do
    access = fixture(:access)
    assert %Ecto.Changeset{} = Api.change_access(access)
  end
end
