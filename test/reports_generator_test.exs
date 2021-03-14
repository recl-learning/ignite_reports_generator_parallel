defmodule ReportsGeneratorTest do
  use ExUnit.Case
  doctest ReportsGenerator

  describe "generate_report_parallel/1" do
    test "should generate a report based on a csv file in parallel" do
      filenames = ["test_1.csv", "test_2.csv", "test_3.csv"]
      result = ReportsGenerator.generate_report_parallel(filenames)

      expected = %{
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

      assert result == expected
    end

    test "should have the same result as generate_report/1" do
      filenames = ["part_1.csv", "part_2.csv", "part_3.csv"]
      filename = "gen_report.csv"
      parallel = ReportsGenerator.generate_report_parallel(filenames)
      single = ReportsGenerator.generate_report(filename)

      assert parallel == single
    end
  end
end
