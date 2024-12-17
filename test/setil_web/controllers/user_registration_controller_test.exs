defmodule SetilWeb.UserRegistrationControllerTest do
  use SetilWeb.ConnCase, async: true

  import Setil.AccountsFixtures

  describe "GET /app/users/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, ~p"/app/users/register")
      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ ~p"/app/users/log_in"
      assert response =~ ~p"/app/users/register"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_user(user_fixture()) |> get(~p"/app/users/register")

      assert redirected_to(conn) == ~p"/"
    end
  end

  describe "POST /app/users/register" do
    @tag :capture_log
    test "creates account and logs the user in", %{conn: conn} do
      email = unique_user_email()

      conn =
        post(conn, ~p"/app/users/register", %{
          "user" => valid_user_attributes(email: email)
        })

      assert get_session(conn, :user_token)
      assert redirected_to(conn) == ~p"/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, ~p"/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ ~p"/app/users/settings"
      assert response =~ ~p"/app/users/log_out"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, ~p"/app/users/register", %{
          "user" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "Register"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
