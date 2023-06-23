const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // ==============================
    // Build Options
    // ==============================
    const want_openssl_include_dir = b.option([]const u8, "openssl-include-dir", "Path to openssl include headers") orelse "/usr/include/openssl";
    const want_build_shell = b.option(bool, "build-shell", "Build the DuckDB client shell") orelse true;
    std.debug.print("build.zig options:\n", .{});
    std.debug.print("- openssl-include-dir={s}\n", .{want_openssl_include_dir});
    std.debug.print("- build-shell={}\n", .{want_build_shell});

    // ==============================
    // Third Party
    // ==============================
    const duckdb_fsst = b.addStaticLibrary(.{
        .name = "duckdb_fsst",
        .target = target,
        .optimize = optimize,
    });
    duckdb_fsst.addCSourceFiles(&.{
        "duckdb/third_party/fsst/libfsst.cpp",
        "duckdb/third_party/fsst/fsst_avx512.cpp",
        // TODO:
        // - Not sure how to include these for compilation with zig build ...
        // "duckdb/third_party/fsst/fsst_avx512_unroll1.inc",
        // "duckdb/third_party/fsst/fsst_avx512_unroll2.inc",
        // "duckdb/third_party/fsst/fsst_avx512_unroll3.inc",
        // "duckdb/third_party/fsst/fsst_avx512_unroll4.inc",
    }, &.{});
    duckdb_fsst.linkLibCpp();
    duckdb_fsst.force_pic = true;
    // duckdb_fsst.strip = true;
    b.installArtifact(duckdb_fsst);

    const duckdb_fmt = b.addStaticLibrary(.{
        .name = "duckdb_fmt",
        .target = target,
        .optimize = optimize,
    });
    duckdb_fmt.addCSourceFiles(&.{
        "duckdb/third_party/fmt/format.cc",
    }, &.{});
    duckdb_fmt.addIncludePath("duckdb/third_party/fmt/include");
    duckdb_fmt.addIncludePath("duckdb/src/include");
    duckdb_fmt.linkLibCpp();
    duckdb_fmt.force_pic = true;
    // duckdb_fmt.strip = true;
    b.installArtifact(duckdb_fmt);

    const duckdb_pg_query = b.addStaticLibrary(.{
        .name = "duckdb_pg_query",
        .target = target,
        .optimize = optimize,
    });
    duckdb_pg_query.addCSourceFiles(&.{
        "duckdb/third_party/libpg_query/pg_functions.cpp",
        "duckdb/third_party/libpg_query/postgres_parser.cpp",
        "duckdb/third_party/libpg_query/src_backend_parser_gram.cpp",
        "duckdb/third_party/libpg_query/src_backend_parser_scan.cpp",
        "duckdb/third_party/libpg_query/src_backend_nodes_list.cpp",
        "duckdb/third_party/libpg_query/src_backend_nodes_makefuncs.cpp",
        "duckdb/third_party/libpg_query/src_backend_nodes_value.cpp",
        "duckdb/third_party/libpg_query/src_backend_parser_parser.cpp",
        "duckdb/third_party/libpg_query/src_backend_parser_scansup.cpp",
        "duckdb/third_party/libpg_query/src_common_keywords.cpp",
    }, &.{});
    duckdb_pg_query.addIncludePath("duckdb/third_party/libpg_query/include");
    duckdb_pg_query.addIncludePath("duckdb/src/include");
    duckdb_pg_query.linkLibCpp();
    duckdb_pg_query.force_pic = true;
    // duckdb_pg_query.strip = true;
    b.installArtifact(duckdb_pg_query);

    const duckdb_re2 = b.addStaticLibrary(.{
        .name = "duckdb_re2",
        .target = target,
        .optimize = optimize,
    });
    duckdb_re2.addCSourceFiles(&.{
        "duckdb/third_party/re2/re2/bitstate.cc",
        "duckdb/third_party/re2/re2/compile.cc",
        "duckdb/third_party/re2/re2/dfa.cc",
        "duckdb/third_party/re2/re2/filtered_re2.cc",
        "duckdb/third_party/re2/re2/mimics_pcre.cc",
        "duckdb/third_party/re2/re2/nfa.cc",
        "duckdb/third_party/re2/re2/onepass.cc",
        "duckdb/third_party/re2/re2/parse.cc",
        "duckdb/third_party/re2/re2/perl_groups.cc",
        "duckdb/third_party/re2/re2/prefilter.cc",
        "duckdb/third_party/re2/re2/prefilter_tree.cc",
        "duckdb/third_party/re2/re2/prog.cc",
        "duckdb/third_party/re2/re2/re2.cc",
        "duckdb/third_party/re2/re2/regexp.cc",
        "duckdb/third_party/re2/re2/set.cc",
        "duckdb/third_party/re2/re2/simplify.cc",
        "duckdb/third_party/re2/re2/stringpiece.cc",
        "duckdb/third_party/re2/re2/tostring.cc",
        "duckdb/third_party/re2/re2/unicode_casefold.cc",
        "duckdb/third_party/re2/re2/unicode_groups.cc",
        "duckdb/third_party/re2/util/rune.cc",
        "duckdb/third_party/re2/util/strutil.cc",
    }, &.{});
    duckdb_re2.addIncludePath("duckdb/third_party/re2");
    duckdb_re2.linkLibCpp();
    duckdb_re2.force_pic = true;
    // duckdb_re2.strip = true;
    b.installArtifact(duckdb_re2);

    const duckdb_miniz = b.addStaticLibrary(.{
        .name = "duckdb_miniz",
        .target = target,
        .optimize = optimize,
    });
    duckdb_miniz.addCSourceFiles(&.{
        "duckdb/third_party/miniz/miniz.cpp",
    }, &.{});
    duckdb_miniz.linkLibCpp();
    duckdb_miniz.force_pic = true;
    // duckdb_miniz.strip = true;
    b.installArtifact(duckdb_miniz);

    const duckdb_utf8proc = b.addStaticLibrary(.{
        .name = "duckdb_utf8proc",
        .target = target,
        .optimize = optimize,
    });
    duckdb_utf8proc.addCSourceFiles(&.{
        "duckdb/third_party/utf8proc/utf8proc.cpp",
        // This file doesn't compile due to undefined type utf8proc_uint16_t. It's not included in CMakeLists.txt.
        // "duckdb/third_party/utf8proc/utf8proc_data.cpp",
        "duckdb/third_party/utf8proc/utf8proc_wrapper.cpp",
    }, &.{});
    duckdb_utf8proc.addIncludePath("duckdb/third_party/utf8proc/include");
    duckdb_utf8proc.linkLibCpp();
    duckdb_utf8proc.force_pic = true;
    // duckdb_utf8proc.strip = true;
    b.installArtifact(duckdb_utf8proc);

    const duckdb_hyperloglog = b.addStaticLibrary(.{
        .name = "duckdb_hyperloglog",
        .target = target,
        .optimize = optimize,
    });
    duckdb_hyperloglog.addCSourceFiles(&.{
        "duckdb/third_party/hyperloglog/hyperloglog.cpp",
        "duckdb/third_party/hyperloglog/sds.cpp",
    }, &.{});
    duckdb_hyperloglog.addIncludePath("duckdb/src/include");
    duckdb_hyperloglog.linkLibCpp();
    duckdb_hyperloglog.force_pic = true;
    // duckdb_hyperloglog.strip = true;
    b.installArtifact(duckdb_hyperloglog);

    const duckdb_fastpforlib = b.addStaticLibrary(.{
        .name = "duckdb_fastpforlib",
        .target = target,
        .optimize = optimize,
    });
    duckdb_fastpforlib.addCSourceFiles(&.{
        "duckdb/third_party/fastpforlib/bitpacking.cpp",
    }, &.{});
    // duckdb_fastpforlib.addIncludePath("duckdb/third_party/fastpforlib");
    duckdb_fastpforlib.linkLibCpp();
    duckdb_fastpforlib.force_pic = true;
    // duckdb_fastpforlib.strip = true;
    b.installArtifact(duckdb_fastpforlib);

    const duckdb_mbedtls = b.addStaticLibrary(.{
        .name = "duckdb_mbedtls",
        .target = target,
        .optimize = optimize,
    });
    duckdb_mbedtls.addCSourceFiles(&.{
        "duckdb/third_party/mbedtls/mbedtls_wrapper.cpp",
        "duckdb/third_party/mbedtls/library/asn1parse.cpp",
        "duckdb/third_party/mbedtls/library/base64.cpp",
        "duckdb/third_party/mbedtls/library/bignum.cpp",
        "duckdb/third_party/mbedtls/library/constant_time.cpp",
        "duckdb/third_party/mbedtls/library/md.cpp",
        "duckdb/third_party/mbedtls/library/oid.cpp",
        "duckdb/third_party/mbedtls/library/pem.cpp",
        "duckdb/third_party/mbedtls/library/pk.cpp",
        "duckdb/third_party/mbedtls/library/pk_wrap.cpp",
        "duckdb/third_party/mbedtls/library/pkparse.cpp",
        "duckdb/third_party/mbedtls/library/platform_util.cpp",
        "duckdb/third_party/mbedtls/library/rsa.cpp",
        "duckdb/third_party/mbedtls/library/rsa_alt_helpers.cpp",
        "duckdb/third_party/mbedtls/library/sha1.cpp",
        "duckdb/third_party/mbedtls/library/sha256.cpp",
        "duckdb/third_party/mbedtls/library/sha512.cpp",
    }, &.{});
    duckdb_mbedtls.addIncludePath("duckdb/third_party/mbedtls/include");
    duckdb_mbedtls.linkLibCpp();
    duckdb_mbedtls.force_pic = true;
    // duckdb_mbedtls.strip = true;
    b.installArtifact(duckdb_mbedtls);

    // const duckdb_sqlite3 = b.addStaticLibrary(.{
    //     .name = "duckdb_sqlite3",
    //     .target = target,
    //     .optimize = optimize,
    // });
    // duckdb_sqlite3.addCSourceFiles(&.{
    //     "duckdb/third_party/sqlite/sqlite3.c",
    // }, &.{});
    // // duckdb_sqlite3.addIncludePath("duckdb/third_party/sqlite/include");
    // // duckdb_sqlite3.linkLibC();
    // duckdb_sqlite3.force_pic = true;
    // // duckdb_sqlite3.strip = true;
    // b.installArtifact(duckdb_sqlite3);

    // ==============================
    // Extensions
    // ==============================
    // const httpfs_extension = b.addStaticLibrary(.{
    //     .name = "httpfs_extension",
    //     .target = target,
    //     .optimize = optimize,
    // });
    // httpfs_extension.addCSourceFiles(&.{
    //     "duckdb/extension/httpfs/httpfs-extension.cpp",
    // }, &.{});
    // httpfs_extension.addIncludePath("duckdb/src/include");
    // httpfs_extension.addIncludePath("duckdb/extension/httpfs/include");
    // httpfs_extension.addIncludePath("duckdb/third_party/httplib");
    // httpfs_extension.addIncludePath(want_openssl_include_dir);
    // httpfs_extension.linkLibCpp();
    // httpfs_extension.force_pic = true;
    // // httpfs_extension.strip = true;
    // b.installArtifact(httpfs_extension);

    const icu_extension = b.addStaticLibrary(.{
        .name = "icu_extension",
        .target = target,
        .optimize = optimize,
    });
    icu_extension.addCSourceFiles(&.{
        "duckdb/extension/icu/icu_extension.cpp",
    }, &.{});
    icu_extension.addIncludePath("duckdb/extension/icu/third_party/icu/i18n");
    icu_extension.addIncludePath("duckdb/extension/icu/third_party/icu/common");
    icu_extension.addIncludePath("duckdb/src/include");
    icu_extension.linkLibCpp();
    icu_extension.force_pic = true;
    // icu_extension.strip = true;
    b.installArtifact(icu_extension);

    const parquet_extension = b.addStaticLibrary(.{
        .name = "parquet_extension",
        .target = target,
        .optimize = optimize,
    });
    parquet_extension.addCSourceFiles(&.{
        "duckdb/extension/parquet/parquet_extension.cpp",
    }, &.{});
    parquet_extension.addIncludePath("duckdb/extension/parquet/include");
    parquet_extension.addIncludePath("duckdb/src/include");
    parquet_extension.addIncludePath("duckdb/third_party/re2");
    parquet_extension.addIncludePath("duckdb/third_party/parquet");
    parquet_extension.addIncludePath("duckdb/third_party/thrift");
    parquet_extension.linkLibCpp();
    parquet_extension.force_pic = true;
    // parquet_extension.strip = true;
    b.installArtifact(parquet_extension);

    const tpch_extension = b.addStaticLibrary(.{
        .name = "tpch_extension",
        .target = target,
        .optimize = optimize,
    });
    tpch_extension.addCSourceFiles(&.{
        "duckdb/extension/tpch/tpch_extension.cpp",
    }, &.{});
    tpch_extension.addIncludePath("duckdb/extension/tpch/include");
    tpch_extension.addIncludePath("duckdb/extension/tpch/dbgen/include");
    tpch_extension.addIncludePath("duckdb/src/include");
    tpch_extension.linkLibCpp();
    tpch_extension.force_pic = true;
    // tpch_extension.strip = true;
    b.installArtifact(tpch_extension);

    // ==============================
    // Custom Extension
    // ==============================
    const record_extension = b.addStaticLibrary(.{
        .name = "record_extension",
        .target = target,
        .optimize = optimize,
    });
    record_extension.addCSourceFiles(&.{
        "src/record_extension.cpp",
    }, &.{});
    record_extension.addIncludePath("src/include");
    record_extension.addIncludePath("duckdb/src/include");
    record_extension.addIncludePath("duckdb/third_party/re2");
    record_extension.linkLibCpp();
    record_extension.force_pic = true;
    // record_extension.strip = true;
    b.installArtifact(record_extension);

    // ==============================
    // Lib
    // ==============================
    const duckdb_static = b.addStaticLibrary(.{
        .name = "duckdb_static",
        .target = target,
        .optimize = optimize,
    });
    duckdb_static.addCSourceFiles(&.{
        "duckdb/src/catalog/catalog.cpp",
        "duckdb/src/catalog/catalog_entry.cpp",
        "duckdb/src/catalog/catalog_search_path.cpp",
        "duckdb/src/catalog/catalog_set.cpp",
        "duckdb/src/catalog/catalog_transaction.cpp",
        "duckdb/src/catalog/dependency_list.cpp",
        "duckdb/src/catalog/dependency_manager.cpp",
        "duckdb/src/catalog/duck_catalog.cpp",
        "duckdb/src/catalog/similar_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/column_dependency_manager.cpp",
        "duckdb/src/catalog/catalog_entry/copy_function_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/duck_index_entry.cpp",
        "duckdb/src/catalog/catalog_entry/duck_schema_entry.cpp",
        "duckdb/src/catalog/catalog_entry/duck_table_entry.cpp",
        "duckdb/src/catalog/catalog_entry/index_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/macro_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/pragma_function_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/scalar_function_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/schema_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/sequence_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/table_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/table_function_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/type_catalog_entry.cpp",
        "duckdb/src/catalog/catalog_entry/view_catalog_entry.cpp",
        "duckdb/src/catalog/default/default_functions.cpp",
        "duckdb/src/catalog/default/default_schemas.cpp",
        "duckdb/src/catalog/default/default_types.cpp",
        "duckdb/src/catalog/default/default_views.cpp",
        "duckdb/src/common/allocator.cpp",
        "duckdb/src/common/assert.cpp",
        "duckdb/src/common/bind_helpers.cpp",
        "duckdb/src/common/box_renderer.cpp",
        "duckdb/src/common/checksum.cpp",
        "duckdb/src/common/compressed_file_system.cpp",
        "duckdb/src/common/constants.cpp",
        "duckdb/src/common/cycle_counter.cpp",
        "duckdb/src/common/enum_util.cpp",
        "duckdb/src/common/exception.cpp",
        "duckdb/src/common/exception_format_value.cpp",
        "duckdb/src/common/field_writer.cpp",
        "duckdb/src/common/file_buffer.cpp",
        "duckdb/src/common/file_system.cpp",
        "duckdb/src/common/filename_pattern.cpp",
        "duckdb/src/common/fsst.cpp",
        "duckdb/src/common/gzip_file_system.cpp",
        "duckdb/src/common/hive_partitioning.cpp",
        "duckdb/src/common/local_file_system.cpp",
        "duckdb/src/common/multi_file_reader.cpp",
        "duckdb/src/common/pipe_file_system.cpp",
        "duckdb/src/common/preserved_error.cpp",
        "duckdb/src/common/printer.cpp",
        "duckdb/src/common/radix_partitioning.cpp",
        "duckdb/src/common/random_engine.cpp",
        "duckdb/src/common/re2_regex.cpp",
        "duckdb/src/common/serializer.cpp",
        "duckdb/src/common/string_util.cpp",
        "duckdb/src/common/symbols.cpp",
        "duckdb/src/common/tree_renderer.cpp",
        "duckdb/src/common/types.cpp",
        "duckdb/src/common/virtual_file_system.cpp",
        "duckdb/src/common/windows_util.cpp",
        "duckdb/src/common/adbc/adbc.cpp",
        "duckdb/src/common/adbc/driver_manager.cpp",
        "duckdb/src/common/arrow/arrow_appender.cpp",
        "duckdb/src/common/arrow/arrow_converter.cpp",
        "duckdb/src/common/arrow/arrow_wrapper.cpp",
        "duckdb/src/common/crypto/md5.cpp",
        "duckdb/src/common/enums/catalog_type.cpp",
        "duckdb/src/common/enums/compression_type.cpp",
        "duckdb/src/common/enums/date_part_specifier.cpp",
        "duckdb/src/common/enums/expression_type.cpp",
        "duckdb/src/common/enums/file_compression_type.cpp",
        "duckdb/src/common/enums/join_type.cpp",
        "duckdb/src/common/enums/logical_operator_type.cpp",
        "duckdb/src/common/enums/optimizer_type.cpp",
        "duckdb/src/common/enums/physical_operator_type.cpp",
        "duckdb/src/common/enums/relation_type.cpp",
        "duckdb/src/common/enums/statement_type.cpp",
        "duckdb/src/common/operator/cast_operators.cpp",
        "duckdb/src/common/operator/convert_to_string.cpp",
        "duckdb/src/common/operator/string_cast.cpp",
        "duckdb/src/common/progress_bar/progress_bar.cpp",
        "duckdb/src/common/progress_bar/terminal_progress_bar_display.cpp",
        "duckdb/src/common/row_operations/row_aggregate.cpp",
        "duckdb/src/common/row_operations/row_external.cpp",
        "duckdb/src/common/row_operations/row_gather.cpp",
        "duckdb/src/common/row_operations/row_heap_gather.cpp",
        "duckdb/src/common/row_operations/row_heap_scatter.cpp",
        "duckdb/src/common/row_operations/row_match.cpp",
        "duckdb/src/common/row_operations/row_radix_scatter.cpp",
        "duckdb/src/common/row_operations/row_scatter.cpp",
        "duckdb/src/common/serializer/binary_deserializer.cpp",
        "duckdb/src/common/serializer/binary_serializer.cpp",
        "duckdb/src/common/serializer/buffered_deserializer.cpp",
        "duckdb/src/common/serializer/buffered_file_reader.cpp",
        "duckdb/src/common/serializer/buffered_file_writer.cpp",
        "duckdb/src/common/serializer/buffered_serializer.cpp",
        "duckdb/src/common/sort/comparators.cpp",
        "duckdb/src/common/sort/merge_sorter.cpp",
        "duckdb/src/common/sort/partition_state.cpp",
        "duckdb/src/common/sort/radix_sort.cpp",
        "duckdb/src/common/sort/sort_state.cpp",
        "duckdb/src/common/sort/sorted_block.cpp",
        "duckdb/src/common/types/batched_data_collection.cpp",
        "duckdb/src/common/types/bit.cpp",
        "duckdb/src/common/types/blob.cpp",
        "duckdb/src/common/types/cast_helpers.cpp",
        "duckdb/src/common/types/chunk_collection.cpp",
        "duckdb/src/common/types/conflict_info.cpp",
        "duckdb/src/common/types/conflict_manager.cpp",
        "duckdb/src/common/types/data_chunk.cpp",
        "duckdb/src/common/types/date.cpp",
        "duckdb/src/common/types/decimal.cpp",
        "duckdb/src/common/types/hash.cpp",
        "duckdb/src/common/types/hugeint.cpp",
        "duckdb/src/common/types/hyperloglog.cpp",
        "duckdb/src/common/types/interval.cpp",
        "duckdb/src/common/types/list_segment.cpp",
        "duckdb/src/common/types/selection_vector.cpp",
        "duckdb/src/common/types/string_heap.cpp",
        "duckdb/src/common/types/string_type.cpp",
        "duckdb/src/common/types/time.cpp",
        "duckdb/src/common/types/timestamp.cpp",
        "duckdb/src/common/types/uuid.cpp",
        "duckdb/src/common/types/validity_mask.cpp",
        "duckdb/src/common/types/value.cpp",
        "duckdb/src/common/types/vector.cpp",
        "duckdb/src/common/types/vector_buffer.cpp",
        "duckdb/src/common/types/vector_cache.cpp",
        "duckdb/src/common/types/vector_constants.cpp",
        "duckdb/src/common/types/column/column_data_allocator.cpp",
        "duckdb/src/common/types/column/column_data_collection.cpp",
        "duckdb/src/common/types/column/column_data_collection_segment.cpp",
        "duckdb/src/common/types/column/column_data_consumer.cpp",
        "duckdb/src/common/types/column/partitioned_column_data.cpp",
        "duckdb/src/common/types/row/partitioned_tuple_data.cpp",
        "duckdb/src/common/types/row/row_data_collection.cpp",
        "duckdb/src/common/types/row/row_data_collection_scanner.cpp",
        "duckdb/src/common/types/row/row_layout.cpp",
        "duckdb/src/common/types/row/tuple_data_allocator.cpp",
        "duckdb/src/common/types/row/tuple_data_collection.cpp",
        "duckdb/src/common/types/row/tuple_data_iterator.cpp",
        "duckdb/src/common/types/row/tuple_data_layout.cpp",
        "duckdb/src/common/types/row/tuple_data_scatter_gather.cpp",
        "duckdb/src/common/types/row/tuple_data_segment.cpp",
        "duckdb/src/common/value_operations/comparison_operations.cpp",
        "duckdb/src/common/vector_operations/boolean_operators.cpp",
        "duckdb/src/common/vector_operations/comparison_operators.cpp",
        "duckdb/src/common/vector_operations/generators.cpp",
        "duckdb/src/common/vector_operations/is_distinct_from.cpp",
        "duckdb/src/common/vector_operations/null_operations.cpp",
        "duckdb/src/common/vector_operations/numeric_inplace_operators.cpp",
        "duckdb/src/common/vector_operations/vector_cast.cpp",
        "duckdb/src/common/vector_operations/vector_copy.cpp",
        "duckdb/src/common/vector_operations/vector_hash.cpp",
        "duckdb/src/common/vector_operations/vector_storage.cpp",
        "duckdb/src/core_functions/core_functions.cpp",
        "duckdb/src/core_functions/function_list.cpp",
        "duckdb/src/core_functions/aggregate/algebraic/avg.cpp",
        "duckdb/src/core_functions/aggregate/algebraic/corr.cpp",
        "duckdb/src/core_functions/aggregate/algebraic/covar.cpp",
        "duckdb/src/core_functions/aggregate/algebraic/stddev.cpp",
        "duckdb/src/core_functions/aggregate/distributive/approx_count.cpp",
        "duckdb/src/core_functions/aggregate/distributive/arg_min_max.cpp",
        "duckdb/src/core_functions/aggregate/distributive/bitagg.cpp",
        "duckdb/src/core_functions/aggregate/distributive/bitstring_agg.cpp",
        "duckdb/src/core_functions/aggregate/distributive/bool.cpp",
        "duckdb/src/core_functions/aggregate/distributive/entropy.cpp",
        "duckdb/src/core_functions/aggregate/distributive/kurtosis.cpp",
        "duckdb/src/core_functions/aggregate/distributive/minmax.cpp",
        "duckdb/src/core_functions/aggregate/distributive/product.cpp",
        "duckdb/src/core_functions/aggregate/distributive/skew.cpp",
        "duckdb/src/core_functions/aggregate/distributive/string_agg.cpp",
        "duckdb/src/core_functions/aggregate/distributive/sum.cpp",
        "duckdb/src/core_functions/aggregate/holistic/approximate_quantile.cpp",
        "duckdb/src/core_functions/aggregate/holistic/mode.cpp",
        "duckdb/src/core_functions/aggregate/holistic/quantile.cpp",
        "duckdb/src/core_functions/aggregate/holistic/reservoir_quantile.cpp",
        "duckdb/src/core_functions/aggregate/nested/histogram.cpp",
        "duckdb/src/core_functions/aggregate/nested/list.cpp",
        "duckdb/src/core_functions/aggregate/regression/regr_avg.cpp",
        "duckdb/src/core_functions/aggregate/regression/regr_count.cpp",
        "duckdb/src/core_functions/aggregate/regression/regr_intercept.cpp",
        "duckdb/src/core_functions/aggregate/regression/regr_r2.cpp",
        "duckdb/src/core_functions/aggregate/regression/regr_slope.cpp",
        "duckdb/src/core_functions/aggregate/regression/regr_sxx_syy.cpp",
        "duckdb/src/core_functions/aggregate/regression/regr_sxy.cpp",
        "duckdb/src/core_functions/scalar/bit/bitstring.cpp",
        "duckdb/src/core_functions/scalar/blob/base64.cpp",
        "duckdb/src/core_functions/scalar/blob/encode.cpp",
        "duckdb/src/core_functions/scalar/date/age.cpp",
        "duckdb/src/core_functions/scalar/date/current.cpp",
        "duckdb/src/core_functions/scalar/date/date_diff.cpp",
        "duckdb/src/core_functions/scalar/date/date_part.cpp",
        "duckdb/src/core_functions/scalar/date/date_sub.cpp",
        "duckdb/src/core_functions/scalar/date/date_trunc.cpp",
        "duckdb/src/core_functions/scalar/date/epoch.cpp",
        "duckdb/src/core_functions/scalar/date/make_date.cpp",
        "duckdb/src/core_functions/scalar/date/strftime.cpp",
        "duckdb/src/core_functions/scalar/date/time_bucket.cpp",
        "duckdb/src/core_functions/scalar/date/to_interval.cpp",
        "duckdb/src/core_functions/scalar/enum/enum_functions.cpp",
        "duckdb/src/core_functions/scalar/generic/alias.cpp",
        "duckdb/src/core_functions/scalar/generic/current_setting.cpp",
        "duckdb/src/core_functions/scalar/generic/error.cpp",
        "duckdb/src/core_functions/scalar/generic/hash.cpp",
        "duckdb/src/core_functions/scalar/generic/least.cpp",
        "duckdb/src/core_functions/scalar/generic/stats.cpp",
        "duckdb/src/core_functions/scalar/generic/system_functions.cpp",
        "duckdb/src/core_functions/scalar/generic/typeof.cpp",
        "duckdb/src/core_functions/scalar/list/array_slice.cpp",
        "duckdb/src/core_functions/scalar/list/flatten.cpp",
        "duckdb/src/core_functions/scalar/list/list_aggregates.cpp",
        "duckdb/src/core_functions/scalar/list/list_lambdas.cpp",
        "duckdb/src/core_functions/scalar/list/list_sort.cpp",
        "duckdb/src/core_functions/scalar/list/list_value.cpp",
        "duckdb/src/core_functions/scalar/list/range.cpp",
        "duckdb/src/core_functions/scalar/map/cardinality.cpp",
        "duckdb/src/core_functions/scalar/map/map.cpp",
        "duckdb/src/core_functions/scalar/map/map_concat.cpp",
        "duckdb/src/core_functions/scalar/map/map_entries.cpp",
        "duckdb/src/core_functions/scalar/map/map_extract.cpp",
        "duckdb/src/core_functions/scalar/map/map_from_entries.cpp",
        "duckdb/src/core_functions/scalar/map/map_keys_values.cpp",
        "duckdb/src/core_functions/scalar/math/numeric.cpp",
        "duckdb/src/core_functions/scalar/operators/bitwise.cpp",
        "duckdb/src/core_functions/scalar/random/random.cpp",
        "duckdb/src/core_functions/scalar/random/setseed.cpp",
        "duckdb/src/core_functions/scalar/string/ascii.cpp",
        "duckdb/src/core_functions/scalar/string/bar.cpp",
        "duckdb/src/core_functions/scalar/string/chr.cpp",
        "duckdb/src/core_functions/scalar/string/damerau_levenshtein.cpp",
        "duckdb/src/core_functions/scalar/string/format_bytes.cpp",
        "duckdb/src/core_functions/scalar/string/hamming.cpp",
        "duckdb/src/core_functions/scalar/string/hex.cpp",
        "duckdb/src/core_functions/scalar/string/instr.cpp",
        "duckdb/src/core_functions/scalar/string/jaccard.cpp",
        "duckdb/src/core_functions/scalar/string/jaro_winkler.cpp",
        "duckdb/src/core_functions/scalar/string/left_right.cpp",
        "duckdb/src/core_functions/scalar/string/levenshtein.cpp",
        "duckdb/src/core_functions/scalar/string/md5.cpp",
        "duckdb/src/core_functions/scalar/string/pad.cpp",
        "duckdb/src/core_functions/scalar/string/printf.cpp",
        "duckdb/src/core_functions/scalar/string/repeat.cpp",
        "duckdb/src/core_functions/scalar/string/replace.cpp",
        "duckdb/src/core_functions/scalar/string/reverse.cpp",
        "duckdb/src/core_functions/scalar/string/starts_with.cpp",
        "duckdb/src/core_functions/scalar/string/string_split.cpp",
        "duckdb/src/core_functions/scalar/string/translate.cpp",
        "duckdb/src/core_functions/scalar/string/trim.cpp",
        "duckdb/src/core_functions/scalar/string/unicode.cpp",
        "duckdb/src/core_functions/scalar/struct/struct_insert.cpp",
        "duckdb/src/core_functions/scalar/struct/struct_pack.cpp",
        "duckdb/src/core_functions/scalar/union/union_extract.cpp",
        "duckdb/src/core_functions/scalar/union/union_tag.cpp",
        "duckdb/src/core_functions/scalar/union/union_value.cpp",
        "duckdb/src/execution/adaptive_filter.cpp",
        "duckdb/src/execution/aggregate_hashtable.cpp",
        "duckdb/src/execution/base_aggregate_hashtable.cpp",
        "duckdb/src/execution/column_binding_resolver.cpp",
        "duckdb/src/execution/expression_executor.cpp",
        "duckdb/src/execution/expression_executor_state.cpp",
        "duckdb/src/execution/join_hashtable.cpp",
        "duckdb/src/execution/partitionable_hashtable.cpp",
        "duckdb/src/execution/perfect_aggregate_hashtable.cpp",
        "duckdb/src/execution/physical_operator.cpp",
        "duckdb/src/execution/physical_plan_generator.cpp",
        "duckdb/src/execution/radix_partitioned_hashtable.cpp",
        "duckdb/src/execution/reservoir_sample.cpp",
        "duckdb/src/execution/window_segment_tree.cpp",
        "duckdb/src/execution/expression_executor/execute_between.cpp",
        "duckdb/src/execution/expression_executor/execute_case.cpp",
        "duckdb/src/execution/expression_executor/execute_cast.cpp",
        "duckdb/src/execution/expression_executor/execute_comparison.cpp",
        "duckdb/src/execution/expression_executor/execute_conjunction.cpp",
        "duckdb/src/execution/expression_executor/execute_constant.cpp",
        "duckdb/src/execution/expression_executor/execute_function.cpp",
        "duckdb/src/execution/expression_executor/execute_operator.cpp",
        "duckdb/src/execution/expression_executor/execute_parameter.cpp",
        "duckdb/src/execution/expression_executor/execute_reference.cpp",
        "duckdb/src/execution/index/art/art.cpp",
        "duckdb/src/execution/index/art/art_key.cpp",
        "duckdb/src/execution/index/art/fixed_size_allocator.cpp",
        "duckdb/src/execution/index/art/iterator.cpp",
        "duckdb/src/execution/index/art/leaf.cpp",
        "duckdb/src/execution/index/art/leaf_segment.cpp",
        "duckdb/src/execution/index/art/node.cpp",
        "duckdb/src/execution/index/art/node16.cpp",
        "duckdb/src/execution/index/art/node256.cpp",
        "duckdb/src/execution/index/art/node4.cpp",
        "duckdb/src/execution/index/art/node48.cpp",
        "duckdb/src/execution/index/art/prefix.cpp",
        "duckdb/src/execution/index/art/prefix_segment.cpp",
        "duckdb/src/execution/index/art/swizzleable_pointer.cpp",
        "duckdb/src/execution/nested_loop_join/nested_loop_join_inner.cpp",
        "duckdb/src/execution/nested_loop_join/nested_loop_join_mark.cpp",
        "duckdb/src/execution/operator/aggregate/aggregate_object.cpp",
        "duckdb/src/execution/operator/aggregate/distinct_aggregate_data.cpp",
        "duckdb/src/execution/operator/aggregate/grouped_aggregate_data.cpp",
        "duckdb/src/execution/operator/aggregate/physical_hash_aggregate.cpp",
        "duckdb/src/execution/operator/aggregate/physical_perfecthash_aggregate.cpp",
        "duckdb/src/execution/operator/aggregate/physical_streaming_window.cpp",
        "duckdb/src/execution/operator/aggregate/physical_ungrouped_aggregate.cpp",
        "duckdb/src/execution/operator/aggregate/physical_window.cpp",
        "duckdb/src/execution/operator/filter/physical_filter.cpp",
        "duckdb/src/execution/operator/helper/physical_batch_collector.cpp",
        "duckdb/src/execution/operator/helper/physical_execute.cpp",
        "duckdb/src/execution/operator/helper/physical_explain_analyze.cpp",
        "duckdb/src/execution/operator/helper/physical_limit.cpp",
        "duckdb/src/execution/operator/helper/physical_limit_percent.cpp",
        "duckdb/src/execution/operator/helper/physical_load.cpp",
        "duckdb/src/execution/operator/helper/physical_materialized_collector.cpp",
        "duckdb/src/execution/operator/helper/physical_pragma.cpp",
        "duckdb/src/execution/operator/helper/physical_prepare.cpp",
        "duckdb/src/execution/operator/helper/physical_reservoir_sample.cpp",
        "duckdb/src/execution/operator/helper/physical_reset.cpp",
        "duckdb/src/execution/operator/helper/physical_result_collector.cpp",
        "duckdb/src/execution/operator/helper/physical_set.cpp",
        "duckdb/src/execution/operator/helper/physical_streaming_limit.cpp",
        "duckdb/src/execution/operator/helper/physical_streaming_sample.cpp",
        "duckdb/src/execution/operator/helper/physical_transaction.cpp",
        "duckdb/src/execution/operator/helper/physical_vacuum.cpp",
        "duckdb/src/execution/operator/join/outer_join_marker.cpp",
        "duckdb/src/execution/operator/join/perfect_hash_join_executor.cpp",
        "duckdb/src/execution/operator/join/physical_asof_join.cpp",
        "duckdb/src/execution/operator/join/physical_blockwise_nl_join.cpp",
        "duckdb/src/execution/operator/join/physical_comparison_join.cpp",
        "duckdb/src/execution/operator/join/physical_cross_product.cpp",
        "duckdb/src/execution/operator/join/physical_delim_join.cpp",
        "duckdb/src/execution/operator/join/physical_hash_join.cpp",
        "duckdb/src/execution/operator/join/physical_iejoin.cpp",
        "duckdb/src/execution/operator/join/physical_index_join.cpp",
        "duckdb/src/execution/operator/join/physical_join.cpp",
        "duckdb/src/execution/operator/join/physical_nested_loop_join.cpp",
        "duckdb/src/execution/operator/join/physical_piecewise_merge_join.cpp",
        "duckdb/src/execution/operator/join/physical_positional_join.cpp",
        "duckdb/src/execution/operator/join/physical_range_join.cpp",
        "duckdb/src/execution/operator/order/physical_order.cpp",
        "duckdb/src/execution/operator/order/physical_top_n.cpp",
        "duckdb/src/execution/operator/persistent/base_csv_reader.cpp",
        "duckdb/src/execution/operator/persistent/buffered_csv_reader.cpp",
        "duckdb/src/execution/operator/persistent/csv_buffer.cpp",
        "duckdb/src/execution/operator/persistent/csv_file_handle.cpp",
        "duckdb/src/execution/operator/persistent/csv_reader_options.cpp",
        "duckdb/src/execution/operator/persistent/parallel_csv_reader.cpp",
        "duckdb/src/execution/operator/persistent/physical_batch_copy_to_file.cpp",
        "duckdb/src/execution/operator/persistent/physical_batch_insert.cpp",
        "duckdb/src/execution/operator/persistent/physical_copy_to_file.cpp",
        "duckdb/src/execution/operator/persistent/physical_delete.cpp",
        "duckdb/src/execution/operator/persistent/physical_export.cpp",
        "duckdb/src/execution/operator/persistent/physical_fixed_batch_copy.cpp",
        "duckdb/src/execution/operator/persistent/physical_insert.cpp",
        "duckdb/src/execution/operator/persistent/physical_update.cpp",
        "duckdb/src/execution/operator/projection/physical_pivot.cpp",
        "duckdb/src/execution/operator/projection/physical_projection.cpp",
        "duckdb/src/execution/operator/projection/physical_tableinout_function.cpp",
        "duckdb/src/execution/operator/projection/physical_unnest.cpp",
        "duckdb/src/execution/operator/scan/physical_column_data_scan.cpp",
        "duckdb/src/execution/operator/scan/physical_dummy_scan.cpp",
        "duckdb/src/execution/operator/scan/physical_empty_result.cpp",
        "duckdb/src/execution/operator/scan/physical_expression_scan.cpp",
        "duckdb/src/execution/operator/scan/physical_positional_scan.cpp",
        "duckdb/src/execution/operator/scan/physical_table_scan.cpp",
        "duckdb/src/execution/operator/schema/physical_alter.cpp",
        "duckdb/src/execution/operator/schema/physical_attach.cpp",
        "duckdb/src/execution/operator/schema/physical_create_function.cpp",
        "duckdb/src/execution/operator/schema/physical_create_index.cpp",
        "duckdb/src/execution/operator/schema/physical_create_schema.cpp",
        "duckdb/src/execution/operator/schema/physical_create_sequence.cpp",
        "duckdb/src/execution/operator/schema/physical_create_table.cpp",
        "duckdb/src/execution/operator/schema/physical_create_type.cpp",
        "duckdb/src/execution/operator/schema/physical_create_view.cpp",
        "duckdb/src/execution/operator/schema/physical_detach.cpp",
        "duckdb/src/execution/operator/schema/physical_drop.cpp",
        "duckdb/src/execution/operator/set/physical_recursive_cte.cpp",
        "duckdb/src/execution/operator/set/physical_union.cpp",
        "duckdb/src/execution/physical_plan/plan_aggregate.cpp",
        "duckdb/src/execution/physical_plan/plan_any_join.cpp",
        "duckdb/src/execution/physical_plan/plan_asof_join.cpp",
        "duckdb/src/execution/physical_plan/plan_column_data_get.cpp",
        "duckdb/src/execution/physical_plan/plan_comparison_join.cpp",
        "duckdb/src/execution/physical_plan/plan_copy_to_file.cpp",
        "duckdb/src/execution/physical_plan/plan_create.cpp",
        "duckdb/src/execution/physical_plan/plan_create_index.cpp",
        "duckdb/src/execution/physical_plan/plan_create_table.cpp",
        "duckdb/src/execution/physical_plan/plan_cross_product.cpp",
        "duckdb/src/execution/physical_plan/plan_delete.cpp",
        "duckdb/src/execution/physical_plan/plan_delim_get.cpp",
        "duckdb/src/execution/physical_plan/plan_delim_join.cpp",
        "duckdb/src/execution/physical_plan/plan_distinct.cpp",
        "duckdb/src/execution/physical_plan/plan_dummy_scan.cpp",
        "duckdb/src/execution/physical_plan/plan_empty_result.cpp",
        "duckdb/src/execution/physical_plan/plan_execute.cpp",
        "duckdb/src/execution/physical_plan/plan_explain.cpp",
        "duckdb/src/execution/physical_plan/plan_export.cpp",
        "duckdb/src/execution/physical_plan/plan_expression_get.cpp",
        "duckdb/src/execution/physical_plan/plan_filter.cpp",
        "duckdb/src/execution/physical_plan/plan_get.cpp",
        "duckdb/src/execution/physical_plan/plan_insert.cpp",
        "duckdb/src/execution/physical_plan/plan_limit.cpp",
        "duckdb/src/execution/physical_plan/plan_limit_percent.cpp",
        "duckdb/src/execution/physical_plan/plan_order.cpp",
        "duckdb/src/execution/physical_plan/plan_pivot.cpp",
        "duckdb/src/execution/physical_plan/plan_positional_join.cpp",
        "duckdb/src/execution/physical_plan/plan_pragma.cpp",
        "duckdb/src/execution/physical_plan/plan_prepare.cpp",
        "duckdb/src/execution/physical_plan/plan_projection.cpp",
        "duckdb/src/execution/physical_plan/plan_recursive_cte.cpp",
        "duckdb/src/execution/physical_plan/plan_reset.cpp",
        "duckdb/src/execution/physical_plan/plan_sample.cpp",
        "duckdb/src/execution/physical_plan/plan_set.cpp",
        "duckdb/src/execution/physical_plan/plan_set_operation.cpp",
        "duckdb/src/execution/physical_plan/plan_show_select.cpp",
        "duckdb/src/execution/physical_plan/plan_simple.cpp",
        "duckdb/src/execution/physical_plan/plan_top_n.cpp",
        "duckdb/src/execution/physical_plan/plan_unnest.cpp",
        "duckdb/src/execution/physical_plan/plan_update.cpp",
        "duckdb/src/execution/physical_plan/plan_window.cpp",
        "duckdb/src/function/built_in_functions.cpp",
        "duckdb/src/function/cast_rules.cpp",
        "duckdb/src/function/compression_config.cpp",
        "duckdb/src/function/function.cpp",
        "duckdb/src/function/function_binder.cpp",
        "duckdb/src/function/function_set.cpp",
        "duckdb/src/function/macro_function.cpp",
        "duckdb/src/function/pragma_function.cpp",
        "duckdb/src/function/scalar_function.cpp",
        "duckdb/src/function/scalar_macro_function.cpp",
        "duckdb/src/function/table_function.cpp",
        "duckdb/src/function/table_macro_function.cpp",
        "duckdb/src/function/udf_function.cpp",
        "duckdb/src/function/aggregate/distributive_functions.cpp",
        "duckdb/src/function/aggregate/sorted_aggregate_function.cpp",
        "duckdb/src/function/aggregate/distributive/count.cpp",
        "duckdb/src/function/aggregate/distributive/first.cpp",
        "duckdb/src/function/cast/bit_cast.cpp",
        "duckdb/src/function/cast/blob_cast.cpp",
        "duckdb/src/function/cast/cast_function_set.cpp",
        "duckdb/src/function/cast/decimal_cast.cpp",
        "duckdb/src/function/cast/default_casts.cpp",
        "duckdb/src/function/cast/enum_casts.cpp",
        "duckdb/src/function/cast/list_casts.cpp",
        "duckdb/src/function/cast/map_cast.cpp",
        "duckdb/src/function/cast/numeric_casts.cpp",
        "duckdb/src/function/cast/pointer_cast.cpp",
        "duckdb/src/function/cast/string_cast.cpp",
        "duckdb/src/function/cast/struct_cast.cpp",
        "duckdb/src/function/cast/time_casts.cpp",
        "duckdb/src/function/cast/union_casts.cpp",
        "duckdb/src/function/cast/uuid_casts.cpp",
        "duckdb/src/function/cast/vector_cast_helpers.cpp",
        "duckdb/src/function/pragma/pragma_functions.cpp",
        "duckdb/src/function/pragma/pragma_queries.cpp",
        "duckdb/src/function/scalar/generic_functions.cpp",
        "duckdb/src/function/scalar/nested_functions.cpp",
        "duckdb/src/function/scalar/operators.cpp",
        "duckdb/src/function/scalar/pragma_functions.cpp",
        "duckdb/src/function/scalar/sequence_functions.cpp",
        "duckdb/src/function/scalar/strftime_format.cpp",
        "duckdb/src/function/scalar/string_functions.cpp",
        "duckdb/src/function/scalar/generic/constant_or_null.cpp",
        "duckdb/src/function/scalar/list/contains_or_position.cpp",
        "duckdb/src/function/scalar/list/list_concat.cpp",
        "duckdb/src/function/scalar/list/list_extract.cpp",
        "duckdb/src/function/scalar/operators/add.cpp",
        "duckdb/src/function/scalar/operators/arithmetic.cpp",
        "duckdb/src/function/scalar/operators/multiply.cpp",
        "duckdb/src/function/scalar/operators/subtract.cpp",
        "duckdb/src/function/scalar/sequence/nextval.cpp",
        "duckdb/src/function/scalar/string/caseconvert.cpp",
        "duckdb/src/function/scalar/string/concat.cpp",
        "duckdb/src/function/scalar/string/contains.cpp",
        "duckdb/src/function/scalar/string/length.cpp",
        "duckdb/src/function/scalar/string/like.cpp",
        "duckdb/src/function/scalar/string/nfc_normalize.cpp",
        "duckdb/src/function/scalar/string/prefix.cpp",
        "duckdb/src/function/scalar/string/regexp.cpp",
        "duckdb/src/function/scalar/string/strip_accents.cpp",
        "duckdb/src/function/scalar/string/substring.cpp",
        "duckdb/src/function/scalar/string/suffix.cpp",
        "duckdb/src/function/scalar/string/regexp/regexp_extract_all.cpp",
        "duckdb/src/function/scalar/string/regexp/regexp_util.cpp",
        "duckdb/src/function/scalar/struct/struct_extract.cpp",
        "duckdb/src/function/scalar/system/aggregate_export.cpp",
        "duckdb/src/function/table/arrow.cpp",
        "duckdb/src/function/table/arrow_conversion.cpp",
        "duckdb/src/function/table/checkpoint.cpp",
        "duckdb/src/function/table/copy_csv.cpp",
        "duckdb/src/function/table/glob.cpp",
        "duckdb/src/function/table/pragma_detailed_profiling_output.cpp",
        "duckdb/src/function/table/pragma_last_profiling_output.cpp",
        "duckdb/src/function/table/range.cpp",
        "duckdb/src/function/table/read_csv.cpp",
        "duckdb/src/function/table/repeat.cpp",
        "duckdb/src/function/table/repeat_row.cpp",
        "duckdb/src/function/table/summary.cpp",
        "duckdb/src/function/table/system_functions.cpp",
        "duckdb/src/function/table/table_scan.cpp",
        "duckdb/src/function/table/unnest.cpp",
        "duckdb/src/function/table/system/duckdb_columns.cpp",
        "duckdb/src/function/table/system/duckdb_constraints.cpp",
        "duckdb/src/function/table/system/duckdb_databases.cpp",
        "duckdb/src/function/table/system/duckdb_dependencies.cpp",
        "duckdb/src/function/table/system/duckdb_extensions.cpp",
        "duckdb/src/function/table/system/duckdb_functions.cpp",
        "duckdb/src/function/table/system/duckdb_indexes.cpp",
        "duckdb/src/function/table/system/duckdb_keywords.cpp",
        "duckdb/src/function/table/system/duckdb_schemas.cpp",
        "duckdb/src/function/table/system/duckdb_sequences.cpp",
        "duckdb/src/function/table/system/duckdb_settings.cpp",
        "duckdb/src/function/table/system/duckdb_tables.cpp",
        "duckdb/src/function/table/system/duckdb_temporary_files.cpp",
        "duckdb/src/function/table/system/duckdb_types.cpp",
        "duckdb/src/function/table/system/duckdb_views.cpp",
        "duckdb/src/function/table/system/pragma_collations.cpp",
        "duckdb/src/function/table/system/pragma_database_size.cpp",
        "duckdb/src/function/table/system/pragma_storage_info.cpp",
        "duckdb/src/function/table/system/pragma_table_info.cpp",
        "duckdb/src/function/table/system/test_all_types.cpp",
        "duckdb/src/function/table/system/test_vector_types.cpp",
        "duckdb/src/function/table/version/pragma_version.cpp",
        "duckdb/src/main/appender.cpp",
        "duckdb/src/main/attached_database.cpp",
        "duckdb/src/main/client_context.cpp",
        "duckdb/src/main/client_context_file_opener.cpp",
        "duckdb/src/main/client_data.cpp",
        "duckdb/src/main/client_verify.cpp",
        "duckdb/src/main/config.cpp",
        "duckdb/src/main/connection.cpp",
        "duckdb/src/main/database.cpp",
        "duckdb/src/main/database_manager.cpp",
        "duckdb/src/main/database_path_and_type.cpp",
        "duckdb/src/main/db_instance_cache.cpp",
        "duckdb/src/main/error_manager.cpp",
        "duckdb/src/main/extension.cpp",
        "duckdb/src/main/materialized_query_result.cpp",
        "duckdb/src/main/pending_query_result.cpp",
        "duckdb/src/main/prepared_statement.cpp",
        "duckdb/src/main/prepared_statement_data.cpp",
        "duckdb/src/main/query_profiler.cpp",
        "duckdb/src/main/query_result.cpp",
        "duckdb/src/main/relation.cpp",
        "duckdb/src/main/stream_query_result.cpp",
        "duckdb/src/main/valid_checker.cpp",
        "duckdb/src/main/capi/appender-c.cpp",
        "duckdb/src/main/capi/arrow-c.cpp",
        "duckdb/src/main/capi/config-c.cpp",
        "duckdb/src/main/capi/data_chunk-c.cpp",
        "duckdb/src/main/capi/datetime-c.cpp",
        "duckdb/src/main/capi/duckdb-c.cpp",
        "duckdb/src/main/capi/duckdb_value-c.cpp",
        "duckdb/src/main/capi/helper-c.cpp",
        "duckdb/src/main/capi/hugeint-c.cpp",
        "duckdb/src/main/capi/logical_types-c.cpp",
        "duckdb/src/main/capi/pending-c.cpp",
        "duckdb/src/main/capi/prepared-c.cpp",
        "duckdb/src/main/capi/replacement_scan-c.cpp",
        "duckdb/src/main/capi/result-c.cpp",
        "duckdb/src/main/capi/stream-c.cpp",
        "duckdb/src/main/capi/table_function-c.cpp",
        "duckdb/src/main/capi/threading-c.cpp",
        "duckdb/src/main/capi/value-c.cpp",
        "duckdb/src/main/capi/cast/from_decimal-c.cpp",
        "duckdb/src/main/capi/cast/utils-c.cpp",
        "duckdb/src/main/extension/extension_alias.cpp",
        "duckdb/src/main/extension/extension_helper.cpp",
        "duckdb/src/main/extension/extension_install.cpp",
        "duckdb/src/main/extension/extension_load.cpp",
        "duckdb/src/main/extension/extension_util.cpp",
        // TODO:
        // - Not sure how to include these for zig build ...
        // "duckdb/src/main/extension/extension_oote_headers.hpp.in",
        // "duckdb/src/main/extension/extension_oote_loader.hpp.in",
        "duckdb/src/main/relation/aggregate_relation.cpp",
        "duckdb/src/main/relation/create_table_relation.cpp",
        "duckdb/src/main/relation/create_view_relation.cpp",
        "duckdb/src/main/relation/cross_product_relation.cpp",
        "duckdb/src/main/relation/delete_relation.cpp",
        "duckdb/src/main/relation/distinct_relation.cpp",
        "duckdb/src/main/relation/explain_relation.cpp",
        "duckdb/src/main/relation/filter_relation.cpp",
        "duckdb/src/main/relation/insert_relation.cpp",
        "duckdb/src/main/relation/join_relation.cpp",
        "duckdb/src/main/relation/limit_relation.cpp",
        "duckdb/src/main/relation/order_relation.cpp",
        "duckdb/src/main/relation/projection_relation.cpp",
        "duckdb/src/main/relation/query_relation.cpp",
        "duckdb/src/main/relation/read_csv_relation.cpp",
        "duckdb/src/main/relation/read_json_relation.cpp",
        "duckdb/src/main/relation/setop_relation.cpp",
        "duckdb/src/main/relation/subquery_relation.cpp",
        "duckdb/src/main/relation/table_function_relation.cpp",
        "duckdb/src/main/relation/table_relation.cpp",
        "duckdb/src/main/relation/update_relation.cpp",
        "duckdb/src/main/relation/value_relation.cpp",
        "duckdb/src/main/relation/view_relation.cpp",
        "duckdb/src/main/relation/write_csv_relation.cpp",
        "duckdb/src/main/relation/write_parquet_relation.cpp",
        "duckdb/src/main/settings/settings.cpp",
        "duckdb/src/optimizer/column_lifetime_analyzer.cpp",
        "duckdb/src/optimizer/common_aggregate_optimizer.cpp",
        "duckdb/src/optimizer/cse_optimizer.cpp",
        "duckdb/src/optimizer/deliminator.cpp",
        "duckdb/src/optimizer/expression_heuristics.cpp",
        "duckdb/src/optimizer/expression_rewriter.cpp",
        "duckdb/src/optimizer/filter_combiner.cpp",
        "duckdb/src/optimizer/filter_pullup.cpp",
        "duckdb/src/optimizer/filter_pushdown.cpp",
        "duckdb/src/optimizer/in_clause_rewriter.cpp",
        "duckdb/src/optimizer/optimizer.cpp",
        "duckdb/src/optimizer/regex_range_filter.cpp",
        "duckdb/src/optimizer/remove_unused_columns.cpp",
        "duckdb/src/optimizer/statistics_propagator.cpp",
        "duckdb/src/optimizer/topn_optimizer.cpp",
        "duckdb/src/optimizer/unnest_rewriter.cpp",
        "duckdb/src/optimizer/join_order/cardinality_estimator.cpp",
        "duckdb/src/optimizer/join_order/estimated_properties.cpp",
        "duckdb/src/optimizer/join_order/join_node.cpp",
        "duckdb/src/optimizer/join_order/join_order_optimizer.cpp",
        "duckdb/src/optimizer/join_order/join_relation_set.cpp",
        "duckdb/src/optimizer/join_order/query_graph.cpp",
        "duckdb/src/optimizer/matcher/expression_matcher.cpp",
        "duckdb/src/optimizer/pullup/pullup_both_side.cpp",
        "duckdb/src/optimizer/pullup/pullup_filter.cpp",
        "duckdb/src/optimizer/pullup/pullup_from_left.cpp",
        "duckdb/src/optimizer/pullup/pullup_projection.cpp",
        "duckdb/src/optimizer/pullup/pullup_set_operation.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_aggregate.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_cross_product.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_filter.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_get.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_inner_join.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_left_join.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_limit.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_mark_join.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_projection.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_set_operation.cpp",
        "duckdb/src/optimizer/pushdown/pushdown_single_join.cpp",
        "duckdb/src/optimizer/rule/arithmetic_simplification.cpp",
        "duckdb/src/optimizer/rule/case_simplification.cpp",
        "duckdb/src/optimizer/rule/comparison_simplification.cpp",
        "duckdb/src/optimizer/rule/conjunction_simplification.cpp",
        "duckdb/src/optimizer/rule/constant_folding.cpp",
        "duckdb/src/optimizer/rule/date_part_simplification.cpp",
        "duckdb/src/optimizer/rule/distributivity.cpp",
        "duckdb/src/optimizer/rule/empty_needle_removal.cpp",
        "duckdb/src/optimizer/rule/enum_comparison.cpp",
        "duckdb/src/optimizer/rule/equal_or_null_simplification.cpp",
        "duckdb/src/optimizer/rule/in_clause_simplification_rule.cpp",
        "duckdb/src/optimizer/rule/like_optimizations.cpp",
        "duckdb/src/optimizer/rule/move_constants.cpp",
        "duckdb/src/optimizer/rule/ordered_aggregate_optimizer.cpp",
        "duckdb/src/optimizer/rule/regex_optimizations.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_aggregate.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_and_compress.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_between.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_case.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_cast.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_columnref.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_comparison.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_conjunction.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_constant.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_function.cpp",
        "duckdb/src/optimizer/statistics/expression/propagate_operator.cpp",
        "duckdb/src/optimizer/statistics/operator/propagate_aggregate.cpp",
        "duckdb/src/optimizer/statistics/operator/propagate_cross_product.cpp",
        "duckdb/src/optimizer/statistics/operator/propagate_filter.cpp",
        "duckdb/src/optimizer/statistics/operator/propagate_get.cpp",
        "duckdb/src/optimizer/statistics/operator/propagate_join.cpp",
        "duckdb/src/optimizer/statistics/operator/propagate_limit.cpp",
        "duckdb/src/optimizer/statistics/operator/propagate_order.cpp",
        "duckdb/src/optimizer/statistics/operator/propagate_projection.cpp",
        "duckdb/src/optimizer/statistics/operator/propagate_set_operation.cpp",
        "duckdb/src/optimizer/statistics/operator/propagate_window.cpp",
        "duckdb/src/parallel/base_pipeline_event.cpp",
        "duckdb/src/parallel/event.cpp",
        "duckdb/src/parallel/executor.cpp",
        "duckdb/src/parallel/executor_task.cpp",
        "duckdb/src/parallel/interrupt.cpp",
        "duckdb/src/parallel/meta_pipeline.cpp",
        "duckdb/src/parallel/pipeline.cpp",
        "duckdb/src/parallel/pipeline_complete_event.cpp",
        "duckdb/src/parallel/pipeline_event.cpp",
        "duckdb/src/parallel/pipeline_executor.cpp",
        "duckdb/src/parallel/pipeline_finish_event.cpp",
        "duckdb/src/parallel/pipeline_initialize_event.cpp",
        "duckdb/src/parallel/task_scheduler.cpp",
        "duckdb/src/parallel/thread_context.cpp",
        "duckdb/src/parser/base_expression.cpp",
        "duckdb/src/parser/column_definition.cpp",
        "duckdb/src/parser/column_list.cpp",
        "duckdb/src/parser/common_table_expression_info.cpp",
        "duckdb/src/parser/constraint.cpp",
        "duckdb/src/parser/expression_util.cpp",
        "duckdb/src/parser/keyword_helper.cpp",
        "duckdb/src/parser/parsed_expression.cpp",
        "duckdb/src/parser/parsed_expression_iterator.cpp",
        "duckdb/src/parser/parser.cpp",
        "duckdb/src/parser/query_error_context.cpp",
        "duckdb/src/parser/query_node.cpp",
        "duckdb/src/parser/result_modifier.cpp",
        "duckdb/src/parser/tableref.cpp",
        "duckdb/src/parser/transformer.cpp",
        "duckdb/src/parser/constraints/check_constraint.cpp",
        "duckdb/src/parser/constraints/foreign_key_constraint.cpp",
        "duckdb/src/parser/constraints/not_null_constraint.cpp",
        "duckdb/src/parser/constraints/unique_constraint.cpp",
        "duckdb/src/parser/expression/between_expression.cpp",
        "duckdb/src/parser/expression/case_expression.cpp",
        "duckdb/src/parser/expression/cast_expression.cpp",
        "duckdb/src/parser/expression/collate_expression.cpp",
        "duckdb/src/parser/expression/columnref_expression.cpp",
        "duckdb/src/parser/expression/comparison_expression.cpp",
        "duckdb/src/parser/expression/conjunction_expression.cpp",
        "duckdb/src/parser/expression/constant_expression.cpp",
        "duckdb/src/parser/expression/default_expression.cpp",
        "duckdb/src/parser/expression/function_expression.cpp",
        "duckdb/src/parser/expression/lambda_expression.cpp",
        "duckdb/src/parser/expression/operator_expression.cpp",
        "duckdb/src/parser/expression/parameter_expression.cpp",
        "duckdb/src/parser/expression/positional_reference_expression.cpp",
        "duckdb/src/parser/expression/star_expression.cpp",
        "duckdb/src/parser/expression/subquery_expression.cpp",
        "duckdb/src/parser/expression/window_expression.cpp",
        "duckdb/src/parser/parsed_data/alter_info.cpp",
        "duckdb/src/parser/parsed_data/alter_scalar_function_info.cpp",
        "duckdb/src/parser/parsed_data/alter_table_function_info.cpp",
        "duckdb/src/parser/parsed_data/alter_table_info.cpp",
        "duckdb/src/parser/parsed_data/attach_info.cpp",
        "duckdb/src/parser/parsed_data/create_aggregate_function_info.cpp",
        "duckdb/src/parser/parsed_data/create_collation_info.cpp",
        "duckdb/src/parser/parsed_data/create_copy_function_info.cpp",
        "duckdb/src/parser/parsed_data/create_index_info.cpp",
        "duckdb/src/parser/parsed_data/create_info.cpp",
        "duckdb/src/parser/parsed_data/create_macro_info.cpp",
        "duckdb/src/parser/parsed_data/create_pragma_function_info.cpp",
        "duckdb/src/parser/parsed_data/create_scalar_function_info.cpp",
        "duckdb/src/parser/parsed_data/create_sequence_info.cpp",
        "duckdb/src/parser/parsed_data/create_table_function_info.cpp",
        "duckdb/src/parser/parsed_data/create_table_info.cpp",
        "duckdb/src/parser/parsed_data/create_type_info.cpp",
        "duckdb/src/parser/parsed_data/create_view_info.cpp",
        "duckdb/src/parser/parsed_data/detach_info.cpp",
        "duckdb/src/parser/parsed_data/drop_info.cpp",
        "duckdb/src/parser/parsed_data/sample_options.cpp",
        "duckdb/src/parser/parsed_data/transaction_info.cpp",
        "duckdb/src/parser/parsed_data/vacuum_info.cpp",
        "duckdb/src/parser/query_node/recursive_cte_node.cpp",
        "duckdb/src/parser/query_node/select_node.cpp",
        "duckdb/src/parser/query_node/set_operation_node.cpp",
        "duckdb/src/parser/statement/alter_statement.cpp",
        "duckdb/src/parser/statement/attach_statement.cpp",
        "duckdb/src/parser/statement/call_statement.cpp",
        "duckdb/src/parser/statement/copy_statement.cpp",
        "duckdb/src/parser/statement/create_statement.cpp",
        "duckdb/src/parser/statement/delete_statement.cpp",
        "duckdb/src/parser/statement/detach_statement.cpp",
        "duckdb/src/parser/statement/drop_statement.cpp",
        "duckdb/src/parser/statement/execute_statement.cpp",
        "duckdb/src/parser/statement/explain_statement.cpp",
        "duckdb/src/parser/statement/export_statement.cpp",
        "duckdb/src/parser/statement/extension_statement.cpp",
        "duckdb/src/parser/statement/insert_statement.cpp",
        "duckdb/src/parser/statement/load_statement.cpp",
        "duckdb/src/parser/statement/multi_statement.cpp",
        "duckdb/src/parser/statement/pragma_statement.cpp",
        "duckdb/src/parser/statement/prepare_statement.cpp",
        "duckdb/src/parser/statement/relation_statement.cpp",
        "duckdb/src/parser/statement/select_statement.cpp",
        "duckdb/src/parser/statement/set_statement.cpp",
        "duckdb/src/parser/statement/show_statement.cpp",
        "duckdb/src/parser/statement/transaction_statement.cpp",
        "duckdb/src/parser/statement/update_statement.cpp",
        "duckdb/src/parser/statement/vacuum_statement.cpp",
        "duckdb/src/parser/tableref/basetableref.cpp",
        "duckdb/src/parser/tableref/emptytableref.cpp",
        "duckdb/src/parser/tableref/expressionlistref.cpp",
        "duckdb/src/parser/tableref/joinref.cpp",
        "duckdb/src/parser/tableref/pivotref.cpp",
        "duckdb/src/parser/tableref/subqueryref.cpp",
        "duckdb/src/parser/tableref/table_function.cpp",
        "duckdb/src/parser/transform/constraint/transform_constraint.cpp",
        "duckdb/src/parser/transform/expression/transform_array_access.cpp",
        "duckdb/src/parser/transform/expression/transform_bool_expr.cpp",
        "duckdb/src/parser/transform/expression/transform_boolean_test.cpp",
        "duckdb/src/parser/transform/expression/transform_case.cpp",
        "duckdb/src/parser/transform/expression/transform_cast.cpp",
        "duckdb/src/parser/transform/expression/transform_coalesce.cpp",
        "duckdb/src/parser/transform/expression/transform_columnref.cpp",
        "duckdb/src/parser/transform/expression/transform_constant.cpp",
        "duckdb/src/parser/transform/expression/transform_expression.cpp",
        "duckdb/src/parser/transform/expression/transform_function.cpp",
        "duckdb/src/parser/transform/expression/transform_grouping_function.cpp",
        "duckdb/src/parser/transform/expression/transform_interval.cpp",
        "duckdb/src/parser/transform/expression/transform_is_null.cpp",
        "duckdb/src/parser/transform/expression/transform_lambda.cpp",
        "duckdb/src/parser/transform/expression/transform_operator.cpp",
        "duckdb/src/parser/transform/expression/transform_param_ref.cpp",
        "duckdb/src/parser/transform/expression/transform_positional_reference.cpp",
        "duckdb/src/parser/transform/expression/transform_subquery.cpp",
        "duckdb/src/parser/transform/helpers/nodetype_to_string.cpp",
        "duckdb/src/parser/transform/helpers/transform_alias.cpp",
        "duckdb/src/parser/transform/helpers/transform_cte.cpp",
        "duckdb/src/parser/transform/helpers/transform_groupby.cpp",
        "duckdb/src/parser/transform/helpers/transform_orderby.cpp",
        "duckdb/src/parser/transform/helpers/transform_sample.cpp",
        "duckdb/src/parser/transform/helpers/transform_typename.cpp",
        "duckdb/src/parser/transform/statement/transform_alter_sequence.cpp",
        "duckdb/src/parser/transform/statement/transform_alter_table.cpp",
        "duckdb/src/parser/transform/statement/transform_attach.cpp",
        "duckdb/src/parser/transform/statement/transform_call.cpp",
        "duckdb/src/parser/transform/statement/transform_checkpoint.cpp",
        "duckdb/src/parser/transform/statement/transform_copy.cpp",
        "duckdb/src/parser/transform/statement/transform_create_function.cpp",
        "duckdb/src/parser/transform/statement/transform_create_index.cpp",
        "duckdb/src/parser/transform/statement/transform_create_schema.cpp",
        "duckdb/src/parser/transform/statement/transform_create_sequence.cpp",
        "duckdb/src/parser/transform/statement/transform_create_table.cpp",
        "duckdb/src/parser/transform/statement/transform_create_table_as.cpp",
        "duckdb/src/parser/transform/statement/transform_create_type.cpp",
        "duckdb/src/parser/transform/statement/transform_create_view.cpp",
        "duckdb/src/parser/transform/statement/transform_delete.cpp",
        "duckdb/src/parser/transform/statement/transform_detach.cpp",
        "duckdb/src/parser/transform/statement/transform_drop.cpp",
        "duckdb/src/parser/transform/statement/transform_explain.cpp",
        "duckdb/src/parser/transform/statement/transform_export.cpp",
        "duckdb/src/parser/transform/statement/transform_import.cpp",
        "duckdb/src/parser/transform/statement/transform_insert.cpp",
        "duckdb/src/parser/transform/statement/transform_load.cpp",
        "duckdb/src/parser/transform/statement/transform_pivot_stmt.cpp",
        "duckdb/src/parser/transform/statement/transform_pragma.cpp",
        "duckdb/src/parser/transform/statement/transform_prepare.cpp",
        "duckdb/src/parser/transform/statement/transform_rename.cpp",
        "duckdb/src/parser/transform/statement/transform_select.cpp",
        "duckdb/src/parser/transform/statement/transform_select_node.cpp",
        "duckdb/src/parser/transform/statement/transform_set.cpp",
        "duckdb/src/parser/transform/statement/transform_show.cpp",
        "duckdb/src/parser/transform/statement/transform_show_select.cpp",
        "duckdb/src/parser/transform/statement/transform_transaction.cpp",
        "duckdb/src/parser/transform/statement/transform_update.cpp",
        "duckdb/src/parser/transform/statement/transform_upsert.cpp",
        "duckdb/src/parser/transform/statement/transform_use.cpp",
        "duckdb/src/parser/transform/statement/transform_vacuum.cpp",
        "duckdb/src/parser/transform/tableref/transform_base_tableref.cpp",
        "duckdb/src/parser/transform/tableref/transform_from.cpp",
        "duckdb/src/parser/transform/tableref/transform_join.cpp",
        "duckdb/src/parser/transform/tableref/transform_pivot.cpp",
        "duckdb/src/parser/transform/tableref/transform_subquery.cpp",
        "duckdb/src/parser/transform/tableref/transform_table_function.cpp",
        "duckdb/src/parser/transform/tableref/transform_tableref.cpp",
        "duckdb/src/planner/bind_context.cpp",
        "duckdb/src/planner/binder.cpp",
        "duckdb/src/planner/bound_result_modifier.cpp",
        "duckdb/src/planner/expression.cpp",
        "duckdb/src/planner/expression_binder.cpp",
        "duckdb/src/planner/expression_iterator.cpp",
        "duckdb/src/planner/joinside.cpp",
        "duckdb/src/planner/logical_operator.cpp",
        "duckdb/src/planner/logical_operator_visitor.cpp",
        "duckdb/src/planner/plan_serialization.cpp",
        "duckdb/src/planner/planner.cpp",
        "duckdb/src/planner/pragma_handler.cpp",
        "duckdb/src/planner/table_binding.cpp",
        "duckdb/src/planner/table_filter.cpp",
        "duckdb/src/planner/binder/expression/bind_aggregate_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_between_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_case_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_cast_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_collate_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_columnref_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_comparison_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_conjunction_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_constant_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_function_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_lambda.cpp",
        "duckdb/src/planner/binder/expression/bind_macro_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_operator_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_parameter_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_positional_reference_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_star_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_subquery_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_unnest_expression.cpp",
        "duckdb/src/planner/binder/expression/bind_window_expression.cpp",
        "duckdb/src/planner/binder/query_node/bind_recursive_cte_node.cpp",
        "duckdb/src/planner/binder/query_node/bind_select_node.cpp",
        "duckdb/src/planner/binder/query_node/bind_setop_node.cpp",
        "duckdb/src/planner/binder/query_node/bind_table_macro_node.cpp",
        "duckdb/src/planner/binder/query_node/plan_query_node.cpp",
        "duckdb/src/planner/binder/query_node/plan_recursive_cte_node.cpp",
        "duckdb/src/planner/binder/query_node/plan_select_node.cpp",
        "duckdb/src/planner/binder/query_node/plan_setop.cpp",
        "duckdb/src/planner/binder/query_node/plan_subquery.cpp",
        "duckdb/src/planner/binder/statement/bind_attach.cpp",
        "duckdb/src/planner/binder/statement/bind_call.cpp",
        "duckdb/src/planner/binder/statement/bind_copy.cpp",
        "duckdb/src/planner/binder/statement/bind_create.cpp",
        "duckdb/src/planner/binder/statement/bind_create_table.cpp",
        "duckdb/src/planner/binder/statement/bind_delete.cpp",
        "duckdb/src/planner/binder/statement/bind_detach.cpp",
        "duckdb/src/planner/binder/statement/bind_drop.cpp",
        "duckdb/src/planner/binder/statement/bind_execute.cpp",
        "duckdb/src/planner/binder/statement/bind_explain.cpp",
        "duckdb/src/planner/binder/statement/bind_export.cpp",
        "duckdb/src/planner/binder/statement/bind_extension.cpp",
        "duckdb/src/planner/binder/statement/bind_insert.cpp",
        "duckdb/src/planner/binder/statement/bind_load.cpp",
        "duckdb/src/planner/binder/statement/bind_logical_plan.cpp",
        "duckdb/src/planner/binder/statement/bind_pragma.cpp",
        "duckdb/src/planner/binder/statement/bind_prepare.cpp",
        "duckdb/src/planner/binder/statement/bind_relation.cpp",
        "duckdb/src/planner/binder/statement/bind_select.cpp",
        "duckdb/src/planner/binder/statement/bind_set.cpp",
        "duckdb/src/planner/binder/statement/bind_show.cpp",
        "duckdb/src/planner/binder/statement/bind_simple.cpp",
        "duckdb/src/planner/binder/statement/bind_summarize.cpp",
        "duckdb/src/planner/binder/statement/bind_update.cpp",
        "duckdb/src/planner/binder/statement/bind_vacuum.cpp",
        "duckdb/src/planner/binder/tableref/bind_basetableref.cpp",
        "duckdb/src/planner/binder/tableref/bind_emptytableref.cpp",
        "duckdb/src/planner/binder/tableref/bind_expressionlistref.cpp",
        "duckdb/src/planner/binder/tableref/bind_joinref.cpp",
        "duckdb/src/planner/binder/tableref/bind_named_parameters.cpp",
        "duckdb/src/planner/binder/tableref/bind_pivot.cpp",
        "duckdb/src/planner/binder/tableref/bind_subqueryref.cpp",
        "duckdb/src/planner/binder/tableref/bind_table_function.cpp",
        "duckdb/src/planner/binder/tableref/plan_basetableref.cpp",
        "duckdb/src/planner/binder/tableref/plan_cteref.cpp",
        "duckdb/src/planner/binder/tableref/plan_dummytableref.cpp",
        "duckdb/src/planner/binder/tableref/plan_expressionlistref.cpp",
        "duckdb/src/planner/binder/tableref/plan_joinref.cpp",
        "duckdb/src/planner/binder/tableref/plan_pivotref.cpp",
        "duckdb/src/planner/binder/tableref/plan_subqueryref.cpp",
        "duckdb/src/planner/binder/tableref/plan_table_function.cpp",
        "duckdb/src/planner/expression/bound_aggregate_expression.cpp",
        "duckdb/src/planner/expression/bound_between_expression.cpp",
        "duckdb/src/planner/expression/bound_case_expression.cpp",
        "duckdb/src/planner/expression/bound_cast_expression.cpp",
        "duckdb/src/planner/expression/bound_columnref_expression.cpp",
        "duckdb/src/planner/expression/bound_comparison_expression.cpp",
        "duckdb/src/planner/expression/bound_conjunction_expression.cpp",
        "duckdb/src/planner/expression/bound_constant_expression.cpp",
        "duckdb/src/planner/expression/bound_default_expression.cpp",
        "duckdb/src/planner/expression/bound_expression.cpp",
        "duckdb/src/planner/expression/bound_function_expression.cpp",
        "duckdb/src/planner/expression/bound_lambda_expression.cpp",
        "duckdb/src/planner/expression/bound_lambdaref_expression.cpp",
        "duckdb/src/planner/expression/bound_operator_expression.cpp",
        "duckdb/src/planner/expression/bound_parameter_expression.cpp",
        "duckdb/src/planner/expression/bound_reference_expression.cpp",
        "duckdb/src/planner/expression/bound_subquery_expression.cpp",
        "duckdb/src/planner/expression/bound_unnest_expression.cpp",
        "duckdb/src/planner/expression/bound_window_expression.cpp",
        "duckdb/src/planner/expression_binder/aggregate_binder.cpp",
        "duckdb/src/planner/expression_binder/alter_binder.cpp",
        "duckdb/src/planner/expression_binder/base_select_binder.cpp",
        "duckdb/src/planner/expression_binder/check_binder.cpp",
        "duckdb/src/planner/expression_binder/column_alias_binder.cpp",
        "duckdb/src/planner/expression_binder/constant_binder.cpp",
        "duckdb/src/planner/expression_binder/group_binder.cpp",
        "duckdb/src/planner/expression_binder/having_binder.cpp",
        "duckdb/src/planner/expression_binder/index_binder.cpp",
        "duckdb/src/planner/expression_binder/insert_binder.cpp",
        "duckdb/src/planner/expression_binder/lateral_binder.cpp",
        "duckdb/src/planner/expression_binder/order_binder.cpp",
        "duckdb/src/planner/expression_binder/qualify_binder.cpp",
        "duckdb/src/planner/expression_binder/relation_binder.cpp",
        "duckdb/src/planner/expression_binder/returning_binder.cpp",
        "duckdb/src/planner/expression_binder/select_binder.cpp",
        "duckdb/src/planner/expression_binder/table_function_binder.cpp",
        "duckdb/src/planner/expression_binder/update_binder.cpp",
        "duckdb/src/planner/expression_binder/where_binder.cpp",
        "duckdb/src/planner/filter/conjunction_filter.cpp",
        "duckdb/src/planner/filter/constant_filter.cpp",
        "duckdb/src/planner/filter/null_filter.cpp",
        "duckdb/src/planner/operator/logical_aggregate.cpp",
        "duckdb/src/planner/operator/logical_any_join.cpp",
        "duckdb/src/planner/operator/logical_asof_join.cpp",
        "duckdb/src/planner/operator/logical_column_data_get.cpp",
        "duckdb/src/planner/operator/logical_comparison_join.cpp",
        "duckdb/src/planner/operator/logical_copy_to_file.cpp",
        "duckdb/src/planner/operator/logical_create.cpp",
        "duckdb/src/planner/operator/logical_create_index.cpp",
        "duckdb/src/planner/operator/logical_create_table.cpp",
        "duckdb/src/planner/operator/logical_cross_product.cpp",
        "duckdb/src/planner/operator/logical_cteref.cpp",
        "duckdb/src/planner/operator/logical_delete.cpp",
        "duckdb/src/planner/operator/logical_delim_get.cpp",
        "duckdb/src/planner/operator/logical_delim_join.cpp",
        "duckdb/src/planner/operator/logical_distinct.cpp",
        "duckdb/src/planner/operator/logical_dummy_scan.cpp",
        "duckdb/src/planner/operator/logical_empty_result.cpp",
        "duckdb/src/planner/operator/logical_execute.cpp",
        "duckdb/src/planner/operator/logical_explain.cpp",
        "duckdb/src/planner/operator/logical_export.cpp",
        "duckdb/src/planner/operator/logical_expression_get.cpp",
        "duckdb/src/planner/operator/logical_extension_operator.cpp",
        "duckdb/src/planner/operator/logical_filter.cpp",
        "duckdb/src/planner/operator/logical_get.cpp",
        "duckdb/src/planner/operator/logical_insert.cpp",
        "duckdb/src/planner/operator/logical_join.cpp",
        "duckdb/src/planner/operator/logical_limit.cpp",
        "duckdb/src/planner/operator/logical_limit_percent.cpp",
        "duckdb/src/planner/operator/logical_order.cpp",
        "duckdb/src/planner/operator/logical_pivot.cpp",
        "duckdb/src/planner/operator/logical_positional_join.cpp",
        "duckdb/src/planner/operator/logical_pragma.cpp",
        "duckdb/src/planner/operator/logical_prepare.cpp",
        "duckdb/src/planner/operator/logical_projection.cpp",
        "duckdb/src/planner/operator/logical_recursive_cte.cpp",
        "duckdb/src/planner/operator/logical_reset.cpp",
        "duckdb/src/planner/operator/logical_sample.cpp",
        "duckdb/src/planner/operator/logical_set.cpp",
        "duckdb/src/planner/operator/logical_set_operation.cpp",
        "duckdb/src/planner/operator/logical_show.cpp",
        "duckdb/src/planner/operator/logical_simple.cpp",
        "duckdb/src/planner/operator/logical_top_n.cpp",
        "duckdb/src/planner/operator/logical_unconditional_join.cpp",
        "duckdb/src/planner/operator/logical_unnest.cpp",
        "duckdb/src/planner/operator/logical_update.cpp",
        "duckdb/src/planner/operator/logical_window.cpp",
        "duckdb/src/planner/parsed_data/bound_create_table_info.cpp",
        "duckdb/src/planner/subquery/flatten_dependent_join.cpp",
        "duckdb/src/planner/subquery/has_correlated_expressions.cpp",
        "duckdb/src/planner/subquery/rewrite_correlated_expressions.cpp",
        "duckdb/src/storage/arena_allocator.cpp",
        "duckdb/src/storage/block.cpp",
        "duckdb/src/storage/buffer_manager.cpp",
        "duckdb/src/storage/checkpoint_manager.cpp",
        "duckdb/src/storage/data_table.cpp",
        "duckdb/src/storage/index.cpp",
        "duckdb/src/storage/local_storage.cpp",
        "duckdb/src/storage/magic_bytes.cpp",
        "duckdb/src/storage/meta_block_reader.cpp",
        "duckdb/src/storage/meta_block_writer.cpp",
        "duckdb/src/storage/optimistic_data_writer.cpp",
        "duckdb/src/storage/partial_block_manager.cpp",
        "duckdb/src/storage/single_file_block_manager.cpp",
        "duckdb/src/storage/standard_buffer_manager.cpp",
        "duckdb/src/storage/storage_info.cpp",
        "duckdb/src/storage/storage_lock.cpp",
        "duckdb/src/storage/storage_manager.cpp",
        "duckdb/src/storage/table_index_list.cpp",
        "duckdb/src/storage/wal_replay.cpp",
        "duckdb/src/storage/write_ahead_log.cpp",
        "duckdb/src/storage/buffer/block_handle.cpp",
        "duckdb/src/storage/buffer/block_manager.cpp",
        "duckdb/src/storage/buffer/buffer_handle.cpp",
        "duckdb/src/storage/buffer/buffer_pool.cpp",
        "duckdb/src/storage/buffer/buffer_pool_reservation.cpp",
        "duckdb/src/storage/checkpoint/row_group_writer.cpp",
        "duckdb/src/storage/checkpoint/table_data_reader.cpp",
        "duckdb/src/storage/checkpoint/table_data_writer.cpp",
        "duckdb/src/storage/checkpoint/write_overflow_strings_to_disk.cpp",
        "duckdb/src/storage/compression/bitpacking.cpp",
        "duckdb/src/storage/compression/dictionary_compression.cpp",
        "duckdb/src/storage/compression/fixed_size_uncompressed.cpp",
        "duckdb/src/storage/compression/fsst.cpp",
        "duckdb/src/storage/compression/numeric_constant.cpp",
        "duckdb/src/storage/compression/patas.cpp",
        "duckdb/src/storage/compression/rle.cpp",
        "duckdb/src/storage/compression/string_uncompressed.cpp",
        "duckdb/src/storage/compression/uncompressed.cpp",
        "duckdb/src/storage/compression/validity_uncompressed.cpp",
        "duckdb/src/storage/compression/chimp/bit_reader.cpp",
        "duckdb/src/storage/compression/chimp/chimp.cpp",
        "duckdb/src/storage/compression/chimp/chimp_constants.cpp",
        "duckdb/src/storage/compression/chimp/flag_buffer.cpp",
        "duckdb/src/storage/compression/chimp/leading_zero_buffer.cpp",
        "duckdb/src/storage/statistics/base_statistics.cpp",
        "duckdb/src/storage/statistics/column_statistics.cpp",
        "duckdb/src/storage/statistics/distinct_statistics.cpp",
        "duckdb/src/storage/statistics/list_stats.cpp",
        "duckdb/src/storage/statistics/numeric_stats.cpp",
        "duckdb/src/storage/statistics/numeric_stats_union.cpp",
        "duckdb/src/storage/statistics/segment_statistics.cpp",
        "duckdb/src/storage/statistics/string_stats.cpp",
        "duckdb/src/storage/statistics/struct_stats.cpp",
        "duckdb/src/storage/table/chunk_info.cpp",
        "duckdb/src/storage/table/column_checkpoint_state.cpp",
        "duckdb/src/storage/table/column_data.cpp",
        "duckdb/src/storage/table/column_data_checkpointer.cpp",
        "duckdb/src/storage/table/column_segment.cpp",
        "duckdb/src/storage/table/list_column_data.cpp",
        "duckdb/src/storage/table/persistent_table_data.cpp",
        "duckdb/src/storage/table/row_group.cpp",
        "duckdb/src/storage/table/row_group_collection.cpp",
        "duckdb/src/storage/table/scan_state.cpp",
        "duckdb/src/storage/table/standard_column_data.cpp",
        "duckdb/src/storage/table/struct_column_data.cpp",
        "duckdb/src/storage/table/table_statistics.cpp",
        "duckdb/src/storage/table/update_segment.cpp",
        "duckdb/src/storage/table/validity_column_data.cpp",
        "duckdb/src/transaction/cleanup_state.cpp",
        "duckdb/src/transaction/commit_state.cpp",
        "duckdb/src/transaction/duck_transaction.cpp",
        "duckdb/src/transaction/duck_transaction_manager.cpp",
        "duckdb/src/transaction/meta_transaction.cpp",
        "duckdb/src/transaction/rollback_state.cpp",
        "duckdb/src/transaction/transaction.cpp",
        "duckdb/src/transaction/transaction_context.cpp",
        "duckdb/src/transaction/transaction_manager.cpp",
        "duckdb/src/transaction/undo_buffer.cpp",
        "duckdb/src/verification/copied_statement_verifier.cpp",
        "duckdb/src/verification/deserialized_statement_verifier.cpp",
        "duckdb/src/verification/deserialized_statement_verifier_v2.cpp",
        "duckdb/src/verification/external_statement_verifier.cpp",
        "duckdb/src/verification/no_operator_caching_verifier.cpp",
        "duckdb/src/verification/parsed_statement_verifier.cpp",
        "duckdb/src/verification/prepared_statement_verifier.cpp",
        "duckdb/src/verification/statement_verifier.cpp",
        "duckdb/src/verification/unoptimized_statement_verifier.cpp",
    }, &.{});
    duckdb_static.addIncludePath("duckdb/src/include");
    duckdb_static.addIncludePath("duckdb/third_party/jaro_winkler");
    duckdb_static.addIncludePath("duckdb/third_party/utf8proc/include");
    duckdb_static.addIncludePath("duckdb/third_party/re2");
    duckdb_static.addIncludePath("duckdb/third_party/httplib");
    duckdb_static.addIncludePath("duckdb/third_party/mbedtls/include");
    duckdb_static.addIncludePath("duckdb/third_party/fastpforlib");
    duckdb_static.addIncludePath("duckdb/third_party/miniz");
    duckdb_static.addIncludePath("duckdb/third_party/fsst");
    duckdb_static.addIncludePath("duckdb/third_party/concurrentqueue");
    duckdb_static.addIncludePath("duckdb/third_party/fmt/include");
    duckdb_static.addIncludePath("duckdb/third_party/hyperloglog");
    duckdb_static.addIncludePath("duckdb/third_party/fast_float");
    duckdb_static.addIncludePath("duckdb/third_party/pcg");
    duckdb_static.addIncludePath("duckdb/third_party/libpg_query/include");
    duckdb_static.addIncludePath("duckdb/third_party/tdigest");
    duckdb_static.linkLibrary(duckdb_fsst);
    duckdb_static.linkLibrary(duckdb_fmt);
    duckdb_static.linkLibrary(duckdb_pg_query);
    duckdb_static.linkLibrary(duckdb_re2);
    duckdb_static.linkLibrary(duckdb_miniz);
    duckdb_static.linkLibrary(duckdb_utf8proc);
    duckdb_static.linkLibrary(duckdb_hyperloglog);
    duckdb_static.linkLibrary(duckdb_fastpforlib);
    duckdb_static.linkLibrary(duckdb_mbedtls);
    // // TODO:
    // // - set this version at build time from the git submodule
    duckdb_static.defineCMacro("DUCKDB_VERSION", "\"v0.8.1-dev72\"");
    // // TODO:
    // // - set this version at build time from the git submodule
    duckdb_static.defineCMacro("DUCKDB_SOURCE_ID", "\"5c94293b1302d9a6f01f81f3c6aeaa0f4ef3fb78\"");
    duckdb_static.linkLibCpp();
    duckdb_static.force_pic = true;
    // duckdb_static.strip = true;
    b.installArtifact(duckdb_static);

    // ==============================
    // Tools
    // ==============================
    // const sqlite3_api_wrapper = b.addStaticLibrary(.{
    //     .name = "sqlite3_api_wrapper",
    //     .target = target,
    //     .optimize = optimize,
    // });
    // sqlite3_api_wrapper.addCSourceFiles(&.{
    //     "duckdb/tools/sqlite3_api_wrapper/sqlite3_api_wrapper.cpp",
    // }, &.{});
    // sqlite3_api_wrapper.addIncludePath("duckdb/tools/sqlite3_api_wrapper/include");
    // sqlite3_api_wrapper.addIncludePath("duckdb/tools/sqlite3_api_wrapper/sqlite3_udf_api/include");
    // sqlite3_api_wrapper.addIncludePath("duckdb/third_party/utf8proc/include");
    // sqlite3_api_wrapper.addIncludePath("duckdb/src/include");
    // sqlite3_api_wrapper.linkLibCpp();
    // sqlite3_api_wrapper.force_pic = true;
    // // sqlite3_api_wrapper.strip = true;
    // b.installArtifact(sqlite3_api_wrapper);

// include_directories(include)
// add_subdirectory(sqlite3)
//
// include_directories(sqlite3_udf_api/include)
// add_subdirectory(sqlite3_udf_api)
//
// add_extension_definitions()
// add_definitions(-DSQLITE_SHELL_IS_UTF8)
// add_definitions(-DUSE_DUCKDB_SHELL_WRAPPER)
//
// include_directories(../../third_party/utf8proc/include)
//
// if(NOT BUILD_AUTOCOMPLETE_EXTENSION AND NOT DISABLE_BUILTIN_EXTENSIONS)
//   include_directories(../../extension/autocomplete/include)
//   set(ALL_OBJECT_FILES
//       ${ALL_OBJECT_FILES}
//       ../../extension/autocomplete/sql_auto_complete-extension.cpp)
//   add_definitions(-DSHELL_INLINE_AUTOCOMPLETE)
// endif()
// set(SQLITE_API_WRAPPER_FILES sqlite3_api_wrapper.cpp ${ALL_OBJECT_FILES})
//
// add_library(sqlite3_api_wrapper_static STATIC ${SQLITE_API_WRAPPER_FILES})
// target_link_libraries(sqlite3_api_wrapper_static duckdb_static)
// if(NOT AMALGAMATION_BUILD)
//   target_link_libraries(sqlite3_api_wrapper_static duckdb_utf8proc)
// endif()
// link_threads(sqlite3_api_wrapper_static)
//
// if(NOT WIN32)
//   add_library(sqlite3_api_wrapper SHARED ${SQLITE_API_WRAPPER_FILES})
//   target_link_libraries(sqlite3_api_wrapper duckdb ${DUCKDB_EXTRA_LINK_FLAGS})
//   link_threads(sqlite3_api_wrapper)
// endif()
//
// include_directories(../../third_party/catch)
//
// include_directories(test/include)
// add_subdirectory(test)
//
// add_executable(test_sqlite3_api_wrapper ${SQLITE_TEST_FILES})
// if(WIN32)
//   target_link_libraries(test_sqlite3_api_wrapper sqlite3_api_wrapper_static)
// else()
//   target_link_libraries(test_sqlite3_api_wrapper sqlite3_api_wrapper)
// endif()
    const sqlite3_api_wrapper_static = b.addStaticLibrary(.{
        .name = "sqlite3_api_wrapper_static",
        .target = target,
        .optimize = optimize,
    });
    sqlite3_api_wrapper_static.addCSourceFiles(&.{
        "duckdb/tools/sqlite3_api_wrapper/sqlite3_api_wrapper.cpp",
        // TODO:
        // - only include for windows build
        // "duckdb/tools/sqlite3_api_wrapper/sqlite3/os_win.c",
        "duckdb/tools/sqlite3_api_wrapper/sqlite3/printf.c",
        "duckdb/tools/sqlite3_api_wrapper/sqlite3/strglob.c",
        "duckdb/tools/sqlite3_api_wrapper/sqlite3_udf_api/cast_sqlite.cpp",
        "duckdb/tools/sqlite3_api_wrapper/sqlite3_udf_api/sqlite3_udf_wrapper.cpp",
    }, &.{});
    sqlite3_api_wrapper_static.addIncludePath("duckdb/tools/sqlite3_api_wrapper/include");
    sqlite3_api_wrapper_static.addIncludePath("duckdb/tools/sqlite3_api_wrapper/sqlite3_udf_api/include");
    sqlite3_api_wrapper_static.addIncludePath("duckdb/third_party/utf8proc/include");
    sqlite3_api_wrapper_static.addIncludePath("duckdb/src/include");
    sqlite3_api_wrapper_static.defineCMacro("USE_DUCKDB_SHELL_WRAPPER", null);
    // sqlite3_api_wrapper_static.linkLibrary(duckdb_sqlite3);
    sqlite3_api_wrapper_static.linkLibrary(duckdb_static);
    sqlite3_api_wrapper_static.linkLibCpp();
    sqlite3_api_wrapper_static.force_pic = true;
    // sqlite3_api_wrapper.strip = true;
    b.installArtifact(sqlite3_api_wrapper_static);

// add_definitions(-DSQLITE_OMIT_LOAD_EXTENSION=1)
//
// set(SHELL_SOURCES shell.c)
// if(NOT WIN32)
//   add_definitions(-DHAVE_LINENOISE=1)
//   set(SHELL_SOURCES ${SHELL_SOURCES} linenoise.cpp)
//   include_directories(../../third_party/utf8proc/include)
// endif()
//
// option(STATIC_LIBCPP "Statically link CLI to libc++" FALSE)
//
// include_directories(include)
// include_directories(../sqlite3_api_wrapper/include)
// add_executable(shell ${SHELL_SOURCES})
// target_link_libraries(shell sqlite3_api_wrapper_static
//                       ${DUCKDB_EXTRA_LINK_FLAGS})
// link_threads(shell)
// if(STATIC_LIBCPP)
//   message("Statically linking CLI")
//   target_link_libraries(shell -static-libstdc++ -static-libgcc)
// endif()
//
// if(NOT AMALGAMATION_BUILD AND NOT WIN32)
//   target_link_libraries(shell duckdb_utf8proc)
// endif()
//
// set_target_properties(shell PROPERTIES OUTPUT_NAME duckdb)
// set_target_properties(shell PROPERTIES RUNTIME_OUTPUT_DIRECTORY
//                                        ${PROJECT_BINARY_DIR})
//
// install(TARGETS shell RUNTIME DESTINATION "${INSTALL_BIN_DIR}")
    // ==============================
    // Shell
    // ==============================
    if (want_build_shell) {
        const shell = b.addExecutable(.{
            .name = "duckdb",
            .target = target,
            .optimize = optimize,
        });
        shell.addCSourceFiles(&.{
            "duckdb/tools/shell/shell.c",
        }, &.{});
        shell.addIncludePath("duckdb/tools/shell/include");
        shell.addIncludePath("duckdb/tools/sqlite3_api_wrapper/include");
        // shell.defineCMacro("DUCKDB_MAIN_LIBRARY",null);
        // shell.defineCMacro("DUCKDB",null);
        // shell.linkLibrary(duckdb_fastpforlib);
        // shell.linkLibrary(duckdb_fmt);
        // shell.linkLibrary(duckdb_fsst);
        // shell.linkLibrary(duckdb_hyperloglog);
        // shell.linkLibrary(duckdb_mbedtls);
        // shell.linkLibrary(duckdb_miniz);
        // shell.linkLibrary(duckdb_pg_query);
        // shell.linkLibrary(duckdb_re2);
        shell.linkLibrary(sqlite3_api_wrapper_static);
        // shell.linkLibrary(duckdb_static);
        // shell.linkLibrary(duckdb_utf8proc);
        // shell.linkLibrary(parquet_extension);
        // shell.linkLibrary(httpfs_extension);
        // shell.linkLibrary(icu_extension);
        // shell.linkLibC();
        b.installArtifact(shell);
    }

    // // ==============================
    // // Test
    // // ==============================
    // const unittest = b.addExecutable(.{
    //     .name = "unittest",
    //     .target = target,
    //     .optimize = optimize,
    // });
    // unittest.addCSourceFiles(&.{
    //     "duckdb/test/unittest.cpp",
    // }, &.{});
    // unittest.addIncludePath("duckdb/third_party/catch");
    // unittest.addIncludePath("duckdb/src/include");
    // unittest.addIncludePath("duckdb/test/include");
    // unittest.defineCMacro( "DUCKDB_ROOT_DIRECTORY" , "\"/home/alex/workspace/rupurt/record-duckdb-extension/duckdb/unittest\"");
    // unittest.linkLibCpp();
    // b.installArtifact(unittest);

    // ==============================
    // Examples
    // ==============================
    const imdb = b.addStaticLibrary(.{
        .name = "imdb",
        .target = target,
        .optimize = optimize,
    });
    imdb.addCSourceFiles(&.{
        "duckdb/third_party/imdb/imdb.cpp",
    }, &.{});
    imdb.addIncludePath("duckdb/third_party/imdb/include");
    imdb.addIncludePath("duckdb/src/include");
    imdb.linkLibCpp();
    // imdb.force_pic = true;
    // imdb.strip = true;
    b.installArtifact(imdb);
}
