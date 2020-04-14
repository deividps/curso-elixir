defmodule FriendsApp.CLI.MenuChoice do
  alias Mix.Shell.IO, as: Shell
  alias FriendsApp.CLI.MenuItens

  def start do
    Shell.cmd("cls")
    Shell.info("Escolha uma opcao:")

    menu_itens = FriendsApp.CLI.MenuItens.all()
    find_menu_item_by_index = &Enum.at(menu_itens, &1, :error)

    menu_itens
    |> Enum.map(& &1.label)
    |> display_options()
    |> generate_question()
    |> Shell.prompt
    |> parse_answer()
    |> find_menu_item_by_index.()
    |> confirm_menu_item()
    |> confirm_message()
  end

  def display_options(options) do
    options
    |> Enum.with_index(1)
    |> Enum.each(fn {option, index} ->
      Shell.info("#{index} - #{option}")
    end)

    options
  end

  defp generate_question(options) do
    options = Enum.join(1..Enum.count(options), ",")
    "Qual das opcoes acima voce escolhe? [#{options}]\n"
  end

  defp parse_answer(answer) do
    case Integer.parse(answer) do
      :error -> invalid_option()
      {option, _} -> option - 1
    end
  end

  defp invalid_option do
    Shell.cmd("cls")
    Shell.error("Opcao invalida")
    Shell.prompt("Pressione ENTER para tentar novamente")
    start()
  end  

  defp confirm_menu_item(chosen_menu_item) do
    case chosen_menu_item do
     :error -> invalid_option()
     _ -> chosen_menu_item
    end
  end
  
  defp confirm_message(chosen_menu_item) do
      Shell.cmd("clear")
      Shell.info("Você escolheu... [#{chosen_menu_item.label}]")
    case Shell.yes?("Confirma?") do
      true -> Shell.info("... #{chosen_menu_item.label} ...")
      false -> start()
    end
  end


end
