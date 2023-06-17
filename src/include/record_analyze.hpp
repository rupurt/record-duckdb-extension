#pragma once

#include "duckdb.hpp"

#include "duckdb/function/table_function.hpp"

namespace duckdb {
struct PostgresTypeInfo {
  string typname;
  int64_t typlen;
  string typtype;
  string nspname;
};

struct PostgresColumnInfo {
  string attname;
  int atttypmod;
  PostgresTypeInfo type_info;
  int64_t typelem; // OID pointer for arrays
  PostgresTypeInfo elem_info;
};

struct RecordAnalyzeBindData : public FunctionData {
  vector<PostgresColumnInfo> columns;
  vector<string> names;
  vector<LogicalType> types;
  vector<bool> needs_cast;

public:
  unique_ptr<FunctionData> Copy() const override {
    throw NotImplementedException("");
  }
  bool Equals(const FunctionData &other) const override {
    throw NotImplementedException("");
  }
};

struct RecordAnalyzeLocalState : public LocalTableFunctionState {
  RecordAnalyzeLocalState() : offset(0) {}

  idx_t offset;
};

struct RecordAnalyzeGlobalState : public GlobalTableFunctionState {
  RecordAnalyzeGlobalState(idx_t max_threads)
      : page_idx(0), max_threads(max_threads) {}

  mutex lock;
  idx_t page_idx;
  idx_t max_threads;

  idx_t MaxThreads() const override { return max_threads; }
};

static idx_t PostgresMaxThreads(ClientContext &context,
                                const FunctionData *bind_data_p) {
  D_ASSERT(bind_data_p);

  auto bind_data = (const RecordAnalyzeBindData *)bind_data_p;
  // return bind_data->pages_approx / bind_data->pages_per_task;
  return 1;
}

class RecordAnalyzeFunction : public TableFunction {
public:
  RecordAnalyzeFunction();

  static void RecordAnalyze(ClientContext &context, TableFunctionInput &data,
                            DataChunk &output) {
    auto &local_state = data.local_state->Cast<RecordAnalyzeLocalState>();

    if (local_state.offset >= 1) {
      // finished returning values
      return;
    }

    // TODO:
    // - handle STANDARD_VECTOR_SIZE
    local_state.offset++;
    idx_t col_idx = 0;
    idx_t vector_idx = 0;
    output.SetValue(col_idx, vector_idx, Value("Hello!"));
    vector_idx++;

    output.SetCardinality(vector_idx);
  }

  static unique_ptr<FunctionData>
  RecordAnalyzeBind(ClientContext &context, TableFunctionBindInput &input,
                    vector<LogicalType> &return_types, vector<string> &names) {
    auto bind_data = make_uniq<RecordAnalyzeBindData>();

    PostgresColumnInfo info;
    // info.attname = res->GetString(row, 0);
    info.attname = "Attr 1";
    // info.atttypmod = res->GetInt32(row, 1);
    info.atttypmod = 1;

    bind_data->names.push_back(info.attname);
    auto duckdb_type = LogicalType::VARCHAR;
    // we cast unsupported types to varchar on read
    auto needs_cast = duckdb_type == LogicalType::INVALID;
    bind_data->needs_cast.push_back(needs_cast);
    if (!needs_cast) {
      bind_data->types.push_back(std::move(duckdb_type));
    } else {
      bind_data->types.push_back(LogicalType::VARCHAR);
    }

    bind_data->columns.push_back(info);

    return_types = bind_data->types;
    names = bind_data->names;

    return std::move(bind_data);
  }

  static unique_ptr<GlobalTableFunctionState>
  RecordAnalyzeInitGlobalState(ClientContext &context,
                               TableFunctionInitInput &input) {
    return make_uniq<RecordAnalyzeGlobalState>(
        PostgresMaxThreads(context, input.bind_data.get()));
  }

  static unique_ptr<LocalTableFunctionState>
  RecordAnalyzeInitLocalState(ExecutionContext &context,
                              TableFunctionInitInput &input,
                              GlobalTableFunctionState *global_state) {
    auto local_state = make_uniq<RecordAnalyzeLocalState>();
    return std::move(local_state);
  }
};
} // namespace duckdb
