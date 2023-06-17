#pragma once

#include "duckdb.hpp"
#include "duckdb/common/multi_file_reader_options.hpp"

namespace record {} // namespace record

namespace duckdb {
class ClientContext;

struct RecordOptions {
  explicit RecordOptions() {}
  explicit RecordOptions(ClientContext &context);

  bool binary_as_string = false;
  bool file_row_number = false;
  MultiFileReaderOptions file_options;

public:
  void Serialize(FieldWriter &writer) const;
  void Deserialize(FieldReader &reader);
};
} // namespace duckdb
