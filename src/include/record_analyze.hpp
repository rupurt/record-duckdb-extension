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
  ~RecordAnalyzeBindData() {
    // if (conn) {
    //   PQfinish(conn);
    //   conn = nullptr;
    // }
  }

  // string schema_name;
  // string table_name;
  // idx_t pages_approx = 0;
  //
  vector<PostgresColumnInfo> columns;
  vector<string> names;
  vector<LogicalType> types;
  vector<bool> needs_cast;
  //
  // idx_t pages_per_task = 1000;
  // string dsn;
  //
  // string snapshot;
  // bool in_recovery;
  //
  // PGconn *conn = nullptr;

public:
  unique_ptr<FunctionData> Copy() const override {
    throw NotImplementedException("");
  }
  bool Equals(const FunctionData &other) const override {
    throw NotImplementedException("");
  }
};

struct RecordAnalyzeLocalState : public LocalTableFunctionState {
  ~RecordAnalyzeLocalState() {
    // if (conn) {
    // 	PQfinish(conn);
    // 	conn = nullptr;
    // }
  }

  // bool done = false;
  // bool exec = false;
  // string sql;
  // vector<column_t> column_ids;
  // TableFilterSet *filters;
  // string col_names;
  // PGconn *conn = nullptr;
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
  RecordAnalyzeFunction()
      : TableFunction(
            "record_analyze",
            {LogicalType::VARCHAR, LogicalType::VARCHAR, LogicalType::VARCHAR},
            PostgresScan, RecordAnalyzeBind, RecordAnalyzeInitGlobalState,
            RecordAnalyzeInitLocalState) {
    // to_string = PostgresScanToString;
    // projection_pushdown = true;
  }

  static void PostgresScan(ClientContext &context, TableFunctionInput &data,
                           DataChunk &output) {
    // auto &bind_data = data.bind_data->Cast<PostgresBindData>();
    // auto &local_state = data.local_state->Cast<PostgresLocalState>();
    // auto &gstate = data.global_state->Cast<PostgresGlobalState>();
    //
    // idx_t output_offset = 0;
    // PostgresBinaryBuffer buf(local_state.conn);
    //
    // while (true) {
    // 	if (local_state.done && !PostgresParallelStateNext(context,
    // data.bind_data.get(), local_state, gstate)) {
    // 		return;
    // 	}
    //
    // 	if (!local_state.exec) {
    // 		PGQuery(local_state.conn, local_state.sql,
    // PGRES_COPY_OUT);
    // 		local_state.exec = true;
    // 		buf.Next();
    // 		buf.CheckHeader();
    // 		// the first tuple immediately follows the header in the
    // first message, so
    // 		// we have to keep the buffer alive for now.
    // 	}
    //
    // 	output.SetCardinality(output_offset);
    // 	if (output_offset == STANDARD_VECTOR_SIZE) {
    // 		return;
    // 	}
    //
    // 	if (!buf.Ready()) {
    // 		buf.Next();
    // 	}
    //
    // 	auto tuple_count = (int16_t)ntohs(buf.Read<uint16_t>());
    // 	if (tuple_count == -1) { // done here, lets try to get more
    // 		local_state.done = true;
    // 		continue;
    // 	}
    //
    // 	D_ASSERT(tuple_count == local_state.column_ids.size());
    //
    // 	for (idx_t output_idx = 0; output_idx < output.ColumnCount();
    // output_idx++) {
    // 		auto col_idx = local_state.column_ids[output_idx];
    // 		auto &out_vec = output.data[output_idx];
    // 		auto raw_len = (int32_t)ntohl(buf.Read<uint32_t>());
    // 		if (raw_len == -1) { // NULL
    // 			FlatVector::Validity(out_vec).Set(output_offset,
    // false);
    // 			continue;
    // 		}
    // 		ProcessValue(bind_data.types[col_idx],
    // &bind_data.columns[col_idx].type_info,
    // 		             bind_data.columns[col_idx].atttypmod,
    // bind_data.columns[col_idx].typelem,
    // 		             &bind_data.columns[col_idx].elem_info,
    // (data_ptr_t)buf.buffer_ptr, raw_len, out_vec,
    // 		             output_offset);
    // 		buf.buffer_ptr += raw_len;
    // 	}
    //
    // 	buf.Reset();
    // 	output_offset++;
  }

  static unique_ptr<FunctionData>
  RecordAnalyzeBind(ClientContext &context, TableFunctionBindInput &input,
                    vector<LogicalType> &return_types, vector<string> &names) {
    auto bind_data = make_uniq<RecordAnalyzeBindData>();
    //
    //     bind_data->dsn = input.inputs[0].GetValue<string>();
    //     bind_data->schema_name = input.inputs[1].GetValue<string>();
    //     bind_data->table_name = input.inputs[2].GetValue<string>();
    //
    //     bind_data->conn = PGConnect(bind_data->dsn);
    //
    //     // we create a transaction here, and get the snapshot id so the
    //     parallel
    //     // reader threads can use the same snapshot
    //     PGExec(bind_data->conn,
    //            "BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ READ
    //            ONLY");
    //
    //     bind_data->in_recovery =
    //         (bool)PGQuery(bind_data->conn, "SELECT pg_is_in_recovery()")
    //             ->GetBool(0, 0);
    //     bind_data->snapshot = "";
    //
    //     if (!bind_data->in_recovery) {
    //       bind_data->snapshot =
    //           PGQuery(bind_data->conn, "SELECT pg_export_snapshot()")
    //               ->GetString(0, 0);
    //     }
    //
    //     // find the id of the table in question to simplify below queries and
    //     avoid
    //     // complex joins (ha)
    //     auto res =
    //         PGQuery(bind_data->conn, StringUtil::Format(R"(
    // SELECT pg_class.oid, GREATEST(relpages, 1)
    // FROM pg_class JOIN pg_namespace ON relnamespace = pg_namespace.oid
    // WHERE nspname='%s' AND relname='%s'
    // )",
    //                                                     bind_data->schema_name,
    //                                                     bind_data->table_name));
    //     if (res->Count() != 1) {
    //       throw InvalidInputException("Postgres table \"%s\".\"%s\" not
    //       found",
    //                                   bind_data->schema_name,
    //                                   bind_data->table_name);
    //     }
    //     auto oid = res->GetInt64(0, 0);
    //     bind_data->pages_approx = res->GetInt64(0, 1);
    //
    //     res.reset();
    //
    //     // query the table schema so we can interpret the bits in the pages
    //     // fun fact: this query also works in DuckDB ^^
    //     res = PGQuery(bind_data->conn, StringUtil::Format(
    //                                        R"(
    // SELECT
    //     attname, atttypmod, pg_namespace.nspname,
    //     pg_type.typname, pg_type.typlen, pg_type.typtype, pg_type.typelem,
    //     pg_type_elem.typname elem_typname, pg_type_elem.typlen elem_typlen,
    //     pg_type_elem.typtype elem_typtype
    // FROM pg_attribute
    //     JOIN pg_type ON atttypid=pg_type.oid
    //     LEFT JOIN pg_type pg_type_elem ON pg_type.typelem=pg_type_elem.oid
    //     LEFT JOIN pg_namespace ON pg_type.typnamespace = pg_namespace.oid
    // WHERE attrelid=%d AND attnum > 0
    // ORDER BY attnum;
    // )",
    //                                        oid));
    //
    //     // can't scan a table without columns (yes those exist)
    //     if (res->Count() == 0) {
    //       throw InvalidInputException("Table %s does not contain any
    //       columns.",
    //                                   bind_data->table_name);
    //     }
    //
    //     for (idx_t row = 0; row < res->Count(); row++) {
    //       PostgresColumnInfo info;
    //       info.attname = res->GetString(row, 0);
    //       info.atttypmod = res->GetInt32(row, 1);
    //
    //       info.type_info.nspname = res->GetString(row, 2);
    //       info.type_info.typname = res->GetString(row, 3);
    //       info.type_info.typlen = res->GetInt64(row, 4);
    //       info.type_info.typtype = res->GetString(row, 5);
    //       info.typelem = res->GetInt64(row, 6);
    //
    //       info.elem_info.nspname = res->GetString(row, 2);
    //       info.elem_info.typname = res->GetString(row, 7);
    //       info.elem_info.typlen = res->GetInt64(row, 8);
    //       info.elem_info.typtype = res->GetString(row, 9);
    //
    //       bind_data->names.push_back(info.attname);
    //       auto duckdb_type = DuckDBType(info, bind_data->conn, context);
    //       // we cast unsupported types to varchar on read
    //       auto needs_cast = duckdb_type == LogicalType::INVALID;
    //       bind_data->needs_cast.push_back(needs_cast);
    //       if (!needs_cast) {
    //         bind_data->types.push_back(std::move(duckdb_type));
    //       } else {
    //         bind_data->types.push_back(LogicalType::VARCHAR);
    //       }
    //
    //       bind_data->columns.push_back(info);
    //     }
    //     res.reset();
    //
    //     return_types = bind_data->types;
    //     names = bind_data->names;
    //
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
    auto &bind_data = input.bind_data->Cast<RecordAnalyzeBindData>();
    // auto &gstate = global_state->Cast<PostgresGlobalState>();
    //
    auto local_state = make_uniq<RecordAnalyzeLocalState>();
    // local_state->column_ids = input.column_ids;
    // local_state->conn = PostgresScanConnect(
    //     bind_data.dsn, bind_data.in_recovery, bind_data.snapshot);
    // local_state->filters = input.filters.get();
    // if (!PostgresParallelStateNext(context.client, input.bind_data.get(),
    //                                *local_state, gstate)) {
    //   local_state->done = true;
    // }
    return std::move(local_state);
  }
};
} // namespace duckdb
