#define DUCKDB_EXTENSION_MAIN

#include "read_record_extension.hpp"
#include "duckdb.hpp"
#include "duckdb/common/exception.hpp"
#include "duckdb/common/string_util.hpp"
#include "duckdb/function/scalar_function.hpp"
#include "duckdb/main/extension_util.hpp"


#include <duckdb/parser/parsed_data/create_scalar_function_info.hpp>

namespace duckdb {

inline void Read_recordScalarFun(DataChunk &args, ExpressionState &state, Vector &result) {
    auto &name_vector = args.data[0];
    UnaryExecutor::Execute<string_t, string_t>(
	    name_vector, result, args.size(),
	    [&](string_t name) {
			return StringVector::AddString(result, "Read_record "+name.GetString()+" 🐥");;
        });
}

static void LoadInternal(DatabaseInstance &instance) {
    auto read_record_scalar_function = ScalarFunction("read_record", {LogicalType::VARCHAR},
        LogicalType::VARCHAR, Read_recordScalarFun);
    ExtensionUtil::RegisterFunction(instance, read_record_scalar_function);
}

void Read_recordExtension::Load(DuckDB &db) {
	LoadInternal(*db.instance);
}
std::string Read_recordExtension::Name() {
	return "read_record";
}

} // namespace duckdb

extern "C" {

DUCKDB_EXTENSION_API void read_record_init(duckdb::DatabaseInstance &db) {
	LoadInternal(db);
}

DUCKDB_EXTENSION_API const char *read_record_version() {
	return duckdb::DuckDB::LibraryVersion();
}
}

#ifndef DUCKDB_EXTENSION_MAIN
#error DUCKDB_EXTENSION_MAIN not defined
#endif
