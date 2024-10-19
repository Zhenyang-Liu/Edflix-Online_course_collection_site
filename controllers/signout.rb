get "/sign-out" do
  session.clear
  erb :sign_out
end