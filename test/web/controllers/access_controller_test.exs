defmodule Imlazy.Web.AccessControllerTest do
  use Imlazy.Web.ConnCase

  alias Imlazy.Api

  @create_attrs %{access_token: "some access_token", device_code: "some device_code", user_code: "some user_code"}
  @update_attrs %{access_token: "some updated access_token", device_code: "some updated device_code", user_code: "some updated user_code"}
  @invalid_attrs %{access_token: nil, device_code: nil, user_code: nil}

  def fixture(:access) do
    {:ok, access} = Api.create_access(@create_attrs)
    access
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, access_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing Access"
  end

  test "renders form for new access", %{conn: conn} do
    conn = get conn, access_path(conn, :new)
    assert html_response(conn, 200) =~ "New Access"
  end

  test "creates access and redirects to show when data is valid", %{conn: conn} do
    conn = post conn, access_path(conn, :create), access: @create_attrs

    assert %{id: id} = redirected_params(conn)
    assert redirected_to(conn) == access_path(conn, :show, id)

    conn = get conn, access_path(conn, :show, id)
    assert html_response(conn, 200) =~ "Show Access"
  end

  test "does not create access and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, access_path(conn, :create), access: @invalid_attrs
    assert html_response(conn, 200) =~ "New Access"
  end

  test "renders form for editing chosen access", %{conn: conn} do
    access = fixture(:access)
    conn = get conn, access_path(conn, :edit, access)
    assert html_response(conn, 200) =~ "Edit Access"
  end

  test "updates chosen access and redirects when data is valid", %{conn: conn} do
    access = fixture(:access)
    conn = put conn, access_path(conn, :update, access), access: @update_attrs
    assert redirected_to(conn) == access_path(conn, :show, access)

    conn = get conn, access_path(conn, :show, access)
    assert html_response(conn, 200) =~ "some updated access_token"
  end

  test "does not update chosen access and renders errors when data is invalid", %{conn: conn} do
    access = fixture(:access)
    conn = put conn, access_path(conn, :update, access), access: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Access"
  end

  test "deletes chosen access", %{conn: conn} do
    access = fixture(:access)
    conn = delete conn, access_path(conn, :delete, access)
    assert redirected_to(conn) == access_path(conn, :index)
    assert_error_sent 404, fn ->
      get conn, access_path(conn, :show, access)
    end
  end
end
