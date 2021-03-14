defmodule ReportsGenerator do
  @moduledoc """
  A report generator for work hours reports.
  """

  alias ReportsGenerator.Parser

  @months %{
    "1" => "janeiro",
    "2" => "fevereiro",
    "3" => "março",
    "4" => "abril",
    "5" => "maio",
    "6" => "junho",
    "7" => "julho",
    "8" => "agosto",
    "9" => "setembro",
    "10" => "outubro",
    "11" => "novembro",
    "12" => "dezembro"
  }

  @doc """
  Generates a report of work hours by adding all hours, hours by month and hours by year.
  Uses a csv file as a data source.

  ## Examples

      iex> ReportsGenerator.generate_report_parallel(["test_1.csv", "test_2.csv", "test_3.csv"])
      %{
        "all_hours" => %{
          "Cleiton" => 3,
          "Daniele" => 15,
          "Giuliano" => 27,
          "Jakeliny" => 24,
          "Joseph" => 9,
          "Mayk" => 15
        },
        "hours_per_month" => %{
          "Cleiton" => %{"junho" => 3},
          "Daniele" => %{"dezembro" => 15},
          "Giuliano" => %{"fevereiro" => 27},
          "Jakeliny" => %{"julho" => 24},
          "Joseph" => %{"março" => 9},
          "Mayk" => %{"dezembro" => 15}
        },
        "hours_per_year" => %{
          "Cleiton" => %{"2020" => 3},
          "Daniele" => %{"2016" => 15},
          "Giuliano" => %{"2017" => 9, "2019" => 18},
          "Jakeliny" => %{"2017" => 24},
          "Joseph" => %{"2017" => 9},
          "Mayk" => %{"2017" => 3, "2019" => 12}
        }
      }
  """
  def generate_report_parallel(filenames) do
    filenames
    |> Task.async_stream(&generate_report(&1))
    |> Enum.reduce(%{}, fn {:ok, report}, acc -> merge(report, acc) end)
  end

  def generate_report(filename) do
    Parser.parse_file(filename)
    |> Stream.map(fn line -> make_report(line) end)
    |> Enum.reduce(%{}, fn report, acc -> merge(report, acc) end)
  end

  def generate_report_parallel_lines(filename) do
    Parser.parse_file(filename)
    |> Task.async_stream(fn line -> make_report(line) end)
    |> Enum.reduce(%{}, fn {:ok, report}, acc -> merge(report, acc) end)
  end

  defp merge(left, right) when is_map(left) do
    Map.merge(left, right, fn _key, left_val, right_val -> merge(left_val, right_val) end)
  end

  defp merge(left, right), do: left + right

  defp make_report([name, hours, _day_of_month, month_of_year, year]) do
    month_name = Map.get(@months, month_of_year)

    hours = String.to_integer(hours)

    %{
      "all_hours" => %{
        name => hours
      },
      "hours_per_month" => %{
        name => %{
          month_name => hours
        }
      },
      "hours_per_year" => %{
        name => %{
          year => hours
        }
      }
    }
  end
end
