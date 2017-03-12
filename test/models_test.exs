defmodule Imlazy.ModelsTest do
  use Imlazy.DataCase

  alias Imlazy.Models
  alias Imlazy.Models.User

  @create_attrs %{bio: "some bio", email: "some email", name: "some name", number_of_pets: 42}
  @update_attrs %{bio: "some updated bio", email: "some updated email", name: "some updated name", number_of_pets: 43}
  @invalid_attrs %{bio: nil, email: nil, name: nil, number_of_pets: nil}

  def fixture(:user, attrs \\ @create_attrs) do
    {:ok, user} = Models.create_user(attrs)
    user
  end

  test "list_users/1 returns all users" do
    user = fixture(:user)
    assert Models.list_users() == [user]
  end

  test "get_user! returns the user with given id" do
    user = fixture(:user)
    assert Models.get_user!(user.id) == user
  end

  test "create_user/1 with valid data creates a user" do
    assert {:ok, %User{} = user} = Models.create_user(@create_attrs)
    
    assert user.bio == "some bio"
    assert user.email == "some email"
    assert user.name == "some name"
    assert user.number_of_pets == 42
  end

  test "create_user/1 with invalid data returns error changeset" do
    assert {:error, %Ecto.Changeset{}} = Models.create_user(@invalid_attrs)
  end

  test "update_user/2 with valid data updates the user" do
    user = fixture(:user)
    assert {:ok, user} = Models.update_user(user, @update_attrs)
    assert %User{} = user
    
    assert user.bio == "some updated bio"
    assert user.email == "some updated email"
    assert user.name == "some updated name"
    assert user.number_of_pets == 43
  end

  test "update_user/2 with invalid data returns error changeset" do
    user = fixture(:user)
    assert {:error, %Ecto.Changeset{}} = Models.update_user(user, @invalid_attrs)
    assert user == Models.get_user!(user.id)
  end

  test "delete_user/1 deletes the user" do
    user = fixture(:user)
    assert {:ok, %User{}} = Models.delete_user(user)
    assert_raise Ecto.NoResultsError, fn -> Models.get_user!(user.id) end
  end

  test "change_user/1 returns a user changeset" do
    user = fixture(:user)
    assert %Ecto.Changeset{} = Models.change_user(user)
  end
end
