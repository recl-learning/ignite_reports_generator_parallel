Benchee.run(%{
  parallel: fn -> ReportsGenerator.generate_report_parallel(["part_1.csv", "part_2.csv", "part_3.csv"]) end,
  single: fn -> ReportsGenerator.generate_report("gen_report.csv") end,
  each_line_in_parallel: fn -> ReportsGenerator.generate_report_parallel_lines("gen_report.csv") end
})