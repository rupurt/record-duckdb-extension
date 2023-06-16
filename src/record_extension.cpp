#define DUCKDB_EXTENSION_MAIN

#include "record_extension.hpp"
#include "record_analyze.hpp"
#include "record_detect.hpp"
#include "record_scan.hpp"
#include "record_write.hpp"

#include "duckdb.hpp"

#include "duckdb/common/exception.hpp"
#include "duckdb/common/string_util.hpp"
#include "duckdb/function/scalar_function.hpp"
#include "duckdb/function/table_function.hpp"
#include "duckdb/main/extension_util.hpp"

#include "duckdb/parser/parsed_data/create_table_function_info.hpp"
#include <duckdb/parser/parsed_data/create_scalar_function_info.hpp>

namespace duckdb {
static void LoadInternal(DatabaseInstance &instance) {
  auto record_detect_scalar_function =
      ScalarFunction("record_detect", {LogicalType::VARCHAR},
                     LogicalType::VARCHAR, RecordDetectScalarFun);
  ExtensionUtil::RegisterFunction(instance, record_detect_scalar_function);

  auto record_scan_scalar_function =
      ScalarFunction("record_scan", {LogicalType::VARCHAR},
                     LogicalType::VARCHAR, RecordScanScalarFun);
  ExtensionUtil::RegisterFunction(instance, record_scan_scalar_function);

  auto record_write_scalar_function =
      ScalarFunction("record_write", {LogicalType::VARCHAR},
                     LogicalType::VARCHAR, RecordWriteScalarFun);
  ExtensionUtil::RegisterFunction(instance, record_write_scalar_function);

  // table functions
  Connection con(instance);
  con.BeginTransaction();
  auto &context = *con.context;
  auto &catalog = Catalog::GetSystemCatalog(context);

  RecordAnalyzeFunction record_analyze_fun;
  CreateTableFunctionInfo record_analyze_info(record_analyze_fun);
  catalog.CreateTableFunction(context, record_analyze_info);

  con.Commit();
}

void RecordExtension::Load(DuckDB &db) { LoadInternal(*db.instance); }
std::string RecordExtension::Name() { return "record"; }
} // namespace duckdb

extern "C" {
DUCKDB_EXTENSION_API void record_init(duckdb::DatabaseInstance &db) {
  LoadInternal(db);
}

DUCKDB_EXTENSION_API const char *record_version() {
  return duckdb::DuckDB::LibraryVersion();
}
}

#ifndef DUCKDB_EXTENSION_MAIN
#error DUCKDB_EXTENSION_MAIN not defined
#endif
