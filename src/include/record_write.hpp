#pragma once

#include "duckdb.hpp"

namespace duckdb {
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
} // namespace duckdb
