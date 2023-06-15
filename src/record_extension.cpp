#define DUCKDB_EXTENSION_MAIN

#include "record_extension.hpp"
#include "duckdb.hpp"
#include "duckdb/common/exception.hpp"
#include "duckdb/common/string_util.hpp"
#include "duckdb/function/scalar_function.hpp"
#include "duckdb/main/extension_util.hpp"

#include <duckdb/parser/parsed_data/create_scalar_function_info.hpp>

namespace duckdb {

inline void ReadRecordScalarFun(DataChunk &args, ExpressionState &state,
                                Vector &result) {
  auto &name_vector = args.data[0];
  UnaryExecutor::Execute<string_t, string_t>(
      name_vector, result, args.size(), [&](string_t name) {
        return StringVector::AddString(result, "TODO: read_record " +
                                                   name.GetString() + " 🐥");
        ;
      });
}

inline void WriteRecordScalarFun(DataChunk &args, ExpressionState &state,
                                 Vector &result) {
  auto &name_vector = args.data[0];
  UnaryExecutor::Execute<string_t, string_t>(
      name_vector, result, args.size(), [&](string_t name) {
        return StringVector::AddString(result, "TODO: write_record " +
                                                   name.GetString() + " 🐥");
        ;
      });
}

inline void DetectRecordScalarFun(DataChunk &args, ExpressionState &state,
                                  Vector &result) {
  auto &name_vector = args.data[0];
  UnaryExecutor::Execute<string_t, string_t>(
      name_vector, result, args.size(), [&](string_t name) {
        return StringVector::AddString(result, "TODO: detect_record " +
                                                   name.GetString() + " 🐥");
        ;
      });
}

static void LoadInternal(DatabaseInstance &instance) {
  auto read_record_scalar_function =
      ScalarFunction("read_record", {LogicalType::VARCHAR},
                     LogicalType::VARCHAR, ReadRecordScalarFun);
  ExtensionUtil::RegisterFunction(instance, read_record_scalar_function);

  auto write_record_scalar_function =
      ScalarFunction("write_record", {LogicalType::VARCHAR},
                     LogicalType::VARCHAR, WriteRecordScalarFun);
  ExtensionUtil::RegisterFunction(instance, write_record_scalar_function);

  auto detect_record_scalar_function =
      ScalarFunction("detect_record", {LogicalType::VARCHAR},
                     LogicalType::VARCHAR, DetectRecordScalarFun);
  ExtensionUtil::RegisterFunction(instance, detect_record_scalar_function);
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
