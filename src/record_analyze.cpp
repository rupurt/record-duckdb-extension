#include "record_analyze.hpp"

#include "duckdb.hpp"

#include "duckdb/function/table_function.hpp"

namespace duckdb {
  RecordAnalyzeFunction::RecordAnalyzeFunction()
      : TableFunction(
            "record_analyze",
            {LogicalType::VARCHAR, LogicalType::VARCHAR, LogicalType::VARCHAR},
            RecordAnalyze, RecordAnalyzeBind, RecordAnalyzeInitGlobalState,
            RecordAnalyzeInitLocalState) {
    // to_string = PostgresScanToString;
    // projection_pushdown = true;
  }
} // namespace duckdb
