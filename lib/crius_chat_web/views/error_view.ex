defmodule CriusChatWeb.ErrorView do
  use CriusChatWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  def render("404.html", _assigns) do
    # %{
    #   error: "Page not found"
    # }
    "404"
  end

  def render("500.html", _assigns) do
    # %{
    #   error: "Internal server error"
    # }
    "500"
  end

  def render("error.json", %{message: message}) do
    %{message: message}
  end
end
