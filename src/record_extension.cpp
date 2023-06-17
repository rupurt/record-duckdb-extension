#define DUCKDB_EXTENSION_MAIN

#include "record_extension.hpp"

#include "duckdb.hpp"
#include "record_reader.hpp"

#include "duckdb/common/exception.hpp"
#include "duckdb/common/multi_file_reader.hpp"
#include "duckdb/common/string_util.hpp"
#include "duckdb/function/scalar_function.hpp"
#include "duckdb/function/table_function.hpp"
#include "duckdb/main/extension_util.hpp"

#include <duckdb/parser/parsed_data/create_scalar_function_info.hpp>

namespace duckdb {

// struct RecordBindData : public FunctionData {
//   ~RecordBindData() {
//     // if (conn) {
//     //   PQfinish(conn);
//     //   conn = nullptr;
//     // }
//   }
//
//   // string schema_name;
//   // string table_name;
//   // idx_t pages_approx = 0;
//   //
//   // vector<PostgresColumnInfo> columns;
//   // vector<string> names;
//   // vector<LogicalType> types;
//   // vector<bool> needs_cast;
//   //
//   // idx_t pages_per_task = 1000;
//   // string dsn;
//   //
//   // string snapshot;
//   // bool in_recovery;
//   //
//   // PGconn *conn = nullptr;
//
// public:
//   unique_ptr<FunctionData> Copy() const override {
//     throw NotImplementedException("");
//   }
//   bool Equals(const FunctionData &other) const override {
//     throw NotImplementedException("");
//   }
// };

// class RecordAnalyzeFunction {
// public:
//   static TableFunctionSet GetFunctionSet() {
//     TableFunction table_function("parquet_scan", {LogicalType::VARCHAR},
//                                  RecordAnalyzeImplementation,
//                                  RecordAnalyzeBind, RecordAnalyzeInitGlobal,
//                                  RecordAnalyzeInitLocal);
//     // table_function.statistics = ParquetScanStats;
//     // table_function.cardinality = ParquetCardinality;
//     // table_function.table_scan_progress = ParquetProgress;
//     // table_function.named_parameters["binary_as_string"] =
//     // LogicalType::BOOLEAN;
//     table_function.named_parameters["file_row_number"]
//     // = LogicalType::BOOLEAN; table_function.named_parameters["compression"]
//     =
//     // LogicalType::VARCHAR;
//     MultiFileReader::AddParameters(table_function);
//     // table_function.get_batch_index = ParquetScanGetBatchIndex;
//     // table_function.serialize = ParquetScanSerialize;
//     // table_function.deserialize = ParquetScanDeserialize;
//     // table_function.get_batch_info = ParquetGetBatchInfo;
//     //
//     // table_function.projection_pushdown = true;
//     // table_function.filter_pushdown = true;
//     // table_function.filter_prune = true;
//     // table_function.pushdown_complex_filter = ParquetComplexFilterPushdown;
//     return MultiFileReader::CreateFunctionSet(table_function);
//   }
//
//   static void RecordAnalyzeImplementation(ClientContext &context,
//                                         TableFunctionInput &data_p,
//                                         DataChunk &output) {
//     return;
//   }
//
//   static unique_ptr<FunctionData>
//   RecordAnalyzeBind(ClientContext &context, TableFunctionBindInput &input,
//                   vector<LogicalType> &return_types, vector<string> &names) {
//     auto files =
//         MultiFileReader::GetFileList(context, input.inputs[0], "Parquet");
//     // ParquetOptions parquet_options(context);
//     // for (auto &kv : input.named_parameters) {
//     //   auto loption = StringUtil::Lower(kv.first);
//     //   if (MultiFileReader::ParseOption(kv.first, kv.second,
//     //                                    parquet_options.file_options)) {
//     //     continue;
//     //   }
//     //   if (loption == "binary_as_string") {
//     //     parquet_options.binary_as_string = BooleanValue::Get(kv.second);
//     //   } else if (loption == "file_row_number") {
//     //     parquet_options.file_row_number = BooleanValue::Get(kv.second);
//     //   }
//     // }
//     // if (parquet_options.file_options.auto_detect_hive_partitioning) {
//     //   parquet_options.file_options.hive_partitioning =
//     //       MultiFileReaderOptions::AutoDetectHivePartitioning(files);
//     // }
//     return ParquetScanBindInternal(context, std::move(files), return_types,
//                                    names, parquet_options);
//   }
//
//   static unique_ptr<GlobalTableFunctionState>
//   RecordAnalyzeInitGlobal(ClientContext &context, TableFunctionInitInput
//   &input) {
//     auto &bind_data = input.bind_data->CastNoConst<ParquetReadBindData>();
//     auto result = make_uniq<ParquetReadGlobalState>();
//
//     result->file_opening = vector<bool>(bind_data.files.size(), false);
//     result->file_mutexes =
//         unique_ptr<mutex[]>(new mutex[bind_data.files.size()]);
//     if (bind_data.files.empty()) {
//       result->initial_reader = nullptr;
//     } else {
//       result->readers = std::move(bind_data.union_readers);
//       if (result->readers.size() != bind_data.files.size()) {
//         result->readers =
//             vector<shared_ptr<ParquetReader>>(bind_data.files.size(),
//             nullptr);
//       }
//       if (bind_data.initial_reader) {
//         result->initial_reader = std::move(bind_data.initial_reader);
//         result->readers[0] = result->initial_reader;
//       } else if (result->readers[0]) {
//         result->initial_reader = result->readers[0];
//       } else {
//         result->initial_reader = make_shared<ParquetReader>(
//             context, bind_data.files[0], bind_data.parquet_options);
//         result->readers[0] = result->initial_reader;
//       }
//     }
//     for (auto &reader : result->readers) {
//       if (!reader) {
//         continue;
//       }
//       MultiFileReader::InitializeReader(
//           *reader, bind_data.parquet_options.file_options,
//           bind_data.reader_bind, bind_data.types, bind_data.names,
//           input.column_ids, input.filters, bind_data.files[0]);
//     }
//
//     result->column_ids = input.column_ids;
//     result->filters = input.filters.get();
//     result->row_group_index = 0;
//     result->file_index = 0;
//     result->batch_index = 0;
//     result->max_threads = ParquetScanMaxThreads(context,
//     input.bind_data.get()); if (input.CanRemoveFilterColumns()) {
//       result->projection_ids = input.projection_ids;
//       const auto table_types = bind_data.types;
//       for (const auto &col_idx : input.column_ids) {
//         if (IsRowIdColumnId(col_idx)) {
//           result->scanned_types.emplace_back(LogicalType::ROW_TYPE);
//         } else {
//           result->scanned_types.push_back(table_types[col_idx]);
//         }
//       }
//     }
//     return std::move(result);
//   }
//
//   static unique_ptr<LocalTableFunctionState>
//   RecordAnalyzeInitLocal(ExecutionContext &context, TableFunctionInitInput
//   &input,
//                        GlobalTableFunctionState *gstate_p) {
//     auto &bind_data = input.bind_data->Cast<ParquetReadBindData>();
//     auto &gstate = gstate_p->Cast<ParquetReadGlobalState>();
//
//     auto result = make_uniq<ParquetReadLocalState>();
//     result->is_parallel = true;
//     result->batch_index = 0;
//     if (input.CanRemoveFilterColumns()) {
//       result->all_columns.Initialize(context.client, gstate.scanned_types);
//     }
//     if (!ParquetParallelStateNext(context.client, bind_data, *result,
//     gstate)) {
//       return nullptr;
//     }
//     return std::move(result);
//   }
// };

inline void RecordDetectScalarFun(DataChunk &args, ExpressionState &state,
                                  Vector &result) {
  auto &name_vector = args.data[0];
  UnaryExecutor::Execute<string_t, string_t>(
      name_vector, result, args.size(), [&](string_t name) {
        return StringVector::AddString(result, "TODO: record_detect " +
                                                   name.GetString() + " 🐥");
        ;
      });
}

inline void RecordScanScalarFun(DataChunk &args, ExpressionState &state,
                                Vector &result) {
  auto &name_vector = args.data[0];
  UnaryExecutor::Execute<string_t, string_t>(
      name_vector, result, args.size(), [&](string_t name) {
        return StringVector::AddString(result, "TODO: record_scan " +
                                                   name.GetString() + " 🐥");
        ;
      });
}

inline void RecordWriteScalarFun(DataChunk &args, ExpressionState &state,
                                 Vector &result) {
  auto &name_vector = args.data[0];
  UnaryExecutor::Execute<string_t, string_t>(
      name_vector, result, args.size(), [&](string_t name) {
        return StringVector::AddString(result, "TODO: record_write " +
                                                   name.GetString() + " 🐥");
        ;
      });
}

static void LoadInternal(DatabaseInstance &instance) {
  // auto analyze_fun = RecordAnalyzeFunction::GetFunctionSet();
  // analyze_fun.name = "analyze_record";

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
