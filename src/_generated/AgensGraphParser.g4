parser grammar AgensGraphParser;

options {
    tokenVocab=AgensGraphLexer;
}
// to start parsing, it is recommended to use only rules with EOF
// this eliminates the ambiguous parsing options and speeds up the process
/******* Start symbols *******/

pg_sql
    : PG_BOM? PG_SEMI_COLON* (pg_statement (PG_SEMI_COLON+ | EOF))* EOF
    ;

pg_qname_parser
    : pg_schema_qualified_name EOF
    ;

pg_function_args_parser
    : pg_schema_qualified_name? pg_function_args EOF
    ;

pg_vex_eof
    : pg_vex (PG_COMMA pg_vex)* EOF
    ;

pg_plpgsql_function
    : pg_comp_options? pg_function_block PG_SEMI_COLON? EOF
    ;

pg_plpgsql_function_test_list
    : (pg_comp_options? pg_function_block PG_SEMI_COLON)* EOF
    ;

/******* END Start symbols *******/

pg_statement
    : pg_data_statement
    | pg_schema_statement
    | pg_script_statement
    ;

pg_data_statement
    : pg_select_stmt
    | pg_insert_stmt_for_psql
    | pg_update_stmt_for_psql
    | pg_delete_stmt_for_psql
    ;

pg_script_statement
    : pg_script_transaction
    | pg_script_additional
    ;

pg_script_transaction
    : (PG_START PG_TRANSACTION | PG_BEGIN (PG_WORK | PG_TRANSACTION)?) (pg_transaction_mode (PG_COMMA pg_transaction_mode)*)?
    | (PG_COMMIT | PG_END | PG_ABORT | PG_ROLLBACK) (PG_WORK | PG_TRANSACTION)? (PG_AND PG_NO? PG_CHAIN)?
    | (PG_COMMIT PG_PREPARED | PG_PREPARE PG_TRANSACTION) PG_Character_String_Literal
    | (PG_SAVEPOINT | PG_RELEASE PG_SAVEPOINT?) pg_identifier
    | PG_ROLLBACK PG_PREPARED PG_Character_String_Literal
    | PG_ROLLBACK (PG_WORK | PG_TRANSACTION)? PG_TO PG_SAVEPOINT? pg_identifier
    | pg_lock_table
    ;

pg_transaction_mode
    : PG_ISOLATION PG_LEVEL (PG_SERIALIZABLE | PG_REPEATABLE PG_READ | PG_READ PG_COMMITTED | PG_READ PG_UNCOMMITTED)
    | PG_READ PG_WRITE
    | PG_READ PG_ONLY
    | PG_NOT? PG_DEFERRABLE
    ;

pg_lock_table
    : PG_LOCK PG_TABLE? pg_only_table_multiply (PG_COMMA pg_only_table_multiply)* (PG_IN pg_lock_mode PG_MODE)? PG_NOWAIT?
    ;

pg_lock_mode
    : (PG_ROW | PG_ACCESS) PG_SHARE
    | PG_ROW PG_EXCLUSIVE
    | PG_SHARE (PG_ROW | PG_UPDATE) PG_EXCLUSIVE
    | PG_SHARE
    | PG_ACCESS? PG_EXCLUSIVE
    ;

pg_script_additional
    : pg_additional_statement
    | PG_VACUUM pg_vacuum_mode pg_table_cols_list?
    | (PG_FETCH | PG_MOVE) pg_fetch_move_direction? (PG_FROM | PG_IN)? pg_identifier
    | PG_CLOSE (pg_identifier | PG_ALL)
    | PG_CALL pg_function_call
    | PG_DISCARD (PG_ALL | PG_PLANS | PG_SEQUENCES | PG_TEMPORARY | PG_TEMP)
    | pg_declare_statement
    | pg_execute_statement
    | pg_explain_statement
    | pg_show_statement
    ;

pg_additional_statement
    : pg_anonymous_block
    | PG_LISTEN pg_identifier
    | PG_UNLISTEN (pg_identifier | PG_MULTIPLY)
    | PG_ANALYZE (PG_LEFT_PAREN pg_analyze_mode (PG_COMMA pg_analyze_mode)* PG_RIGHT_PAREN | PG_VERBOSE)? pg_table_cols_list?
    | PG_CLUSTER PG_VERBOSE? (pg_identifier PG_ON pg_schema_qualified_name | pg_schema_qualified_name (PG_USING pg_identifier)?)?
    | PG_CHECKPOINT
    | PG_LOAD PG_Character_String_Literal
    | PG_DEALLOCATE PG_PREPARE? (pg_identifier | PG_ALL)
    | PG_REINDEX (PG_LEFT_PAREN PG_VERBOSE PG_RIGHT_PAREN)? (PG_INDEX | PG_TABLE | PG_SCHEMA | PG_DATABASE | PG_SYSTEM) PG_CONCURRENTLY? pg_schema_qualified_name
    | PG_RESET ((pg_identifier PG_DOT)? pg_identifier | PG_TIME PG_ZONE | PG_SESSION PG_AUTHORIZATION | PG_ALL)
    | PG_REFRESH PG_MATERIALIZED PG_VIEW PG_CONCURRENTLY? pg_schema_qualified_name (PG_WITH PG_NO? PG_DATA)?
    | PG_PREPARE pg_identifier (PG_LEFT_PAREN pg_data_type (PG_COMMA pg_data_type)* PG_RIGHT_PAREN)? PG_AS pg_data_statement
    | PG_REASSIGN PG_OWNED PG_BY pg_user_name (PG_COMMA pg_user_name)* PG_TO pg_user_name
    | pg_copy_statement
    | pg_truncate_stmt
    | pg_notify_stmt
    ;

pg_explain_statement
    : PG_EXPLAIN (PG_ANALYZE? PG_VERBOSE? | PG_LEFT_PAREN pg_explain_option (PG_COMMA pg_explain_option)* PG_RIGHT_PAREN) pg_explain_query;

pg_explain_query
    : pg_data_statement
    | pg_execute_statement
    | pg_declare_statement
    | PG_CREATE (pg_create_table_as_statement | pg_create_view_statement)
    ;

pg_execute_statement
    : PG_EXECUTE pg_identifier (PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN)?
    ;

pg_declare_statement
    : PG_DECLARE pg_identifier PG_BINARY? PG_INSENSITIVE? (PG_NO? PG_SCROLL)? PG_CURSOR ((PG_WITH | PG_WITHOUT) PG_HOLD)? PG_FOR pg_select_stmt
    ;

pg_show_statement
    : PG_SHOW ((pg_identifier PG_DOT)? pg_identifier | PG_ALL | PG_TIME PG_ZONE | PG_TRANSACTION PG_ISOLATION PG_LEVEL | PG_SESSION PG_AUTHORIZATION)
    ;

pg_explain_option
    : (PG_ANALYZE | PG_VERBOSE | PG_COSTS | PG_SETTINGS | PG_BUFFERS | PG_WAL | PG_TIMING | PG_SUMMARY) pg_boolean_value?
    | PG_FORMAT (PG_TEXT | PG_XML | PG_JSON | PG_YAML)
    ;

pg_user_name
    : pg_identifier | PG_CURRENT_USER | PG_SESSION_USER
    ;

pg_table_cols_list
    : pg_table_cols (PG_COMMA pg_table_cols)*
    ;

pg_table_cols
    : pg_schema_qualified_name (PG_LEFT_PAREN pg_identifier (PG_COMMA pg_identifier)* PG_RIGHT_PAREN)?
    ;

pg_vacuum_mode
    : PG_LEFT_PAREN pg_vacuum_option (PG_COMMA pg_vacuum_option)* PG_RIGHT_PAREN
    | PG_FULL? PG_FREEZE? PG_VERBOSE? PG_ANALYZE?
    ;

pg_vacuum_option
    : (PG_FULL | PG_FREEZE | PG_VERBOSE | PG_ANALYZE | PG_DISABLE_PAGE_SKIPPING | PG_SKIP_LOCKED | PG_INDEX_CLEANUP | PG_TRUNCATE) pg_boolean_value?
    | PG_PARALLEL PG_NUMBER_LITERAL
    ;

pg_analyze_mode
    : (PG_VERBOSE | PG_SKIP_LOCKED) pg_boolean_value?
    ;

pg_boolean_value
    : PG_TRUE
    | PG_FALSE
    | PG_OFF
    | PG_ON
    | PG_NUMBER_LITERAL
    | pg_character_string // 'true', 'false', 'on', 'off'
    ;

pg_fetch_move_direction
    : PG_NEXT
    | PG_PRIOR
    | PG_FIRST
    | PG_LAST
    | (PG_ABSOLUTE | PG_RELATIVE)? pg_signed_number_literal
    | PG_ALL
    | PG_FORWARD (PG_NUMBER_LITERAL | PG_ALL)?
    | PG_BACKWARD (PG_NUMBER_LITERAL | PG_ALL)?
    ;

pg_schema_statement
    : pg_schema_create
    | pg_schema_alter
    | pg_schema_drop
    ;

pg_schema_create
    : PG_CREATE (pg_create_access_method_statement
    | pg_create_aggregate_statement
    | pg_create_cast_statement
    | pg_create_collation_statement
    | pg_create_conversion_statement
    | pg_create_database_statement
    | pg_create_domain_statement
    | pg_create_event_trigger_statement
    | pg_create_extension_statement
    | pg_create_foreign_data_wrapper_statement
    | pg_create_foreign_table_statement
    | pg_create_fts_configuration_statement
    | pg_create_fts_dictionary_statement
    | pg_create_fts_parser_statement
    | pg_create_fts_template_statement
    | pg_create_function_statement
    | pg_create_group_statement
    | pg_create_index_statement
    | pg_create_language_statement
    | pg_create_operator_class_statement
    | pg_create_operator_family_statement
    | pg_create_operator_statement
    | pg_create_policy_statement
    | pg_create_publication_statement
    | pg_create_rewrite_statement
    | pg_create_schema_statement
    | pg_create_sequence_statement
    | pg_create_server_statement
    | pg_create_statistics_statement
    | pg_create_subscription_statement
    | pg_create_table_as_statement
    | pg_create_table_statement
    | pg_create_tablespace_statement
    | pg_create_transform_statement
    | pg_create_trigger_statement
    | pg_create_type_statement
    | pg_create_user_mapping_statement
    | pg_create_user_or_role_statement
    | pg_create_view_statement
    | ag_create_graph_statement)

    | pg_comment_on_statement
    | pg_rule_common
    | pg_schema_import
    | pg_security_label
    | pg_set_statement
    ;

pg_schema_alter
    : PG_ALTER (pg_alter_aggregate_statement
    | pg_alter_collation_statement
    | pg_alter_conversion_statement
    | pg_alter_default_privileges_statement
    | pg_alter_database_statement
    | pg_alter_domain_statement
    | pg_alter_event_trigger_statement
    | pg_alter_extension_statement
    | pg_alter_foreign_data_wrapper
    | pg_alter_fts_statement
    | pg_alter_function_statement
    | pg_alter_group_statement
    | pg_alter_index_statement
    | pg_alter_language_statement
    | pg_alter_materialized_view_statement
    | pg_alter_operator_class_statement
    | pg_alter_operator_family_statement
    | pg_alter_operator_statement
    | pg_alter_owner_statement
    | pg_alter_policy_statement
    | pg_alter_publication_statement
    | pg_alter_rule_statement
    | pg_alter_schema_statement
    | pg_alter_sequence_statement
    | pg_alter_server_statement
    | pg_alter_statistics_statement
    | pg_alter_subscription_statement
    | pg_alter_table_statement
    | pg_alter_tablespace_statement
    | pg_alter_trigger_statement
    | pg_alter_type_statement
    | pg_alter_user_mapping_statement
    | pg_alter_user_or_role_statement
    | pg_alter_view_statement
    | ag_alter_graph_statement)
    ;

pg_schema_drop
    : PG_DROP (pg_drop_cast_statement
    | pg_drop_database_statement
    | pg_drop_function_statement
    | pg_drop_operator_class_statement
    | pg_drop_operator_family_statement
    | pg_drop_operator_statement
    | pg_drop_owned_statement
    | pg_drop_policy_statement
    | pg_drop_rule_statement
    | pg_drop_statements
    | pg_drop_trigger_statement
    | pg_drop_user_mapping_statement)
    ;

pg_schema_import
    : PG_IMPORT PG_FOREIGN PG_SCHEMA name=pg_identifier
    ((PG_LIMIT PG_TO | PG_EXCEPT) PG_LEFT_PAREN pg_identifier_list PG_RIGHT_PAREN)?
    PG_FROM PG_SERVER pg_identifier PG_INTO pg_identifier
    pg_define_foreign_options?
    ;

pg_alter_function_statement
    : (PG_FUNCTION | PG_PROCEDURE) pg_function_parameters?
      ((pg_function_actions_common | PG_RESET ((pg_identifier PG_DOT)? pg_identifier | PG_ALL))+ PG_RESTRICT?
    | pg_rename_to
    | pg_set_schema
    | PG_NO? PG_DEPENDS PG_ON PG_EXTENSION pg_identifier)
    ;

pg_alter_aggregate_statement
    : PG_AGGREGATE pg_function_parameters (pg_rename_to | pg_set_schema)
    ;

pg_alter_extension_statement
    : PG_EXTENSION pg_identifier pg_alter_extension_action
    ;

pg_alter_extension_action
    : pg_set_schema
    | PG_UPDATE (PG_TO (pg_identifier | pg_character_string))?
    | (PG_ADD | PG_DROP) pg_extension_member_object
    ;

pg_extension_member_object
    : PG_ACCESS PG_METHOD pg_schema_qualified_name
    | PG_AGGREGATE pg_function_parameters
    | PG_CAST PG_LEFT_PAREN pg_schema_qualified_name PG_AS pg_schema_qualified_name PG_RIGHT_PAREN
    | PG_COLLATION pg_identifier
    | PG_CONVERSION pg_identifier
    | PG_DOMAIN pg_schema_qualified_name
    | PG_EVENT PG_TRIGGER pg_identifier
    | PG_FOREIGN PG_DATA PG_WRAPPER pg_identifier
    | PG_FOREIGN PG_TABLE pg_schema_qualified_name
    | PG_FUNCTION pg_function_parameters
    | PG_MATERIALIZED? PG_VIEW pg_schema_qualified_name
    | PG_OPERATOR pg_operator_name
    | PG_OPERATOR PG_CLASS pg_schema_qualified_name PG_USING pg_identifier
    | PG_OPERATOR PG_FAMILY pg_schema_qualified_name PG_USING pg_identifier
    | PG_PROCEDURAL? PG_LANGUAGE pg_identifier
    | PG_PROCEDURE pg_function_parameters
    | PG_ROUTINE pg_function_parameters
    | PG_SCHEMA pg_identifier
    | PG_SEQUENCE pg_schema_qualified_name
    | PG_SERVER pg_identifier
    | PG_TABLE pg_schema_qualified_name
    | PG_TEXT PG_SEARCH PG_CONFIGURATION pg_schema_qualified_name
    | PG_TEXT PG_SEARCH PG_DICTIONARY pg_schema_qualified_name
    | PG_TEXT PG_SEARCH PG_PARSER pg_schema_qualified_name
    | PG_TEXT PG_SEARCH PG_TEMPLATE pg_schema_qualified_name
    | PG_TRANSFORM PG_FOR pg_identifier PG_LANGUAGE pg_identifier
    | PG_TYPE pg_schema_qualified_name
    ;

pg_alter_schema_statement
    : PG_SCHEMA pg_identifier pg_rename_to
    ;

pg_alter_language_statement
    : PG_PROCEDURAL? PG_LANGUAGE name=pg_identifier (pg_rename_to | pg_owner_to)
    ;

pg_alter_table_statement
    : PG_FOREIGN? PG_TABLE pg_if_exists? PG_ONLY? name=pg_schema_qualified_name PG_MULTIPLY?(
        pg_table_action (PG_COMMA pg_table_action)*
        | PG_RENAME PG_COLUMN? pg_identifier PG_TO pg_identifier
        | pg_set_schema
        | pg_rename_to
        | PG_RENAME PG_CONSTRAINT pg_identifier PG_TO pg_identifier
        | PG_ATTACH PG_PARTITION child=pg_schema_qualified_name pg_for_values_bound
        | PG_DETACH PG_PARTITION child=pg_schema_qualified_name)
    ;

pg_table_action
    : PG_ADD PG_COLUMN? pg_if_not_exists? pg_table_column_definition
    | PG_DROP PG_COLUMN? pg_if_exists? column=pg_identifier pg_cascade_restrict?
    | PG_ALTER PG_COLUMN? column=pg_identifier pg_column_action
    | PG_ADD tabl_constraint=pg_constraint_common (PG_NOT not_valid=PG_VALID)?
    | pg_validate_constraint
    | pg_drop_constraint
    | (PG_DISABLE | PG_ENABLE) PG_TRIGGER (trigger_name=pg_schema_qualified_name | PG_ALL | PG_USER)?
    | PG_ENABLE (PG_REPLICA | PG_ALWAYS) PG_TRIGGER trigger_name=pg_schema_qualified_name
    | (PG_DISABLE | PG_ENABLE) PG_RULE rewrite_rule_name=pg_schema_qualified_name
    | PG_ENABLE (PG_REPLICA | PG_ALWAYS) PG_RULE rewrite_rule_name=pg_schema_qualified_name
    | (PG_DISABLE | PG_ENABLE) PG_ROW PG_LEVEL PG_SECURITY
    | PG_NO? PG_FORCE PG_ROW PG_LEVEL PG_SECURITY
    | PG_CLUSTER PG_ON index_name=pg_schema_qualified_name
    | PG_SET PG_WITHOUT (PG_CLUSTER | PG_OIDS)
    | PG_SET PG_WITH PG_OIDS
    | PG_SET (PG_LOGGED | PG_UNLOGGED)
    | PG_SET pg_storage_parameter
    | PG_RESET pg_names_in_parens
    | pg_define_foreign_options
    | PG_INHERIT parent_table=pg_schema_qualified_name
    | PG_NO PG_INHERIT parent_table=pg_schema_qualified_name
    | PG_OF type_name=pg_schema_qualified_name
    | PG_NOT PG_OF
    | pg_owner_to
    | pg_set_tablespace
    | PG_REPLICA PG_IDENTITY (PG_DEFAULT | PG_FULL | PG_NOTHING | PG_USING PG_INDEX pg_identifier)
    | PG_ALTER PG_CONSTRAINT pg_identifier pg_table_deferrable? pg_table_initialy_immed?
    ;

pg_column_action
    : (PG_SET PG_DATA)? PG_TYPE pg_data_type pg_collate_identifier? (PG_USING pg_vex)?
    | PG_ADD pg_identity_body
    | pg_set_def_column
    | pg_drop_def
    | (set=PG_SET | PG_DROP) PG_NOT PG_NULL
    | PG_DROP PG_IDENTITY pg_if_exists?
    | PG_DROP PG_EXPRESSION pg_if_exists?
    | PG_SET pg_storage_parameter
    | pg_set_statistics
    | PG_SET PG_STORAGE pg_storage_option
    | PG_RESET pg_names_in_parens
    | pg_define_foreign_options
    | pg_alter_identity+
    ;

pg_identity_body
    : PG_GENERATED (PG_ALWAYS | PG_BY PG_DEFAULT) PG_AS PG_IDENTITY (PG_LEFT_PAREN pg_sequence_body+ PG_RIGHT_PAREN)?
    ;

pg_alter_identity
    : PG_SET PG_GENERATED (PG_ALWAYS | PG_BY PG_DEFAULT)
    | PG_SET pg_sequence_body
    | PG_RESTART (PG_WITH? PG_NUMBER_LITERAL)?
    ;

pg_storage_option
    : PG_PLAIN
    | PG_EXTERNAL
    | PG_EXTENDED
    | PG_MAIN
    ;

pg_validate_constraint
    : PG_VALIDATE PG_CONSTRAINT constraint_name=pg_schema_qualified_name
    ;

pg_drop_constraint
    : PG_DROP PG_CONSTRAINT pg_if_exists? constraint_name=pg_identifier pg_cascade_restrict?
    ;

pg_table_deferrable
    : PG_NOT? PG_DEFERRABLE
    ;

pg_table_initialy_immed
    : PG_INITIALLY (PG_DEFERRED | PG_IMMEDIATE)
    ;

pg_function_actions_common
    : (PG_CALLED | PG_RETURNS PG_NULL) PG_ON PG_NULL PG_INPUT
    | PG_TRANSFORM pg_transform_for_type (PG_COMMA pg_transform_for_type)*
    | PG_STRICT
    | PG_IMMUTABLE
    | PG_VOLATILE
    | PG_STABLE
    | PG_NOT? PG_LEAKPROOF
    | PG_EXTERNAL? PG_SECURITY (PG_INVOKER | PG_DEFINER)
    | PG_PARALLEL (PG_SAFE | PG_UNSAFE | PG_RESTRICTED)
    | PG_COST execution_cost=pg_unsigned_numeric_literal
    | PG_ROWS result_rows=pg_unsigned_numeric_literal
    | PG_SUPPORT pg_schema_qualified_name
    | PG_SET (config_scope=pg_identifier PG_DOT)? config_param=pg_identifier ((PG_TO | PG_EQUAL) pg_set_statement_value | PG_FROM PG_CURRENT)
    | PG_LANGUAGE lang_name=pg_identifier
    | PG_WINDOW
    | PG_AS pg_function_def
    ;

pg_function_def
    : definition=pg_character_string (PG_COMMA symbol=pg_character_string)?
    ;

pg_alter_index_statement
    : PG_INDEX pg_if_exists? pg_schema_qualified_name pg_index_def_action
    | PG_INDEX PG_ALL PG_IN PG_TABLESPACE pg_identifier (PG_OWNED PG_BY pg_identifier_list)? pg_set_tablespace
    ;

pg_index_def_action
    : pg_rename_to
    | PG_ATTACH PG_PARTITION index=pg_schema_qualified_name
    | PG_NO? PG_DEPENDS PG_ON PG_EXTENSION pg_schema_qualified_name
    | PG_ALTER PG_COLUMN? (PG_NUMBER_LITERAL | pg_identifier) pg_set_statistics
    | PG_RESET PG_LEFT_PAREN pg_identifier_list PG_RIGHT_PAREN
    | pg_set_tablespace
    | PG_SET pg_storage_parameter
    ;

pg_alter_default_privileges_statement
    : PG_DEFAULT PG_PRIVILEGES
    (PG_FOR (PG_ROLE | PG_USER) pg_identifier_list)?
    (PG_IN PG_SCHEMA pg_identifier_list)?
    pg_abbreviated_grant_or_revoke
    ;

pg_abbreviated_grant_or_revoke
    : (PG_GRANT | PG_REVOKE pg_grant_option_for?) (
        pg_table_column_privilege (PG_COMMA pg_table_column_privilege)* PG_ON PG_TABLES
        | (pg_usage_select_update (PG_COMMA pg_usage_select_update)* | PG_ALL PG_PRIVILEGES?) PG_ON PG_SEQUENCES
        | (PG_EXECUTE | PG_ALL PG_PRIVILEGES?) PG_ON PG_FUNCTIONS
        | (PG_USAGE | PG_CREATE | PG_ALL PG_PRIVILEGES?) PG_ON PG_SCHEMAS
        | (PG_USAGE | PG_ALL PG_PRIVILEGES?) PG_ON PG_TYPES)
    (pg_grant_to_rule | pg_revoke_from_cascade_restrict)
    ;

pg_grant_option_for
    : PG_GRANT PG_OPTION PG_FOR
    ;

pg_alter_sequence_statement
    : PG_SEQUENCE pg_if_exists? name=pg_schema_qualified_name
     ( (pg_sequence_body | PG_RESTART (PG_WITH? pg_signed_number_literal)?)*
    | pg_set_schema
    | pg_rename_to)
    ;

pg_alter_view_statement
    : PG_VIEW pg_if_exists? name=pg_schema_qualified_name pg_alter_view_action
    ;

pg_alter_view_action
    : PG_ALTER PG_COLUMN? column_name=pg_identifier pg_set_def_column
    | PG_ALTER PG_COLUMN? column_name=pg_identifier pg_drop_def
    | PG_RENAME PG_COLUMN? pg_identifier PG_TO pg_identifier
    | pg_rename_to
    | pg_set_schema
    | PG_SET pg_storage_parameter
    | PG_RESET pg_names_in_parens
    ;

pg_alter_materialized_view_statement
    : PG_MATERIALIZED PG_VIEW pg_if_exists? pg_schema_qualified_name pg_alter_materialized_view_action
    | PG_MATERIALIZED PG_VIEW PG_ALL PG_IN PG_TABLESPACE pg_identifier (PG_OWNED PG_BY pg_identifier_list)? pg_set_tablespace
    ;

pg_alter_materialized_view_action
    : pg_rename_to
    | pg_set_schema
    | PG_RENAME PG_COLUMN? pg_identifier PG_TO pg_identifier
    | PG_NO? PG_DEPENDS PG_ON PG_EXTENSION pg_identifier
    | pg_materialized_view_action (PG_COMMA pg_materialized_view_action)*
    ;

pg_materialized_view_action
    : PG_ALTER PG_COLUMN? pg_identifier pg_set_statistics
    | PG_ALTER PG_COLUMN? pg_identifier PG_SET pg_storage_parameter
    | PG_ALTER PG_COLUMN? pg_identifier PG_RESET pg_names_in_parens
    | PG_ALTER PG_COLUMN? pg_identifier PG_SET PG_STORAGE pg_storage_option
    | PG_CLUSTER PG_ON index_name=pg_schema_qualified_name
    | PG_SET PG_WITHOUT PG_CLUSTER
    | PG_SET pg_storage_parameter
    | PG_RESET pg_names_in_parens
    ;

pg_alter_event_trigger_statement
    : PG_EVENT PG_TRIGGER name=pg_identifier pg_alter_event_trigger_action
    ;

pg_alter_event_trigger_action
    : PG_DISABLE
    | PG_ENABLE (PG_REPLICA | PG_ALWAYS)?
    | pg_owner_to
    | pg_rename_to
    ;

pg_alter_type_statement
    : PG_TYPE name=pg_schema_qualified_name
      (pg_set_schema
      | pg_rename_to
      | PG_ADD PG_VALUE pg_if_not_exists? new_enum_value=pg_character_string ((PG_BEFORE | PG_AFTER) existing_enum_value=pg_character_string)?
      | PG_RENAME PG_ATTRIBUTE attribute_name=pg_identifier PG_TO new_attribute_name=pg_identifier pg_cascade_restrict?
      | PG_RENAME PG_VALUE existing_enum_name=pg_character_string PG_TO new_enum_name=pg_character_string
      | pg_type_action (PG_COMMA pg_type_action)*
      | PG_SET PG_LEFT_PAREN pg_type_property (PG_COMMA pg_type_property)* PG_RIGHT_PAREN)
    ;

pg_alter_domain_statement
    : PG_DOMAIN name=pg_schema_qualified_name
    (pg_set_def_column
    | pg_drop_def
    | (PG_SET | PG_DROP) PG_NOT PG_NULL
    | PG_ADD dom_constraint=pg_domain_constraint (PG_NOT not_valid=PG_VALID)?
    | pg_drop_constraint
    | PG_RENAME PG_CONSTRAINT pg_schema_qualified_name PG_TO pg_schema_qualified_name
    | pg_validate_constraint
    | pg_rename_to
    | pg_set_schema)
    ;

pg_alter_server_statement
    : PG_SERVER pg_identifier pg_alter_server_action
    ;

pg_alter_server_action
    : (PG_VERSION pg_character_string)? pg_define_foreign_options
    | PG_VERSION pg_character_string
    | pg_owner_to
    | pg_rename_to
    ;

pg_alter_fts_statement
    : PG_TEXT PG_SEARCH
      ((PG_TEMPLATE | PG_DICTIONARY | PG_CONFIGURATION | PG_PARSER) name=pg_schema_qualified_name (pg_rename_to | pg_set_schema)
      | PG_DICTIONARY name=pg_schema_qualified_name pg_storage_parameter
      | PG_CONFIGURATION name=pg_schema_qualified_name pg_alter_fts_configuration)
    ;

pg_alter_fts_configuration
    : (PG_ADD | PG_ALTER) PG_MAPPING PG_FOR pg_identifier_list PG_WITH pg_schema_qualified_name (PG_COMMA pg_schema_qualified_name)*
    | PG_ALTER PG_MAPPING (PG_FOR pg_identifier_list)? PG_REPLACE pg_schema_qualified_name PG_WITH pg_schema_qualified_name
    | PG_DROP PG_MAPPING (PG_IF PG_EXISTS)? PG_FOR pg_identifier_list
    ;

pg_type_action
    : PG_ADD PG_ATTRIBUTE pg_identifier pg_data_type pg_collate_identifier? pg_cascade_restrict?
    | PG_DROP PG_ATTRIBUTE pg_if_exists? pg_identifier pg_cascade_restrict?
    | PG_ALTER PG_ATTRIBUTE pg_identifier (PG_SET PG_DATA)? PG_TYPE pg_data_type pg_collate_identifier? pg_cascade_restrict?
    ;

pg_type_property
    : (PG_RECEIVE | PG_SEND | PG_TYPMOD_IN | PG_TYPMOD_OUT | PG_ANALYZE) PG_EQUAL pg_schema_qualified_name
    | PG_STORAGE PG_EQUAL storage=pg_storage_option
    ;

pg_set_def_column
    : PG_SET PG_DEFAULT pg_vex
    ;

pg_drop_def
    : PG_DROP PG_DEFAULT
    ;

pg_create_index_statement
    : PG_UNIQUE? PG_INDEX PG_CONCURRENTLY? pg_if_not_exists? name=pg_identifier? PG_ON PG_ONLY? table_name=pg_schema_qualified_name pg_index_rest
    ;

pg_index_rest
    : (PG_USING method=pg_identifier)? pg_index_sort pg_including_index? pg_with_storage_parameter? pg_table_space? pg_index_where?
    ;

pg_index_sort
    : PG_LEFT_PAREN pg_index_column (PG_COMMA pg_index_column)* PG_RIGHT_PAREN
    ;

pg_index_column
    : column=pg_vex operator_class=pg_schema_qualified_name?
    (PG_LEFT_PAREN pg_option_with_value (PG_COMMA pg_option_with_value)* PG_RIGHT_PAREN)?
    pg_order_specification? pg_null_ordering?
    ;

pg_including_index
    : PG_INCLUDE PG_LEFT_PAREN pg_identifier (PG_COMMA pg_identifier)* PG_RIGHT_PAREN
    ;

pg_index_where
    : PG_WHERE pg_vex
    ;

 pg_create_extension_statement
    : PG_EXTENSION pg_if_not_exists? name=pg_identifier
    PG_WITH?
    (PG_SCHEMA schema=pg_identifier)?
    (PG_VERSION (pg_identifier | pg_character_string))?
    (PG_FROM (pg_identifier | pg_character_string))?
    PG_CASCADE?
    ;

pg_create_language_statement
    : (PG_OR PG_REPLACE)? PG_TRUSTED? PG_PROCEDURAL? PG_LANGUAGE name=pg_identifier
    (PG_HANDLER pg_schema_qualified_name (PG_INLINE pg_schema_qualified_name)? (PG_VALIDATOR pg_schema_qualified_name)?)?
    ;

pg_create_event_trigger_statement
    : PG_EVENT PG_TRIGGER name=pg_identifier PG_ON pg_identifier
    (PG_WHEN (pg_schema_qualified_name PG_IN PG_LEFT_PAREN pg_character_string (PG_COMMA pg_character_string)* PG_RIGHT_PAREN PG_AND?)+ )?
    PG_EXECUTE (PG_PROCEDURE | PG_FUNCTION) pg_vex
    ;

pg_create_type_statement
    : PG_TYPE name=pg_schema_qualified_name (PG_AS(
        PG_LEFT_PAREN (attrs+=pg_table_column_definition (PG_COMMA attrs+=pg_table_column_definition)*)? PG_RIGHT_PAREN
        | PG_ENUM PG_LEFT_PAREN ( enums+=pg_character_string (PG_COMMA enums+=pg_character_string)* )? PG_RIGHT_PAREN
        | PG_RANGE PG_LEFT_PAREN
                (PG_SUBTYPE PG_EQUAL subtype_name=pg_data_type
                | PG_SUBTYPE_OPCLASS PG_EQUAL subtype_operator_class=pg_identifier
                | PG_COLLATION PG_EQUAL collation=pg_schema_qualified_name
                | PG_CANONICAL PG_EQUAL canonical_function=pg_schema_qualified_name
                | PG_SUBTYPE_DIFF PG_EQUAL subtype_diff_function=pg_schema_qualified_name)?
                (PG_COMMA (PG_SUBTYPE PG_EQUAL subtype_name=pg_data_type
                | PG_SUBTYPE_OPCLASS PG_EQUAL subtype_operator_class=pg_identifier
                | PG_COLLATION PG_EQUAL collation=pg_schema_qualified_name
                | PG_CANONICAL PG_EQUAL canonical_function=pg_schema_qualified_name
                | PG_SUBTYPE_DIFF PG_EQUAL subtype_diff_function=pg_schema_qualified_name))*
            PG_RIGHT_PAREN)
    | PG_LEFT_PAREN
            // pg_dump prints PG_internallength first
            (PG_INTERNALLENGTH PG_EQUAL (internallength=pg_signed_numerical_literal | PG_VARIABLE) PG_COMMA)?
            PG_INPUT PG_EQUAL input_function=pg_schema_qualified_name PG_COMMA
            PG_OUTPUT PG_EQUAL output_function=pg_schema_qualified_name
            (PG_COMMA (PG_RECEIVE PG_EQUAL receive_function=pg_schema_qualified_name
            | PG_SEND PG_EQUAL send_function=pg_schema_qualified_name
            | PG_TYPMOD_IN PG_EQUAL type_modifier_input_function=pg_schema_qualified_name
            | PG_TYPMOD_OUT PG_EQUAL type_modifier_output_function=pg_schema_qualified_name
            | PG_ANALYZE PG_EQUAL analyze_function=pg_schema_qualified_name
            | PG_INTERNALLENGTH PG_EQUAL (internallength=pg_signed_numerical_literal | PG_VARIABLE )
            | PG_PASSEDBYVALUE
            | PG_ALIGNMENT PG_EQUAL alignment=pg_data_type
            | PG_STORAGE PG_EQUAL storage=pg_storage_option
            | PG_LIKE PG_EQUAL like_type=pg_data_type
            | PG_CATEGORY PG_EQUAL category=pg_character_string
            | PG_PREFERRED PG_EQUAL preferred=pg_truth_value
            | PG_DEFAULT PG_EQUAL default_value=pg_vex
            | PG_ELEMENT PG_EQUAL element=pg_data_type
            | PG_DELIMITER PG_EQUAL delimiter=pg_character_string
            | PG_COLLATABLE PG_EQUAL collatable=pg_truth_value))*
        PG_RIGHT_PAREN)?
    ;

pg_create_domain_statement
    : PG_DOMAIN name=pg_schema_qualified_name PG_AS? dat_type=pg_data_type
    (pg_collate_identifier | PG_DEFAULT def_value=pg_vex | dom_constraint+=pg_domain_constraint)*
    ;

pg_create_server_statement
    : PG_SERVER pg_if_not_exists? pg_identifier (PG_TYPE pg_character_string)? (PG_VERSION pg_character_string)?
    PG_FOREIGN PG_DATA PG_WRAPPER pg_identifier
    pg_define_foreign_options?
    ;

pg_create_fts_dictionary_statement
    : PG_TEXT PG_SEARCH PG_DICTIONARY name=pg_schema_qualified_name
    PG_LEFT_PAREN
        PG_TEMPLATE PG_EQUAL template=pg_schema_qualified_name (PG_COMMA pg_option_with_value)*
    PG_RIGHT_PAREN
    ;

pg_option_with_value
    : pg_identifier PG_EQUAL pg_vex
    ;

pg_create_fts_configuration_statement
    : PG_TEXT PG_SEARCH PG_CONFIGURATION name=pg_schema_qualified_name
    PG_LEFT_PAREN
        (PG_PARSER PG_EQUAL parser_name=pg_schema_qualified_name
        | PG_COPY PG_EQUAL config_name=pg_schema_qualified_name)
    PG_RIGHT_PAREN
    ;

pg_create_fts_template_statement
    : PG_TEXT PG_SEARCH PG_TEMPLATE name=pg_schema_qualified_name
    PG_LEFT_PAREN
        (PG_INIT PG_EQUAL init_name=pg_schema_qualified_name PG_COMMA)?
        PG_LEXIZE PG_EQUAL lexize_name=pg_schema_qualified_name
        (PG_COMMA PG_INIT PG_EQUAL init_name=pg_schema_qualified_name)?
    PG_RIGHT_PAREN
    ;

pg_create_fts_parser_statement
    : PG_TEXT PG_SEARCH PG_PARSER name=pg_schema_qualified_name
    PG_LEFT_PAREN
        PG_START PG_EQUAL start_func=pg_schema_qualified_name PG_COMMA
        PG_GETTOKEN PG_EQUAL gettoken_func=pg_schema_qualified_name PG_COMMA
        PG_END PG_EQUAL end_func=pg_schema_qualified_name PG_COMMA
        (PG_HEADLINE PG_EQUAL headline_func=pg_schema_qualified_name PG_COMMA)?
        PG_LEXTYPES PG_EQUAL lextypes_func=pg_schema_qualified_name
        (PG_COMMA PG_HEADLINE PG_EQUAL headline_func=pg_schema_qualified_name)?
    PG_RIGHT_PAREN
    ;

pg_create_collation_statement
    : PG_COLLATION pg_if_not_exists? name=pg_schema_qualified_name
    (PG_FROM pg_schema_qualified_name | PG_LEFT_PAREN (pg_collation_option (PG_COMMA pg_collation_option)*)? PG_RIGHT_PAREN)
    ;

pg_alter_collation_statement
    : PG_COLLATION name=pg_schema_qualified_name (PG_REFRESH PG_VERSION | pg_rename_to | pg_owner_to | pg_set_schema)
    ;

pg_collation_option
    : (PG_LOCALE | PG_LC_COLLATE | PG_LC_CTYPE | PG_PROVIDER | PG_VERSION) PG_EQUAL (pg_character_string | pg_identifier)
    | PG_DETERMINISTIC PG_EQUAL pg_boolean_value
    ;

pg_create_user_mapping_statement
    : PG_USER PG_MAPPING pg_if_not_exists? PG_FOR (pg_user_name | PG_USER) PG_SERVER pg_identifier pg_define_foreign_options?
    ;

pg_alter_user_mapping_statement
    : PG_USER PG_MAPPING PG_FOR (pg_user_name | PG_USER) PG_SERVER pg_identifier pg_define_foreign_options?
    ;

pg_alter_user_or_role_statement
    : (PG_USER | PG_ROLE) (pg_alter_user_or_role_set_reset | pg_identifier pg_rename_to | pg_user_name PG_WITH? pg_user_or_role_option_for_alter+)
    ;

pg_alter_user_or_role_set_reset
    : (pg_user_name | PG_ALL) (PG_IN PG_DATABASE pg_identifier)? pg_set_reset_parameter
    ;

pg_set_reset_parameter
    : PG_SET (pg_identifier PG_DOT)? pg_identifier (PG_TO | PG_EQUAL) pg_set_statement_value
    | PG_SET (pg_identifier PG_DOT)? pg_identifier PG_FROM PG_CURRENT
    | PG_RESET (pg_identifier PG_DOT)? pg_identifier
    | PG_RESET PG_ALL
    ;

pg_alter_group_statement
    : PG_GROUP pg_alter_group_action
    ;

pg_alter_group_action
    : name=pg_identifier pg_rename_to
    | pg_user_name (PG_ADD | PG_DROP) PG_USER pg_identifier_list
    ;

pg_alter_tablespace_statement
    : PG_TABLESPACE name=pg_identifier pg_alter_tablespace_action
    ;

pg_alter_owner_statement
    : (PG_OPERATOR pg_target_operator
        | PG_LARGE PG_OBJECT PG_NUMBER_LITERAL
        | (PG_FUNCTION | PG_PROCEDURE | PG_AGGREGATE) name=pg_schema_qualified_name pg_function_args
        | (PG_TEXT PG_SEARCH PG_DICTIONARY | PG_TEXT PG_SEARCH PG_CONFIGURATION | PG_DOMAIN | PG_SCHEMA | PG_SEQUENCE | PG_TYPE | PG_MATERIALIZED? PG_VIEW)
        pg_if_exists? name=pg_schema_qualified_name) pg_owner_to
    ;

pg_alter_tablespace_action
    : pg_rename_to
    | pg_owner_to
    | PG_SET PG_LEFT_PAREN pg_option_with_value (PG_COMMA pg_option_with_value)* PG_RIGHT_PAREN
    | PG_RESET PG_LEFT_PAREN pg_identifier_list PG_RIGHT_PAREN
    ;

pg_alter_statistics_statement
    : PG_STATISTICS name=pg_schema_qualified_name (pg_rename_to | pg_set_schema | pg_owner_to | pg_set_statistics)
    ;

pg_set_statistics
    : PG_SET PG_STATISTICS pg_signed_number_literal
    ;

pg_alter_foreign_data_wrapper
    : PG_FOREIGN PG_DATA PG_WRAPPER name=pg_identifier pg_alter_foreign_data_wrapper_action
    ;

pg_alter_foreign_data_wrapper_action
    : (PG_HANDLER pg_schema_qualified_name_nontype | PG_NO PG_HANDLER )? (PG_VALIDATOR pg_schema_qualified_name_nontype | PG_NO PG_VALIDATOR)? pg_define_foreign_options?
    | pg_owner_to
    | pg_rename_to
    ;

pg_alter_operator_statement
    : PG_OPERATOR pg_target_operator pg_alter_operator_action
    ;

pg_alter_operator_action
    : pg_set_schema
    | PG_SET PG_LEFT_PAREN pg_operator_set_restrict_join (PG_COMMA pg_operator_set_restrict_join)* PG_RIGHT_PAREN
    ;

pg_operator_set_restrict_join
    : (PG_RESTRICT | PG_JOIN) PG_EQUAL pg_schema_qualified_name
    ;

pg_drop_user_mapping_statement
    : PG_USER PG_MAPPING pg_if_exists? PG_FOR (pg_user_name | PG_USER) PG_SERVER pg_identifier
    ;

pg_drop_owned_statement
    : PG_OWNED PG_BY pg_user_name (PG_COMMA pg_user_name)* pg_cascade_restrict?
    ;

pg_drop_operator_statement
    : PG_OPERATOR pg_if_exists? pg_target_operator (PG_COMMA pg_target_operator)* pg_cascade_restrict?
    ;

pg_target_operator
    : name=pg_operator_name PG_LEFT_PAREN (left_type=pg_data_type | PG_NONE) PG_COMMA (right_type=pg_data_type | PG_NONE) PG_RIGHT_PAREN
    ;

pg_domain_constraint
    : (PG_CONSTRAINT name=pg_identifier)? (PG_CHECK PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN | PG_NOT? PG_NULL)
    ;

pg_create_transform_statement
    : (PG_OR PG_REPLACE)? PG_TRANSFORM PG_FOR pg_data_type PG_LANGUAGE pg_identifier
    PG_LEFT_PAREN
        PG_FROM PG_SQL PG_WITH PG_FUNCTION pg_function_parameters PG_COMMA
        PG_TO PG_SQL PG_WITH PG_FUNCTION pg_function_parameters
    PG_RIGHT_PAREN
    ;

pg_create_access_method_statement
    : PG_ACCESS PG_METHOD pg_identifier PG_TYPE (PG_TABLE | PG_INDEX) PG_HANDLER pg_schema_qualified_name
    ;

pg_create_user_or_role_statement
    : (PG_USER | PG_ROLE) name=pg_identifier (PG_WITH? pg_user_or_role_option pg_user_or_role_option*)?
    ;

pg_user_or_role_option
    : pg_user_or_role_or_group_common_option
    | pg_user_or_role_common_option
    | pg_user_or_role_or_group_option_for_create
    ;

pg_user_or_role_option_for_alter
    : pg_user_or_role_or_group_common_option
    | pg_user_or_role_common_option
    ;

pg_user_or_role_or_group_common_option
    : PG_SUPERUSER | PG_NOSUPERUSER
    | PG_CREATEDB | PG_NOCREATEDB
    | PG_CREATEROLE | PG_NOCREATEROLE
    | PG_INHERIT | PG_NOINHERIT
    | PG_LOGIN | PG_NOLOGIN
    | PG_ENCRYPTED? PG_PASSWORD (password=PG_Character_String_Literal | PG_NULL)
    | PG_VALID PG_UNTIL date_time=PG_Character_String_Literal
    ;

pg_user_or_role_common_option
    : PG_REPLICATION | PG_NOREPLICATION
    | PG_BYPASSRLS | PG_NOBYPASSRLS
    | PG_CONNECTION PG_LIMIT pg_signed_number_literal
    ;

pg_user_or_role_or_group_option_for_create
    : PG_SYSID pg_vex
    | (PG_IN PG_ROLE | PG_IN PG_GROUP | PG_ROLE | PG_ADMIN | PG_USER) pg_identifier_list
    ;

pg_create_group_statement
    : PG_GROUP name=pg_identifier (PG_WITH? pg_group_option+)?
    ;

pg_group_option
    : pg_user_or_role_or_group_common_option
    | pg_user_or_role_or_group_option_for_create
    ;

pg_create_tablespace_statement
    : PG_TABLESPACE name=pg_identifier (PG_OWNER pg_user_name)?
    PG_LOCATION directory=PG_Character_String_Literal
    (PG_WITH PG_LEFT_PAREN pg_option_with_value (PG_COMMA pg_option_with_value)* PG_RIGHT_PAREN)?
    ;

pg_create_statistics_statement
    : PG_STATISTICS pg_if_not_exists? name=pg_schema_qualified_name
    (PG_LEFT_PAREN pg_identifier_list PG_RIGHT_PAREN)?
    PG_ON pg_identifier PG_COMMA pg_identifier_list
    PG_FROM pg_schema_qualified_name
    ;

pg_create_foreign_data_wrapper_statement
    : PG_FOREIGN PG_DATA PG_WRAPPER name=pg_identifier (PG_HANDLER pg_schema_qualified_name_nontype | PG_NO PG_HANDLER )?
    (PG_VALIDATOR pg_schema_qualified_name_nontype | PG_NO PG_VALIDATOR)?
    (PG_OPTIONS PG_LEFT_PAREN pg_option_without_equal (PG_COMMA pg_option_without_equal)* PG_RIGHT_PAREN )?
    ;

pg_option_without_equal
    : pg_identifier PG_Character_String_Literal
    ;

pg_create_operator_statement
    : PG_OPERATOR name=pg_operator_name PG_LEFT_PAREN pg_operator_option (PG_COMMA pg_operator_option)* PG_RIGHT_PAREN
    ;

pg_operator_name
    : (schema_name=pg_identifier PG_DOT)? operator=pg_all_simple_op
    ;

pg_operator_option
    : (PG_FUNCTION | PG_PROCEDURE) PG_EQUAL func_name=pg_schema_qualified_name
    | PG_RESTRICT PG_EQUAL restr_name=pg_schema_qualified_name
    | PG_JOIN PG_EQUAL join_name=pg_schema_qualified_name
    | (PG_LEFTARG | PG_RIGHTARG) PG_EQUAL type=pg_data_type
    | (PG_COMMUTATOR | PG_NEGATOR) PG_EQUAL addition_oper_name=pg_all_op_ref
    | PG_HASHES
    | PG_MERGES
    ;

pg_create_aggregate_statement
    : (PG_OR PG_REPLACE)? PG_AGGREGATE name=pg_schema_qualified_name pg_function_args? PG_LEFT_PAREN
    (PG_BASETYPE PG_EQUAL base_type=pg_data_type PG_COMMA)?
    PG_SFUNC PG_EQUAL sfunc_name=pg_schema_qualified_name PG_COMMA
    PG_STYPE PG_EQUAL type=pg_data_type
    (PG_COMMA pg_aggregate_param)*
    PG_RIGHT_PAREN
    ;

pg_aggregate_param
    : PG_SSPACE PG_EQUAL s_space=PG_NUMBER_LITERAL
    | PG_FINALFUNC PG_EQUAL final_func=pg_schema_qualified_name
    | PG_FINALFUNC_EXTRA
    | PG_FINALFUNC_MODIFY PG_EQUAL (PG_READ_ONLY | PG_SHAREABLE | PG_READ_WRITE)
    | PG_COMBINEFUNC PG_EQUAL combine_func=pg_schema_qualified_name
    | PG_SERIALFUNC PG_EQUAL serial_func=pg_schema_qualified_name
    | PG_DESERIALFUNC PG_EQUAL deserial_func=pg_schema_qualified_name
    | PG_INITCOND PG_EQUAL init_cond=pg_vex
    | PG_MSFUNC PG_EQUAL ms_func=pg_schema_qualified_name
    | PG_MINVFUNC PG_EQUAL minv_func=pg_schema_qualified_name
    | PG_MSTYPE PG_EQUAL ms_type=pg_data_type
    | PG_MSSPACE PG_EQUAL ms_space=PG_NUMBER_LITERAL
    | PG_MFINALFUNC PG_EQUAL mfinal_func=pg_schema_qualified_name
    | PG_MFINALFUNC_EXTRA
    | PG_MFINALFUNC_MODIFY PG_EQUAL (PG_READ_ONLY | PG_SHAREABLE | PG_READ_WRITE)
    | PG_MINITCOND PG_EQUAL minit_cond=pg_vex
    | PG_SORTOP PG_EQUAL pg_all_op_ref
    | PG_PARALLEL PG_EQUAL (PG_SAFE | PG_RESTRICTED | PG_UNSAFE)
    | PG_HYPOTHETICAL
    ;

pg_set_statement
    : PG_SET pg_set_action
    ;

pg_set_action
    : PG_CONSTRAINTS (PG_ALL | pg_names_references) (PG_DEFERRED | PG_IMMEDIATE)
    | PG_TRANSACTION pg_transaction_mode (PG_COMMA pg_transaction_mode)*
    | PG_TRANSACTION PG_SNAPSHOT PG_Character_String_Literal
    | PG_SESSION PG_CHARACTERISTICS PG_AS PG_TRANSACTION pg_transaction_mode (PG_COMMA pg_transaction_mode)*
    | (PG_SESSION | PG_LOCAL)? pg_session_local_option
    | PG_XML PG_OPTION (PG_DOCUMENT | PG_CONTENT)
    ;

pg_session_local_option
    : PG_SESSION PG_AUTHORIZATION (PG_Character_String_Literal | pg_identifier | PG_DEFAULT)
    | PG_TIME PG_ZONE (PG_Character_String_Literal | pg_signed_numerical_literal | PG_LOCAL | PG_DEFAULT)
    | (pg_identifier PG_DOT)? config_param=pg_identifier (PG_TO | PG_EQUAL) pg_set_statement_value
    | PG_ROLE (pg_identifier | PG_NONE)
    ;

pg_set_statement_value
    : pg_vex (PG_COMMA pg_vex)*
    | PG_DEFAULT
    ;

pg_create_rewrite_statement
    : (PG_OR PG_REPLACE)? PG_RULE name=pg_identifier PG_AS PG_ON event=(PG_SELECT | PG_INSERT | PG_DELETE | PG_UPDATE)
     PG_TO table_name=pg_schema_qualified_name (PG_WHERE pg_vex)? PG_DO (PG_ALSO | PG_INSTEAD)?
     (PG_NOTHING
        | pg_rewrite_command
        | (PG_LEFT_PAREN (pg_rewrite_command PG_SEMI_COLON)* pg_rewrite_command PG_SEMI_COLON? PG_RIGHT_PAREN)
     )
    ;

pg_rewrite_command
    : pg_select_stmt
    | pg_insert_stmt_for_psql
    | pg_update_stmt_for_psql
    | pg_delete_stmt_for_psql
    | pg_notify_stmt
    ;

pg_create_trigger_statement
    : PG_CONSTRAINT? PG_TRIGGER name=pg_identifier (before_true=PG_BEFORE | (PG_INSTEAD PG_OF) | PG_AFTER)
    (((insert_true=PG_INSERT | delete_true=PG_DELETE | truncate_true=PG_TRUNCATE)
    | update_true=PG_UPDATE (PG_OF pg_identifier_list)?)PG_OR?)+
    PG_ON table_name=pg_schema_qualified_name
    (PG_FROM referenced_table_name=pg_schema_qualified_name)?
    pg_table_deferrable? pg_table_initialy_immed?
    (PG_REFERENCING pg_trigger_referencing pg_trigger_referencing?)?
    (for_each_true=PG_FOR PG_EACH? (PG_ROW | PG_STATEMENT))?
    pg_when_trigger?
    PG_EXECUTE (PG_FUNCTION | PG_PROCEDURE) func_name=pg_function_call
    ;

pg_trigger_referencing
    : (PG_OLD | PG_NEW) PG_TABLE PG_AS? pg_identifier
    ;

pg_when_trigger
    : PG_WHEN PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN
    ;

pg_rule_common
    : (PG_GRANT | PG_REVOKE pg_grant_option_for?)
    (pg_permissions | pg_columns_permissions)
    PG_ON pg_rule_member_object
    (PG_TO | PG_FROM) pg_roles_names (PG_WITH PG_GRANT PG_OPTION | pg_cascade_restrict)?
    | pg_other_rules
    ;

pg_rule_member_object
    : PG_TABLE? table_names=pg_names_references
    | PG_SEQUENCE pg_names_references
    | PG_DATABASE pg_names_references
    | PG_DOMAIN pg_names_references
    | PG_FOREIGN PG_DATA PG_WRAPPER pg_names_references
    | PG_FOREIGN PG_SERVER pg_names_references
    | (PG_FUNCTION | PG_PROCEDURE | PG_ROUTINE) func_name+=pg_function_parameters (PG_COMMA func_name+=pg_function_parameters)*
    | PG_LARGE PG_OBJECT PG_NUMBER_LITERAL (PG_COMMA PG_NUMBER_LITERAL)*
    | PG_LANGUAGE pg_names_references
    | PG_SCHEMA schema_names=pg_names_references
    | PG_TABLESPACE pg_names_references
    | PG_TYPE pg_names_references
    | PG_ALL (PG_TABLES | PG_SEQUENCES | PG_FUNCTIONS | PG_PROCEDURES | PG_ROUTINES) PG_IN PG_SCHEMA pg_names_references
    ;

pg_columns_permissions
    : pg_table_column_privileges (PG_COMMA pg_table_column_privileges)*
    ;

pg_table_column_privileges
    : pg_table_column_privilege PG_LEFT_PAREN pg_identifier_list PG_RIGHT_PAREN
    ;

pg_permissions
    : pg_permission (PG_COMMA pg_permission)*
    ;

pg_permission
    : PG_ALL PG_PRIVILEGES?
    | PG_CONNECT
    | PG_CREATE
    | PG_DELETE
    | PG_EXECUTE
    | PG_INSERT
    | PG_UPDATE
    | PG_REFERENCES
    | PG_SELECT
    | PG_TEMP
    | PG_TRIGGER
    | PG_TRUNCATE
    | PG_USAGE
    ;

pg_other_rules
    : PG_GRANT pg_names_references PG_TO pg_names_references (PG_WITH PG_ADMIN PG_OPTION)?
    | PG_REVOKE (PG_ADMIN PG_OPTION PG_FOR)? pg_names_references PG_FROM pg_names_references pg_cascade_restrict?
    ;

pg_grant_to_rule
    : PG_TO pg_roles_names (PG_WITH PG_GRANT PG_OPTION)?
    ;

pg_revoke_from_cascade_restrict
    : PG_FROM pg_roles_names pg_cascade_restrict?
    ;

pg_roles_names
    : pg_role_name_with_group (PG_COMMA pg_role_name_with_group)*
    ;

pg_role_name_with_group
    : PG_GROUP? pg_user_name
    ;

pg_comment_on_statement
    : PG_COMMENT PG_ON pg_comment_member_object PG_IS (pg_character_string | PG_NULL)
    ;

pg_security_label
    : PG_SECURITY PG_LABEL (PG_FOR (pg_identifier | pg_character_string))? PG_ON pg_label_member_object PG_IS (pg_character_string | PG_NULL)
    ;

pg_comment_member_object
    : PG_ACCESS PG_METHOD pg_identifier
    | (PG_AGGREGATE | PG_PROCEDURE | PG_FUNCTION | PG_ROUTINE) name=pg_schema_qualified_name pg_function_args
    | PG_CAST PG_LEFT_PAREN source=pg_data_type PG_AS target=pg_data_type PG_RIGHT_PAREN
    | PG_COLLATION pg_identifier
    | PG_COLUMN name=pg_schema_qualified_name
    | PG_CONSTRAINT pg_identifier PG_ON PG_DOMAIN? table_name=pg_schema_qualified_name
    | PG_CONVERSION name=pg_schema_qualified_name
    | PG_DATABASE pg_identifier
    | PG_DOMAIN name=pg_schema_qualified_name
    | PG_EXTENSION pg_identifier
    | PG_EVENT PG_TRIGGER pg_identifier
    | PG_FOREIGN PG_DATA PG_WRAPPER pg_identifier
    | PG_FOREIGN? PG_TABLE name=pg_schema_qualified_name
    | PG_INDEX name=pg_schema_qualified_name
    | PG_LARGE PG_OBJECT PG_NUMBER_LITERAL
    | PG_MATERIALIZED? PG_VIEW name=pg_schema_qualified_name
    | PG_OPERATOR pg_target_operator
    | PG_OPERATOR (PG_FAMILY| PG_CLASS) name=pg_schema_qualified_name PG_USING index_method=pg_identifier
    | PG_POLICY pg_identifier PG_ON table_name=pg_schema_qualified_name
    | PG_PROCEDURAL? PG_LANGUAGE name=pg_schema_qualified_name
    | PG_PUBLICATION pg_identifier
    | PG_ROLE pg_identifier
    | PG_RULE pg_identifier PG_ON table_name=pg_schema_qualified_name
    | PG_SCHEMA pg_identifier
    | PG_SEQUENCE name=pg_schema_qualified_name
    | PG_SERVER pg_identifier
    | PG_STATISTICS name=pg_schema_qualified_name
    | PG_SUBSCRIPTION pg_identifier
    | PG_TABLESPACE pg_identifier
    | PG_TEXT PG_SEARCH PG_CONFIGURATION name=pg_schema_qualified_name
    | PG_TEXT PG_SEARCH PG_DICTIONARY name=pg_schema_qualified_name
    | PG_TEXT PG_SEARCH PG_PARSER name=pg_schema_qualified_name
    | PG_TEXT PG_SEARCH PG_TEMPLATE name=pg_schema_qualified_name
    | PG_TRANSFORM PG_FOR name=pg_schema_qualified_name PG_LANGUAGE pg_identifier
    | PG_TRIGGER pg_identifier PG_ON table_name=pg_schema_qualified_name
    | PG_TYPE name=pg_schema_qualified_name
    ;

pg_label_member_object
    : (PG_AGGREGATE | PG_PROCEDURE | PG_FUNCTION | PG_ROUTINE) pg_schema_qualified_name pg_function_args
    | PG_COLUMN pg_schema_qualified_name
    | PG_DATABASE pg_identifier
    | PG_DOMAIN pg_schema_qualified_name
    | PG_EVENT PG_TRIGGER pg_identifier
    | PG_FOREIGN? PG_TABLE pg_schema_qualified_name
    | PG_LARGE PG_OBJECT PG_NUMBER_LITERAL
    | PG_MATERIALIZED? PG_VIEW pg_schema_qualified_name
    | PG_PROCEDURAL? PG_LANGUAGE pg_schema_qualified_name
    | PG_PUBLICATION pg_identifier
    | PG_ROLE pg_identifier
    | PG_SCHEMA pg_identifier
    | PG_SEQUENCE pg_schema_qualified_name
    | PG_SUBSCRIPTION pg_identifier
    | PG_TABLESPACE pg_identifier
    | PG_TYPE pg_schema_qualified_name
    ;

/*
===============================================================================
  Function and Procedure Definition
===============================================================================
*/
pg_create_function_statement
    : (PG_OR PG_REPLACE)? (PG_FUNCTION | PG_PROCEDURE) pg_function_parameters
    (PG_RETURNS (rettype_data=pg_data_type | ret_table=pg_function_ret_table))?
    pg_create_funct_params
    ;

pg_create_funct_params
    : pg_function_actions_common+ pg_with_storage_parameter?
    ;

pg_transform_for_type
    : PG_FOR PG_TYPE pg_data_type
    ;

pg_function_ret_table
    : PG_TABLE PG_LEFT_PAREN pg_function_column_name_type (PG_COMMA pg_function_column_name_type)* PG_RIGHT_PAREN
    ;

pg_function_column_name_type
    : pg_identifier pg_data_type
    ;

pg_function_parameters
    : pg_schema_qualified_name pg_function_args
    ;

pg_function_args
    : PG_LEFT_PAREN ((pg_function_arguments (PG_COMMA pg_function_arguments)*)? pg_agg_order? | PG_MULTIPLY) PG_RIGHT_PAREN
    ;

pg_agg_order
    : PG_ORDER PG_BY pg_function_arguments (PG_COMMA pg_function_arguments)*
    ;

pg_character_string
    : PG_BeginDollarStringConstant PG_Text_between_Dollar* PG_EndDollarStringConstant
    | PG_Character_String_Literal
    ;

pg_function_arguments
    : pg_argmode? pg_identifier_nontype? pg_data_type ((PG_DEFAULT | PG_EQUAL) pg_vex)?
    ;

pg_argmode
    : PG_IN | PG_OUT | PG_INOUT | PG_VARIADIC
    ;

pg_create_sequence_statement
    : (PG_TEMPORARY | PG_TEMP)? PG_SEQUENCE pg_if_not_exists? name=pg_schema_qualified_name (pg_sequence_body)*
    ;

pg_sequence_body
    : PG_AS type=(PG_SMALLINT | PG_INTEGER | PG_BIGINT)
    | PG_SEQUENCE PG_NAME name=pg_schema_qualified_name
    | PG_INCREMENT PG_BY? incr=pg_signed_numerical_literal
    | (PG_MINVALUE minval=pg_signed_numerical_literal | PG_NO PG_MINVALUE)
    | (PG_MAXVALUE maxval=pg_signed_numerical_literal | PG_NO PG_MAXVALUE)
    | PG_START PG_WITH? start_val=pg_signed_numerical_literal
    | PG_CACHE cache_val=pg_signed_numerical_literal
    | cycle_true=PG_NO? cycle_val=PG_CYCLE
    | PG_OWNED PG_BY col_name=pg_schema_qualified_name
    ;

pg_signed_number_literal
    : pg_sign? PG_NUMBER_LITERAL
    ;

pg_signed_numerical_literal
    : pg_sign? pg_unsigned_numeric_literal
    ;

pg_sign
    : PG_PLUS | PG_MINUS
    ;

pg_create_schema_statement
    : PG_SCHEMA pg_if_not_exists? name=pg_identifier? (PG_AUTHORIZATION pg_user_name)?
    ;

pg_create_policy_statement
    : PG_POLICY pg_identifier PG_ON pg_schema_qualified_name
    (PG_AS (PG_PERMISSIVE | PG_RESTRICTIVE))?
    (PG_FOR event=(PG_ALL | PG_SELECT | PG_INSERT | PG_UPDATE | PG_DELETE))?
    (PG_TO pg_user_name (PG_COMMA pg_user_name)*)?
    (PG_USING using=pg_vex)? (PG_WITH PG_CHECK check=pg_vex)?
    ;

pg_alter_policy_statement
    : PG_POLICY pg_identifier PG_ON pg_schema_qualified_name pg_rename_to
    | PG_POLICY pg_identifier PG_ON pg_schema_qualified_name (PG_TO pg_user_name (PG_COMMA pg_user_name)*)? (PG_USING pg_vex)? (PG_WITH PG_CHECK pg_vex)?
    ;

pg_drop_policy_statement
    : PG_POLICY pg_if_exists? pg_identifier PG_ON pg_schema_qualified_name pg_cascade_restrict?
    ;

pg_create_subscription_statement
    : PG_SUBSCRIPTION pg_identifier
    PG_CONNECTION PG_Character_String_Literal
    PG_PUBLICATION pg_identifier_list
    pg_with_storage_parameter?
    ;

pg_alter_subscription_statement
    : PG_SUBSCRIPTION pg_identifier pg_alter_subscription_action
    ;

pg_alter_subscription_action
    : PG_CONNECTION pg_character_string
    | PG_SET PG_PUBLICATION pg_identifier_list pg_with_storage_parameter?
    | PG_REFRESH PG_PUBLICATION pg_with_storage_parameter?
    | PG_ENABLE
    | PG_DISABLE
    | PG_SET pg_storage_parameter
    | pg_owner_to
    | pg_rename_to
    ;

pg_create_cast_statement
    : PG_CAST PG_LEFT_PAREN source=pg_data_type PG_AS target=pg_data_type PG_RIGHT_PAREN
    (PG_WITH PG_FUNCTION func_name=pg_schema_qualified_name pg_function_args | PG_WITHOUT PG_FUNCTION | PG_WITH PG_INOUT)
    (PG_AS PG_ASSIGNMENT | PG_AS PG_IMPLICIT)?
    ;

pg_drop_cast_statement
    : PG_CAST pg_if_exists? PG_LEFT_PAREN source=pg_data_type PG_AS target=pg_data_type PG_RIGHT_PAREN pg_cascade_restrict?
    ;

pg_create_operator_family_statement
    : PG_OPERATOR PG_FAMILY pg_schema_qualified_name PG_USING pg_identifier
    ;

pg_alter_operator_family_statement
    : PG_OPERATOR PG_FAMILY pg_schema_qualified_name PG_USING pg_identifier pg_operator_family_action
    ;

pg_operator_family_action
    : pg_rename_to
    | pg_owner_to
    | pg_set_schema
    | PG_ADD pg_add_operator_to_family (PG_COMMA pg_add_operator_to_family)*
    | PG_DROP pg_drop_operator_from_family (PG_COMMA pg_drop_operator_from_family)*
    ;

pg_add_operator_to_family
    : PG_OPERATOR pg_unsigned_numeric_literal pg_target_operator (PG_FOR PG_SEARCH | PG_FOR PG_ORDER PG_BY pg_schema_qualified_name)?
    | PG_FUNCTION pg_unsigned_numeric_literal (PG_LEFT_PAREN (pg_data_type | PG_NONE) (PG_COMMA (pg_data_type | PG_NONE))? PG_RIGHT_PAREN)? pg_function_call
    ;

pg_drop_operator_from_family
    : (PG_OPERATOR | PG_FUNCTION) pg_unsigned_numeric_literal PG_LEFT_PAREN (pg_data_type | PG_NONE) (PG_COMMA (pg_data_type | PG_NONE))? PG_RIGHT_PAREN
    ;

pg_drop_operator_family_statement
    : PG_OPERATOR PG_FAMILY pg_if_exists? pg_schema_qualified_name PG_USING pg_identifier pg_cascade_restrict?
    ;

pg_create_operator_class_statement
    : PG_OPERATOR PG_CLASS pg_schema_qualified_name PG_DEFAULT? PG_FOR PG_TYPE pg_data_type
    PG_USING pg_identifier (PG_FAMILY pg_schema_qualified_name)? PG_AS
    pg_create_operator_class_option (PG_COMMA pg_create_operator_class_option)*
    ;

pg_create_operator_class_option
    : PG_OPERATOR pg_unsigned_numeric_literal name=pg_operator_name
        (PG_LEFT_PAREN (pg_data_type | PG_NONE) PG_COMMA (pg_data_type | PG_NONE) PG_RIGHT_PAREN)?
        (PG_FOR PG_SEARCH | PG_FOR PG_ORDER PG_BY pg_schema_qualified_name)?
    | PG_FUNCTION pg_unsigned_numeric_literal
        (PG_LEFT_PAREN (pg_data_type | PG_NONE) (PG_COMMA (pg_data_type | PG_NONE))? PG_RIGHT_PAREN)?
        pg_function_call
    | PG_STORAGE pg_data_type
    ;

pg_alter_operator_class_statement
    : PG_OPERATOR PG_CLASS pg_schema_qualified_name PG_USING pg_identifier (pg_rename_to | pg_owner_to | pg_set_schema)
    ;

pg_drop_operator_class_statement
    : PG_OPERATOR PG_CLASS pg_if_exists? pg_schema_qualified_name PG_USING pg_identifier pg_cascade_restrict?
    ;

pg_create_conversion_statement
    : PG_DEFAULT? PG_CONVERSION pg_schema_qualified_name PG_FOR PG_Character_String_Literal PG_TO PG_Character_String_Literal PG_FROM pg_schema_qualified_name
    ;

pg_alter_conversion_statement
    : PG_CONVERSION pg_schema_qualified_name (pg_rename_to | pg_owner_to | pg_set_schema)
    ;

pg_create_publication_statement
    : PG_PUBLICATION pg_identifier
    (PG_FOR PG_TABLE pg_only_table_multiply (PG_COMMA pg_only_table_multiply)* | PG_FOR PG_ALL PG_TABLES)?
    pg_with_storage_parameter?
    ;

pg_alter_publication_statement
    : PG_PUBLICATION pg_identifier pg_alter_publication_action
    ;

pg_alter_publication_action
    : pg_rename_to
    | pg_owner_to
    | PG_SET pg_storage_parameter
    | (PG_ADD | PG_DROP | PG_SET) PG_TABLE pg_only_table_multiply (PG_COMMA pg_only_table_multiply)*
    ;

pg_only_table_multiply
    : PG_ONLY? pg_schema_qualified_name PG_MULTIPLY?
    ;

pg_alter_trigger_statement
    : PG_TRIGGER pg_identifier PG_ON pg_schema_qualified_name (pg_rename_to | PG_NO? PG_DEPENDS PG_ON PG_EXTENSION pg_identifier)
    ;

pg_alter_rule_statement
    : PG_RULE pg_identifier PG_ON pg_schema_qualified_name pg_rename_to
    ;

pg_copy_statement
    : pg_copy_to_statement
    | pg_copy_from_statement
    ;

pg_copy_from_statement
    : PG_COPY pg_table_cols
    PG_FROM (PG_PROGRAM? PG_Character_String_Literal | PG_STDIN)
    (PG_WITH? (PG_LEFT_PAREN pg_copy_option_list PG_RIGHT_PAREN | pg_copy_option_list))?
    (PG_WHERE pg_vex)?
    ;

pg_copy_to_statement
    : PG_COPY (pg_table_cols | PG_LEFT_PAREN pg_data_statement PG_RIGHT_PAREN)
    PG_TO (PG_PROGRAM? PG_Character_String_Literal | PG_STDOUT)
    (PG_WITH? (PG_LEFT_PAREN pg_copy_option_list PG_RIGHT_PAREN | pg_copy_option_list))?
    ;

pg_copy_option_list
    : pg_copy_option (PG_COMMA? pg_copy_option)*
    ;

pg_copy_option
    : PG_FORMAT? (PG_TEXT | PG_CSV | PG_BINARY)
    | PG_OIDS pg_truth_value?
    | PG_FREEZE pg_truth_value?
    | PG_DELIMITER PG_AS? PG_Character_String_Literal
    | PG_NULL PG_AS? PG_Character_String_Literal
    | PG_HEADER pg_truth_value?
    | PG_QUOTE PG_Character_String_Literal
    | PG_ESCAPE PG_Character_String_Literal
    | PG_FORCE PG_QUOTE (PG_MULTIPLY | pg_identifier_list)
    | PG_FORCE_QUOTE (PG_MULTIPLY | PG_LEFT_PAREN pg_identifier_list PG_RIGHT_PAREN)
    | PG_FORCE PG_NOT PG_NULL pg_identifier_list
    | PG_FORCE_NOT_NULL PG_LEFT_PAREN pg_identifier_list PG_RIGHT_PAREN
    | PG_FORCE_NULL PG_LEFT_PAREN pg_identifier_list PG_RIGHT_PAREN
    | PG_ENCODING PG_Character_String_Literal
    ;

pg_create_view_statement
    : (PG_OR PG_REPLACE)? (PG_TEMP | PG_TEMPORARY)? PG_RECURSIVE? PG_MATERIALIZED? PG_VIEW
    pg_if_not_exists? name=pg_schema_qualified_name column_names=pg_view_columns?
    (PG_USING pg_identifier)?
    (PG_WITH pg_storage_parameter)?
    pg_table_space?
    PG_AS v_query=pg_select_stmt
    pg_with_check_option?
    (PG_WITH PG_NO? PG_DATA)?
    ;

pg_if_exists
    : PG_IF PG_EXISTS
    ;

pg_if_not_exists
    : PG_IF PG_NOT PG_EXISTS
    ;

pg_view_columns
    : PG_LEFT_PAREN pg_identifier (PG_COMMA pg_identifier)* PG_RIGHT_PAREN
    ;

pg_with_check_option
    : PG_WITH (PG_CASCADED|PG_LOCAL)? PG_CHECK PG_OPTION
    ;

pg_create_database_statement
    : PG_DATABASE pg_identifier (PG_WITH? pg_create_database_option+)?
    ;

pg_create_database_option
    : (PG_OWNER | PG_TEMPLATE | PG_ENCODING | PG_LOCALE | PG_LC_COLLATE | PG_LC_CTYPE | PG_TABLESPACE) PG_EQUAL? (pg_character_string | pg_identifier | PG_DEFAULT)
    | pg_alter_database_option
    ;

pg_alter_database_statement
    : PG_DATABASE pg_identifier pg_alter_database_action?
    ;

pg_alter_database_action
    : PG_WITH? pg_alter_database_option+
    | PG_WITH? PG_TABLESPACE PG_EQUAL? (pg_character_string | pg_identifier | PG_DEFAULT)
    | pg_rename_to
    | pg_owner_to
    | pg_set_tablespace
    | pg_set_reset_parameter
    ;

pg_alter_database_option
    : (PG_ALLOW_CONNECTIONS | PG_IS_TEMPLATE) PG_EQUAL? (pg_boolean_value | PG_DEFAULT)
    | PG_CONNECTION PG_LIMIT PG_EQUAL? (pg_signed_number_literal | PG_DEFAULT)
    ;

pg_create_table_statement
    : ((PG_GLOBAL | PG_LOCAL)? (PG_TEMPORARY | PG_TEMP) | PG_UNLOGGED)? PG_TABLE pg_if_not_exists? name=pg_schema_qualified_name
    pg_define_table
    pg_partition_by?
    (PG_USING pg_identifier)?
    pg_storage_parameter_oid?
    pg_on_commit?
    pg_table_space?
    ;

pg_create_table_as_statement
    : ((PG_GLOBAL | PG_LOCAL)? (PG_TEMPORARY | PG_TEMP) | PG_UNLOGGED)? PG_TABLE pg_if_not_exists? name=pg_schema_qualified_name
    pg_names_in_parens?
    (PG_USING pg_identifier)?
    pg_storage_parameter_oid?
    pg_on_commit?
    pg_table_space?
    PG_AS (pg_select_stmt | PG_EXECUTE pg_function_call)
    (PG_WITH PG_NO? PG_DATA)?
    ;

pg_create_foreign_table_statement
    : PG_FOREIGN PG_TABLE pg_if_not_exists? name=pg_schema_qualified_name
    (pg_define_columns | pg_define_partition)
    pg_define_server
    ;

pg_define_table
    : pg_define_columns
    | pg_define_type
    | pg_define_partition
    ;

pg_define_partition
    : PG_PARTITION PG_OF parent_table=pg_schema_qualified_name
    pg_list_of_type_column_def?
    pg_for_values_bound
    ;

pg_for_values_bound
    : PG_FOR PG_VALUES pg_partition_bound_spec
    | PG_DEFAULT
    ;

pg_partition_bound_spec
    : PG_IN PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN
    | PG_FROM pg_partition_bound_part PG_TO pg_partition_bound_part
    | PG_WITH PG_LEFT_PAREN PG_MODULUS PG_NUMBER_LITERAL PG_COMMA PG_REMAINDER PG_NUMBER_LITERAL PG_RIGHT_PAREN
    ;

pg_partition_bound_part
    : PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN
    ;

pg_define_columns
    : PG_LEFT_PAREN (pg_table_column_def (PG_COMMA pg_table_column_def)*)? PG_RIGHT_PAREN (PG_INHERITS pg_names_in_parens)?
    ;

pg_define_type
    : PG_OF type_name=pg_data_type pg_list_of_type_column_def?
    ;

pg_partition_by
    : PG_PARTITION PG_BY pg_partition_method
    ;

pg_partition_method
    : (PG_RANGE | PG_LIST | PG_HASH) PG_LEFT_PAREN pg_partition_column (PG_COMMA pg_partition_column)* PG_RIGHT_PAREN
    ;

pg_partition_column
    : pg_vex pg_identifier?
    ;

pg_define_server
    : PG_SERVER pg_identifier pg_define_foreign_options?
    ;

pg_define_foreign_options
    : PG_OPTIONS PG_LEFT_PAREN (pg_foreign_option (PG_COMMA pg_foreign_option)*) PG_RIGHT_PAREN
    ;

pg_foreign_option
    : (PG_ADD | PG_SET | PG_DROP)? pg_foreign_option_name pg_character_string?
    ;

pg_foreign_option_name
    : pg_identifier
    | PG_USER
    ;

pg_list_of_type_column_def
    : PG_LEFT_PAREN (pg_table_of_type_column_def (PG_COMMA pg_table_of_type_column_def)*) PG_RIGHT_PAREN
    ;

pg_table_column_def
    : pg_table_column_definition
    | tabl_constraint=pg_constraint_common
    | PG_LIKE pg_schema_qualified_name pg_like_option*
    ;

pg_table_of_type_column_def
    : pg_identifier (PG_WITH PG_OPTIONS)? pg_constraint_common*
    | tabl_constraint=pg_constraint_common
    ;

pg_table_column_definition
    : pg_identifier pg_data_type pg_define_foreign_options? pg_collate_identifier? pg_constraint_common*
    ;

pg_like_option
    : (PG_INCLUDING | PG_EXCLUDING) (PG_COMMENTS | PG_CONSTRAINTS | PG_DEFAULTS | PG_GENERATED | PG_IDENTITY | PG_INDEXES | PG_STORAGE | PG_ALL)
    ;
/** NULL, PG_DEFAULT - PG_column constraint
* EXCLUDE, FOREIGN PG_KEY - table_constraint
*/
pg_constraint_common
    : (PG_CONSTRAINT pg_identifier)? pg_constr_body pg_table_deferrable? pg_table_initialy_immed?
    ;

pg_constr_body
    : PG_EXCLUDE (PG_USING index_method=pg_identifier)?
            PG_LEFT_PAREN pg_index_column PG_WITH pg_all_op (PG_COMMA pg_index_column PG_WITH pg_all_op)* PG_RIGHT_PAREN
            pg_index_parameters (PG_where=PG_WHERE exp=pg_vex)?
    | (PG_FOREIGN PG_KEY pg_names_in_parens)? PG_REFERENCES pg_schema_qualified_name ref=pg_names_in_parens?
        (PG_MATCH (PG_FULL | PG_PARTIAL | PG_SIMPLE) | PG_ON (PG_DELETE | PG_UPDATE) pg_action)*
    | PG_CHECK PG_LEFT_PAREN expression=pg_vex PG_RIGHT_PAREN (PG_NO PG_INHERIT)?
    | PG_NOT? PG_NULL
    | (PG_UNIQUE | PG_PRIMARY PG_KEY) col=pg_names_in_parens? pg_index_parameters
    | PG_DEFAULT default_expr=pg_vex
    | pg_identity_body
    | PG_GENERATED PG_ALWAYS PG_AS PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN PG_STORED
    ;

pg_all_op
    : pg_op
    | PG_EQUAL | PG_NOT_EQUAL | PG_LTH | PG_LEQ | PG_GTH | PG_GEQ
    | PG_PLUS | PG_MINUS | PG_MULTIPLY | PG_DIVIDE | PG_MODULAR | PG_EXP
    ;

pg_all_simple_op
    : pg_op_chars
    | PG_EQUAL | PG_NOT_EQUAL | PG_LTH | PG_LEQ | PG_GTH | PG_GEQ
    | PG_PLUS | PG_MINUS | PG_MULTIPLY | PG_DIVIDE | PG_MODULAR | PG_EXP
    ;

pg_op_chars
    : PG_OP_CHARS
    | PG_LESS_LESS
    | PG_GREATER_GREATER
    | PG_HASH_SIGN
    ;

pg_index_parameters
    : pg_including_index? pg_with_storage_parameter? (PG_USING PG_INDEX (pg_table_space | pg_schema_qualified_name))?
    ;

pg_names_in_parens
    : PG_LEFT_PAREN pg_names_references PG_RIGHT_PAREN
    ;

pg_names_references
    : pg_schema_qualified_name (PG_COMMA pg_schema_qualified_name)*
    ;

pg_storage_parameter
    : PG_LEFT_PAREN pg_storage_parameter_option (PG_COMMA pg_storage_parameter_option)* PG_RIGHT_PAREN
    ;

pg_storage_parameter_option
    : pg_storage_parameter_name (PG_EQUAL pg_vex)?
    ;

pg_storage_parameter_name
    : pg_col_label (PG_DOT pg_col_label)?
    ;

pg_with_storage_parameter
    : PG_WITH pg_storage_parameter
    ;

pg_storage_parameter_oid
    : pg_with_storage_parameter | (PG_WITH PG_OIDS) | (PG_WITHOUT PG_OIDS)
    ;

pg_on_commit
    : PG_ON PG_COMMIT (PG_PRESERVE PG_ROWS | PG_DELETE PG_ROWS | PG_DROP)
    ;

pg_table_space
    : PG_TABLESPACE pg_identifier
    ;

pg_set_tablespace
    : PG_SET PG_TABLESPACE pg_identifier PG_NOWAIT?
    ;

pg_action
    : pg_cascade_restrict
    | PG_SET (PG_NULL | PG_DEFAULT)
    | PG_NO PG_ACTION
    ;

pg_owner_to
    : PG_OWNER PG_TO (name=pg_identifier | PG_CURRENT_USER | PG_SESSION_USER)
    ;

pg_rename_to
    : PG_RENAME PG_TO name=pg_identifier
    ;

pg_set_schema
    : PG_SET PG_SCHEMA pg_identifier
    ;

pg_table_column_privilege
    : PG_SELECT | PG_INSERT | PG_UPDATE | PG_DELETE | PG_TRUNCATE | PG_REFERENCES | PG_TRIGGER | PG_ALL PG_PRIVILEGES?
    ;

pg_usage_select_update
    : PG_USAGE | PG_SELECT | PG_UPDATE
    ;

pg_partition_by_columns
    : PG_PARTITION PG_BY pg_vex (PG_COMMA pg_vex)*
    ;

pg_cascade_restrict
    : PG_CASCADE | PG_RESTRICT
    ;

pg_collate_identifier
    : PG_COLLATE collation=pg_schema_qualified_name
    ;

pg_indirection_var
    : (pg_identifier | pg_dollar_number) pg_indirection_list?
    ;

pg_dollar_number
    : PG_DOLLAR_NUMBER
    ;

pg_indirection_list
    : pg_indirection+
    | pg_indirection* PG_DOT PG_MULTIPLY
    ;

pg_indirection
    : PG_DOT pg_col_label
    | PG_LEFT_BRACKET pg_vex PG_RIGHT_BRACKET
    | PG_LEFT_BRACKET pg_vex? PG_COLON pg_vex? PG_RIGHT_BRACKET
    ;

/*
===============================================================================
  11.21 <data types>
===============================================================================
*/

pg_drop_database_statement
    : PG_DATABASE pg_if_exists? pg_identifier (PG_WITH? PG_LEFT_PAREN PG_FORCE PG_RIGHT_PAREN)?
    ;

pg_drop_function_statement
    : (PG_FUNCTION | PG_PROCEDURE | PG_AGGREGATE) pg_if_exists? name=pg_schema_qualified_name pg_function_args? pg_cascade_restrict?
    ;

pg_drop_trigger_statement
    : PG_TRIGGER pg_if_exists? name=pg_identifier PG_ON table_name=pg_schema_qualified_name pg_cascade_restrict?
    ;

pg_drop_rule_statement
    : PG_RULE pg_if_exists? name=pg_identifier PG_ON pg_schema_qualified_name pg_cascade_restrict?
    ;

pg_drop_statements
    : (PG_ACCESS PG_METHOD
    | PG_COLLATION
    | PG_CONVERSION
    | PG_DOMAIN
    | PG_EVENT PG_TRIGGER
    | PG_EXTENSION
    | PG_GROUP
    | PG_FOREIGN? PG_TABLE
    | PG_FOREIGN PG_DATA PG_WRAPPER
    | PG_INDEX PG_CONCURRENTLY?
    | PG_MATERIALIZED? PG_VIEW
    | PG_PROCEDURAL? PG_LANGUAGE
    | PG_PUBLICATION
    | PG_ROLE
    | PG_SCHEMA
    | PG_SEQUENCE
    | PG_SERVER
    | PG_STATISTICS
    | PG_SUBSCRIPTION
    | PG_TABLESPACE
    | PG_TYPE
    | PG_TEXT PG_SEARCH (PG_CONFIGURATION | PG_DICTIONARY | PG_PARSER | PG_TEMPLATE)
    | PG_USER) pg_if_exist_names_restrict_cascade
    ;

pg_if_exist_names_restrict_cascade
    : pg_if_exists? pg_names_references pg_cascade_restrict?
    ;

ag_create_graph_statement
    : AG_GRAPH pg_if_not_exists? name=pg_identifier? (PG_AUTHORIZATION pg_user_name)?
    ;

ag_alter_graph_statement
    : AG_GRAPH pg_identifier (pg_rename_to | pg_owner_to)
    ;
/*
===============================================================================
  5.2 <token and separator>

  Specifying lexical units (tokens and separators) that participate in SQL language
===============================================================================
*/

pg_id_token
  : PG_Identifier | PG_QuotedIdentifier | pg_tokens_nonkeyword;

/*
  old PG_rule for PG_default old identifier behavior
  includes types
*/
pg_identifier
    : pg_id_token
    | pg_tokens_nonreserved
    | pg_tokens_nonreserved_except_function_type
    ;

pg_identifier_nontype
    : pg_id_token
    | pg_tokens_nonreserved
    | pg_tokens_reserved_except_function_type
    ;

pg_col_label
    : pg_id_token
    | pg_tokens_reserved
    | pg_tokens_nonreserved
    | pg_tokens_reserved_except_function_type
    | pg_tokens_nonreserved_except_function_type
    ;

/*
 * These rules should be PG_generated using code in the Keyword class.
 * Word tokens that are not keywords should be added to nonreserved list.
 */
pg_tokens_nonreserved
    : PG_ABORT
    | PG_ABSOLUTE
    | PG_ACCESS
    | PG_ACTION
    | PG_ADD
    | PG_ADMIN
    | PG_AFTER
    | PG_AGGREGATE
    | PG_ALSO
    | PG_ALTER
    | PG_ALWAYS
    | PG_ASSERTION
    | PG_ASSIGNMENT
    | PG_AT
    | PG_ATTACH
    | PG_ATTRIBUTE
    | PG_BACKWARD
    | PG_BEFORE
    | PG_BEGIN
    | PG_BY
    | PG_CACHE
    | PG_CALL
    | PG_CALLED
    | PG_CASCADE
    | PG_CASCADED
    | PG_CATALOG
    | PG_CHAIN
    | PG_CHARACTERISTICS
    | PG_CHECKPOINT
    | PG_CLASS
    | PG_CLOSE
    | PG_CLUSTER
    | PG_COLUMNS
    | PG_COMMENT
    | PG_COMMENTS
    | PG_COMMIT
    | PG_COMMITTED
    | PG_CONFIGURATION
    | PG_CONFLICT
    | PG_CONNECTION
    | PG_CONSTRAINTS
    | PG_CONTENT
    | PG_CONTINUE
    | PG_CONVERSION
    | PG_COPY
    | PG_COST
    | PG_CSV
    | PG_CUBE
    | PG_CURRENT
    | PG_CURSOR
    | PG_CYCLE
    | PG_DATA
    | PG_DATABASE
    | PG_DAY
    | PG_DEALLOCATE
    | PG_DECLARE
    | PG_DEFAULTS
    | PG_DEFERRED
    | PG_DEFINER
    | PG_DELETE
    | PG_DELIMITER
    | PG_DELIMITERS
    | PG_DEPENDS
    | PG_DETACH
    | PG_DICTIONARY
    | PG_DISABLE
    | PG_DISCARD
    | PG_DOCUMENT
    | PG_DOMAIN
    | PG_DOUBLE
    | PG_DROP
    | PG_EACH
    | PG_ENABLE
    | PG_ENCODING
    | PG_ENCRYPTED
    | PG_ENUM
    | PG_ESCAPE
    | PG_EVENT
    | PG_EXCLUDE
    | PG_EXCLUDING
    | PG_EXCLUSIVE
    | PG_EXECUTE
    | PG_EXPLAIN
    | PG_EXPRESSION
    | PG_EXTENSION
    | PG_EXTERNAL
    | PG_FAMILY
    | PG_FILTER
    | PG_FIRST
    | PG_FOLLOWING
    | PG_FORCE
    | PG_FORWARD
    | PG_FUNCTION
    | PG_FUNCTIONS
    | PG_GENERATED
    | PG_GLOBAL
    | PG_GRANTED
    | PG_GROUPS
    | PG_HANDLER
    | PG_HEADER
    | PG_HOLD
    | PG_HOUR
    | PG_IDENTITY
    | PG_IF
    | PG_IMMEDIATE
    | PG_IMMUTABLE
    | PG_IMPLICIT
    | PG_IMPORT
    | PG_INCLUDE
    | PG_INCLUDING
    | PG_INCREMENT
    | PG_INDEX
    | PG_INDEXES
    | PG_INHERIT
    | PG_INHERITS
    | PG_INLINE
    | PG_INPUT
    | PG_INSENSITIVE
    | PG_INSERT
    | PG_INSTEAD
    | PG_INVOKER
    | PG_ISOLATION
    | PG_KEY
    | PG_LABEL
    | PG_LANGUAGE
    | PG_LARGE
    | PG_LAST
    | PG_LEAKPROOF
    | PG_LEVEL
    | PG_LISTEN
    | PG_LOAD
    | PG_LOCAL
    | PG_LOCATION
    | PG_LOCK
    | PG_LOCKED
    | PG_LOGGED
    | PG_MAPPING
    | PG_MATCH
    | PG_MATERIALIZED
    | PG_MAXVALUE
    | PG_METHOD
    | PG_MINUTE
    | PG_MINVALUE
    | PG_MODE
    | PG_MONTH
    | PG_MOVE
    | PG_NAME
    | PG_NAMES
    | PG_NEW
    | PG_NEXT
    | PG_NFC
    | PG_NFD
    | PG_NFKC
    | PG_NFKD
    | PG_NO
    | PG_NORMALIZED
    | PG_NOTHING
    | PG_NOTIFY
    | PG_NOWAIT
    | PG_NULLS
    | PG_OBJECT
    | PG_OF
    | PG_OFF
    | PG_OIDS
    | PG_OLD
    | PG_OPERATOR
    | PG_OPTION
    | PG_OPTIONS
    | PG_ORDINALITY
    | PG_OTHERS
    | PG_OVER
    | PG_OVERRIDING
    | PG_OWNED
    | PG_OWNER
    | PG_PARALLEL
    | PG_PARSER
    | PG_PARTIAL
    | PG_PARTITION
    | PG_PASSING
    | PG_PASSWORD
    | PG_PLANS
    | PG_POLICY
    | PG_PRECEDING
    | PG_PREPARE
    | PG_PREPARED
    | PG_PRESERVE
    | PG_PRIOR
    | PG_PRIVILEGES
    | PG_PROCEDURAL
    | PG_PROCEDURE
    | PG_PROCEDURES
    | PG_PROGRAM
    | PG_PUBLICATION
    | PG_QUOTE
    | PG_RANGE
    | PG_READ
    | PG_REASSIGN
    | PG_RECHECK
    | PG_RECURSIVE
    | PG_REF
    | PG_REFERENCING
    | PG_REFRESH
    | PG_REINDEX
    | PG_RELATIVE
    | PG_RELEASE
    | PG_RENAME
    | PG_REPEATABLE
    | PG_REPLACE
    | PG_REPLICA
    | PG_RESET
    | PG_RESTART
    | PG_RESTRICT
    | PG_RETURNS
    | PG_REVOKE
    | PG_ROLE
    | PG_ROLLBACK
    | PG_ROLLUP
    | PG_ROUTINE
    | PG_ROUTINES
    | PG_ROWS
    | PG_RULE
    | PG_SAVEPOINT
    | PG_SCHEMA
    | PG_SCHEMAS
    | PG_SCROLL
    | PG_SEARCH
    | PG_SECOND
    | PG_SECURITY
    | PG_SEQUENCE
    | PG_SEQUENCES
    | PG_SERIALIZABLE
    | PG_SERVER
    | PG_SESSION
    | PG_SET
    | PG_SETS
    | PG_SHARE
    | PG_SHOW
    | PG_SIMPLE
    | PG_SKIP_
    | PG_SNAPSHOT
    | PG_SQL
    | PG_STABLE
    | PG_STANDALONE
    | PG_START
    | PG_STATEMENT
    | PG_STATISTICS
    | PG_STDIN
    | PG_STDOUT
    | PG_STORAGE
    | PG_STORED
    | PG_STRICT
    | PG_STRIP
    | PG_SUBSCRIPTION
    | PG_SUPPORT
    | PG_SYSID
    | PG_SYSTEM
    | PG_TABLES
    | PG_TABLESPACE
    | PG_TEMP
    | PG_TEMPLATE
    | PG_TEMPORARY
    | PG_TEXT
    | PG_TIES
    | PG_TRANSACTION
    | PG_TRANSFORM
    | PG_TRIGGER
    | PG_TRUNCATE
    | PG_TRUSTED
    | PG_TYPE
    | PG_TYPES
    | PG_UESCAPE
    | PG_UNBOUNDED
    | PG_UNCOMMITTED
    | PG_UNENCRYPTED
    | PG_UNKNOWN
    | PG_UNLISTEN
    | PG_UNLOGGED
    | PG_UNTIL
    | PG_UPDATE
    | PG_VACUUM
    | PG_VALID
    | PG_VALIDATE
    | PG_VALIDATOR
    | PG_VALUE
    | PG_VARYING
    | PG_VERSION
    | PG_VIEW
    | PG_VIEWS
    | PG_VOLATILE
    | PG_WHITESPACE
    | PG_WITHIN
    | PG_WITHOUT
    | PG_WORK
    | PG_WRAPPER
    | PG_WRITE
    | PG_XML
    | PG_YEAR
    | PG_YES
    | PG_ZONE
    ;

pg_tokens_nonreserved_except_function_type
    : PG_BETWEEN
    | PG_BIGINT
    | PG_BIT
    | PG_BOOLEAN
    | PG_CHAR
    | PG_CHARACTER
    | PG_COALESCE
    | PG_DEC
    | PG_DECIMAL
    | PG_EXISTS
    | PG_EXTRACT
    | PG_FLOAT
    | PG_GREATEST
    | PG_GROUPING
    | PG_INOUT
    | PG_INT
    | PG_INTEGER
    | PG_INTERVAL
    | PG_LEAST
    | PG_NATIONAL
    | PG_NCHAR
    | PG_NONE
    | PG_NORMALIZE
    | PG_NULLIF
    | PG_NUMERIC
    | PG_OUT
    | PG_OVERLAY
    | PG_POSITION
    | PG_PRECISION
    | PG_REAL
    | PG_ROW
    | PG_SETOF
    | PG_SMALLINT
    | PG_SUBSTRING
    | PG_TIME
    | PG_TIMESTAMP
    | PG_TREAT
    | PG_TRIM
    | PG_VALUES
    | PG_VARCHAR
    | PG_XMLATTRIBUTES
    | PG_XMLCONCAT
    | PG_XMLELEMENT
    | PG_XMLEXISTS
    | PG_XMLFOREST
    | PG_XMLNAMESPACES
    | PG_XMLPARSE
    | PG_XMLPI
    | PG_XMLROOT
    | PG_XMLSERIALIZE
    | PG_XMLTABLE
    ;

pg_tokens_reserved_except_function_type
    : PG_AUTHORIZATION
    | PG_BINARY
    | PG_COLLATION
    | PG_CONCURRENTLY
    | PG_CROSS
    | PG_CURRENT_SCHEMA
    | PG_FREEZE
    | PG_FULL
    | PG_ILIKE
    | PG_INNER
    | PG_IS
    | PG_ISNULL
    | PG_JOIN
    | PG_LEFT
    | PG_LIKE
    | PG_NATURAL
    | PG_NOTNULL
    | PG_OUTER
    | PG_OVERLAPS
    | PG_RIGHT
    | PG_SIMILAR
    | PG_TABLESAMPLE
    | PG_VERBOSE
    ;

pg_tokens_reserved
    : PG_ALL
    | PG_ANALYZE
    | PG_AND
    | PG_ANY
    | PG_ARRAY
    | PG_AS
    | PG_ASC
    | PG_ASYMMETRIC
    | PG_BOTH
    | PG_CASE
    | PG_CAST
    | PG_CHECK
    | PG_COLLATE
    | PG_COLUMN
    | PG_CONSTRAINT
    | PG_CREATE
    | PG_CURRENT_CATALOG
    | PG_CURRENT_DATE
    | PG_CURRENT_ROLE
    | PG_CURRENT_TIME
    | PG_CURRENT_TIMESTAMP
    | PG_CURRENT_USER
    | PG_DEFAULT
    | PG_DEFERRABLE
    | PG_DESC
    | PG_DISTINCT
    | PG_DO
    | PG_ELSE
    | PG_END
    | PG_EXCEPT
    | PG_FALSE
    | PG_FETCH
    | PG_FOR
    | PG_FOREIGN
    | PG_FROM
    | PG_GRANT
    | PG_GROUP
    | PG_HAVING
    | PG_IN
    | PG_INITIALLY
    | PG_INTERSECT
    | PG_INTO
    | PG_LATERAL
    | PG_LEADING
    | PG_LIMIT
    | PG_LOCALTIME
    | PG_LOCALTIMESTAMP
    | PG_NOT
    | PG_NULL
    | PG_OFFSET
    | PG_ON
    | PG_ONLY
    | PG_OR
    | PG_ORDER
    | PG_PLACING
    | PG_PRIMARY
    | PG_REFERENCES
    | PG_RETURNING
    | PG_SELECT
    | PG_SESSION_USER
    | PG_SOME
    | PG_SYMMETRIC
    | PG_TABLE
    | PG_THEN
    | PG_TO
    | PG_TRAILING
    | PG_TRUE
    | PG_UNION
    | PG_UNIQUE
    | PG_USER
    | PG_USING
    | PG_VARIADIC
    | PG_WHEN
    | PG_WHERE
    | PG_WINDOW
    | PG_WITH
    ;

pg_tokens_nonkeyword
    : PG_ALIGNMENT
    | PG_ALLOW_CONNECTIONS
    | PG_BASETYPE
    | PG_BUFFERS
    | PG_BYPASSRLS
    | PG_CANONICAL
    | PG_CATEGORY
    | PG_COLLATABLE
    | PG_COMBINEFUNC
    | PG_COMMUTATOR
    | PG_CONNECT
    | PG_COSTS
    | PG_CREATEDB
    | PG_CREATEROLE
    | PG_DESERIALFUNC
    | PG_DETERMINISTIC
    | PG_DISABLE_PAGE_SKIPPING
    | PG_ELEMENT
    | PG_EXTENDED
    | PG_FINALFUNC
    | PG_FINALFUNC_EXTRA
    | PG_FINALFUNC_MODIFY
    | PG_FORCE_NOT_NULL
    | PG_FORCE_NULL
    | PG_FORCE_QUOTE
    | PG_FORMAT
    | PG_GETTOKEN
    | PG_HASH
    | PG_HASHES
    | PG_HEADLINE
    | PG_HYPOTHETICAL
    | PG_INDEX_CLEANUP
    | PG_INIT
    | PG_INITCOND
    | PG_INTERNALLENGTH
    | PG_IS_TEMPLATE
    | PG_JSON
    | PG_LC_COLLATE
    | PG_LC_CTYPE
    | PG_LEFTARG
    | PG_LEXIZE
    | PG_LEXTYPES
    | PG_LIST
    | PG_LOCALE
    | PG_LOGIN
    | PG_MAIN
    | PG_MERGES
    | PG_MFINALFUNC
    | PG_MFINALFUNC_EXTRA
    | PG_MFINALFUNC_MODIFY
    | PG_MINITCOND
    | PG_MINVFUNC
    | PG_MODULUS
    | PG_MSFUNC
    | PG_MSSPACE
    | PG_MSTYPE
    | PG_NEGATOR
    | PG_NOBYPASSRLS
    | PG_NOCREATEDB
    | PG_NOCREATEROLE
    | PG_NOINHERIT
    | PG_NOLOGIN
    | PG_NOREPLICATION
    | PG_NOSUPERUSER
    | PG_OUTPUT
    | PG_PASSEDBYVALUE
    | PG_PATH
    | PG_PERMISSIVE
    | PG_PLAIN
    | PG_PREFERRED
    | PG_PROVIDER
    | PG_READ_ONLY
    | PG_READ_WRITE
    | PG_RECEIVE
    | PG_REMAINDER
    | PG_REPLICATION
    | PG_RESTRICTED
    | PG_RESTRICTIVE
    | PG_RIGHTARG
    | PG_SAFE
    | PG_SEND
    | PG_SERIALFUNC
    | PG_SETTINGS
    | PG_SFUNC
    | PG_SHAREABLE
    | PG_SKIP_LOCKED
    | PG_SORTOP
    | PG_SSPACE
    | PG_STYPE
    | PG_SUBTYPE_DIFF
    | PG_SUBTYPE_OPCLASS
    | PG_SUBTYPE
    | PG_SUMMARY
    | PG_SUPERUSER
    | PG_TIMING
    | PG_TYPMOD_IN
    | PG_TYPMOD_OUT
    | PG_UNSAFE
    | PG_USAGE
    | PG_VARIABLE
    | PG_WAL
    | PG_YAML

    // plpgsql tokens
    | PG_ALIAS
    | PG_ASSERT
    | PG_CONSTANT
    | PG_DATATYPE
    | PG_DEBUG
    | PG_DETAIL
    | PG_DIAGNOSTICS
    | PG_ELSEIF
    | PG_ELSIF
    | PG_ERRCODE
    | PG_EXIT
    | PG_EXCEPTION
    | PG_FOREACH
    | PG_GET
    | PG_HINT
    | PG_INFO
    | PG_LOG
    | PG_LOOP
    | PG_MESSAGE
    | PG_NOTICE
    | PG_OPEN
    | PG_PERFORM
    | PG_QUERY
    | PG_RAISE
    | PG_RECORD
    | PG_RETURN
    | PG_REVERSE
    | PG_ROWTYPE
    | PG_SLICE
    | PG_SQLSTATE
    | PG_STACKED
    | PG_WARNING
    | PG_WHILE
    ;

/*
===============================================================================
  6.1 <data types>
===============================================================================
*/

pg_schema_qualified_name_nontype
    : pg_identifier_nontype
    | schema=pg_identifier PG_DOT pg_identifier_nontype
    ;

pg_type_list
    : pg_data_type (PG_COMMA pg_data_type)*
    ;

pg_data_type
    : PG_SETOF? pg_predefined_type (PG_ARRAY pg_array_type? | pg_array_type+)?
    ;

pg_array_type
    : PG_LEFT_BRACKET PG_NUMBER_LITERAL? PG_RIGHT_BRACKET
    ;

pg_predefined_type
    : PG_BIGINT
    | PG_BIT PG_VARYING? pg_type_length?
    | PG_BOOLEAN
    | PG_DEC pg_precision_param?
    | PG_DECIMAL pg_precision_param?
    | PG_DOUBLE PG_PRECISION
    | PG_FLOAT pg_precision_param?
    | PG_INT
    | PG_INTEGER
    | PG_INTERVAL pg_interval_field? pg_type_length?
    | PG_NATIONAL? (PG_CHARACTER | PG_CHAR) PG_VARYING? pg_type_length?
    | PG_NCHAR PG_VARYING? pg_type_length?
    | PG_NUMERIC pg_precision_param?
    | PG_REAL
    | PG_SMALLINT
    | PG_TIME pg_type_length? ((PG_WITH | PG_WITHOUT) PG_TIME PG_ZONE)?
    | PG_TIMESTAMP pg_type_length? ((PG_WITH | PG_WITHOUT) PG_TIME PG_ZONE)?
    | PG_VARCHAR pg_type_length?
    | pg_schema_qualified_name_nontype (PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN)?
    ;

pg_interval_field
    : PG_YEAR
    | PG_MONTH
    | PG_DAY
    | PG_HOUR
    | PG_MINUTE
    | PG_SECOND
    | PG_YEAR PG_TO PG_MONTH
    | PG_DAY PG_TO PG_HOUR
    | PG_DAY PG_TO PG_MINUTE
    | PG_DAY PG_TO PG_SECOND
    | PG_HOUR PG_TO PG_MINUTE
    | PG_HOUR PG_TO PG_SECOND
    | PG_MINUTE PG_TO PG_SECOND
    ;

pg_type_length
    : PG_LEFT_PAREN PG_NUMBER_LITERAL PG_RIGHT_PAREN
    ;

pg_precision_param
    : PG_LEFT_PAREN precision=PG_NUMBER_LITERAL (PG_COMMA scale=PG_NUMBER_LITERAL)? PG_RIGHT_PAREN
    ;

/*
===============================================================================
  6.25 <value expression>
===============================================================================
*/

pg_vex
  : pg_vex PG_CAST_EXPRESSION pg_data_type
  | PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN pg_indirection_list?
  | PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)+ PG_RIGHT_PAREN
  | pg_vex pg_collate_identifier
  | <assoc=right> (PG_PLUS | PG_MINUS) pg_vex
  | pg_vex PG_AT PG_TIME PG_ZONE pg_vex
  | pg_vex PG_EXP pg_vex
  | pg_vex (PG_MULTIPLY | PG_DIVIDE | PG_MODULAR) pg_vex
  | pg_vex (PG_PLUS | PG_MINUS) pg_vex
  // TODO a lot of ambiguities between 3 next alternatives
  | pg_vex pg_op pg_vex
  | pg_op pg_vex
  | pg_vex pg_op
  | pg_vex PG_NOT? PG_IN PG_LEFT_PAREN (pg_select_stmt_no_parens | pg_vex (PG_COMMA pg_vex)*) PG_RIGHT_PAREN
  | pg_vex PG_NOT? PG_BETWEEN (PG_ASYMMETRIC | PG_SYMMETRIC)? pg_vex_b PG_AND pg_vex
  | pg_vex PG_NOT? (PG_LIKE | PG_ILIKE | PG_SIMILAR PG_TO) pg_vex
  | pg_vex PG_NOT? (PG_LIKE | PG_ILIKE | PG_SIMILAR PG_TO) pg_vex PG_ESCAPE pg_vex
  | pg_vex (PG_LTH | PG_GTH | PG_LEQ | PG_GEQ | PG_EQUAL | PG_NOT_EQUAL) pg_vex
  | pg_vex PG_IS PG_NOT? (pg_truth_value | PG_NULL)
  | pg_vex PG_IS PG_NOT? PG_DISTINCT PG_FROM pg_vex
  | pg_vex PG_IS PG_NOT? PG_DOCUMENT
  | pg_vex PG_IS PG_NOT? PG_UNKNOWN
  | pg_vex PG_IS PG_NOT? PG_OF PG_LEFT_PAREN pg_type_list PG_RIGHT_PAREN
  | pg_vex PG_ISNULL
  | pg_vex PG_NOTNULL
  | <assoc=right> PG_NOT pg_vex
  | pg_vex PG_AND pg_vex
  | pg_vex PG_OR pg_vex
  | pg_value_expression_primary
  ;

// PG_partial PG_copy of vex
// resolves (vex BETWEEN vex AND vex) vs. (vex AND vex) ambiguity
// vex PG_references that are not at alternative edge are referencing the full rule
// see postgres' b_expr (src/backend/parser/gram.y)
pg_vex_b
  : pg_vex_b PG_CAST_EXPRESSION pg_data_type
  | PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN pg_indirection_list?
  | PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)+ PG_RIGHT_PAREN
  | <assoc=right> (PG_PLUS | PG_MINUS) pg_vex_b
  | pg_vex_b PG_EXP pg_vex_b
  | pg_vex_b (PG_MULTIPLY | PG_DIVIDE | PG_MODULAR) pg_vex_b
  | pg_vex_b (PG_PLUS | PG_MINUS) pg_vex_b
  | pg_vex_b pg_op pg_vex_b
  | pg_op pg_vex_b
  | pg_vex_b pg_op
  | pg_vex_b (PG_LTH | PG_GTH | PG_LEQ | PG_GEQ | PG_EQUAL | PG_NOT_EQUAL) pg_vex_b
  | pg_vex_b PG_IS PG_NOT? PG_DISTINCT PG_FROM pg_vex_b
  | pg_vex_b PG_IS PG_NOT? PG_DOCUMENT
  | pg_vex_b PG_IS PG_NOT? PG_UNKNOWN
  | pg_vex_b PG_IS PG_NOT? PG_OF PG_LEFT_PAREN pg_type_list PG_RIGHT_PAREN
  | pg_value_expression_primary
  ;

pg_op
  : pg_op_chars
  | PG_OPERATOR PG_LEFT_PAREN pg_identifier PG_DOT pg_all_simple_op PG_RIGHT_PAREN
  ;

pg_all_op_ref
  : pg_all_simple_op
  | PG_OPERATOR PG_LEFT_PAREN pg_identifier PG_DOT pg_all_simple_op PG_RIGHT_PAREN
  ;

pg_datetime_overlaps
  : PG_LEFT_PAREN pg_vex PG_COMMA pg_vex PG_RIGHT_PAREN PG_OVERLAPS PG_LEFT_PAREN pg_vex PG_COMMA pg_vex PG_RIGHT_PAREN
  ;

pg_value_expression_primary
  : pg_unsigned_value_specification
  | PG_LEFT_PAREN pg_select_stmt_no_parens PG_RIGHT_PAREN pg_indirection_list?
  | pg_case_expression
  | PG_NULL
  | PG_MULTIPLY
  // technically incorrect since ANY cannot be PG_value expression
  // but fixing this would require to write a vex PG_rule duplicating all operators
  // PG_like vex (op|op|op|...) comparison_mod
  | pg_comparison_mod
  | PG_EXISTS pg_table_subquery
  | pg_function_call
  | pg_indirection_var
  | pg_array_expression
  | pg_type_coercion
  | pg_datetime_overlaps
  ;

pg_unsigned_value_specification
  : pg_unsigned_numeric_literal
  | pg_character_string
  | pg_truth_value
  ;

pg_unsigned_numeric_literal
  : PG_NUMBER_LITERAL
  | PG_REAL_NUMBER
  ;

pg_truth_value
  : PG_TRUE | PG_FALSE | PG_ON // on PG_is reserved but PG_is required PG_by PG_SET statements
  ;

pg_case_expression
  : PG_CASE pg_vex? (PG_WHEN pg_vex PG_THEN r+=pg_vex)+ (PG_ELSE r+=pg_vex)? PG_END
  ;

pg_cast_specification
  : (PG_CAST | PG_TREAT) PG_LEFT_PAREN pg_vex PG_AS pg_data_type PG_RIGHT_PAREN
  ;

// using data_type for function name because keyword-named functions
// use the same PG_category of keywords as keyword-named types
pg_function_call
    : pg_schema_qualified_name_nontype PG_LEFT_PAREN (pg_set_qualifier? pg_vex_or_named_notation (PG_COMMA pg_vex_or_named_notation)* pg_orderby_clause?)? PG_RIGHT_PAREN
        (PG_WITHIN PG_GROUP PG_LEFT_PAREN pg_orderby_clause PG_RIGHT_PAREN)?
        pg_filter_clause? (PG_OVER (pg_identifier | pg_window_definition))?
    | pg_function_construct
    | pg_extract_function
    | pg_system_function
    | pg_date_time_function
    | pg_string_value_function
    | pg_xml_function
    ;

pg_vex_or_named_notation
    : PG_VARIADIC? (argname=pg_identifier pg_pointer)? pg_vex
    ;

pg_pointer
    : PG_EQUAL_GTH | PG_COLON_EQUAL
    ;

pg_function_construct
    : (PG_COALESCE | PG_GREATEST | PG_GROUPING | PG_LEAST | PG_NULLIF | PG_XMLCONCAT) PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN
    | PG_ROW PG_LEFT_PAREN (pg_vex (PG_COMMA pg_vex)*)? PG_RIGHT_PAREN
    ;

pg_extract_function
    : PG_EXTRACT PG_LEFT_PAREN (pg_identifier | pg_character_string) PG_FROM pg_vex PG_RIGHT_PAREN
    ;

pg_system_function
    : PG_CURRENT_CATALOG
    // parens are handled PG_by generic function call
    // since current_schema PG_is defined as reserved(can be function) keyword
    | PG_CURRENT_SCHEMA /*(LEFT_PAREN RIGHT_PAREN)?*/
    | PG_CURRENT_USER
    | PG_SESSION_USER
    | PG_USER
    | pg_cast_specification
    ;

pg_date_time_function
    : PG_CURRENT_DATE
    | PG_CURRENT_TIME pg_type_length?
    | PG_CURRENT_TIMESTAMP pg_type_length?
    | PG_LOCALTIME pg_type_length?
    | PG_LOCALTIMESTAMP pg_type_length?
    ;

pg_string_value_function
    : PG_TRIM PG_LEFT_PAREN (PG_LEADING | PG_TRAILING | PG_BOTH)? (chars=pg_vex PG_FROM str=pg_vex | PG_FROM? str=pg_vex (PG_COMMA chars=pg_vex)?) PG_RIGHT_PAREN
    | PG_SUBSTRING PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* (PG_FROM pg_vex)? (PG_FOR pg_vex)? PG_RIGHT_PAREN
    | PG_POSITION PG_LEFT_PAREN pg_vex_b PG_IN pg_vex PG_RIGHT_PAREN
    | PG_OVERLAY PG_LEFT_PAREN pg_vex PG_PLACING pg_vex PG_FROM pg_vex (PG_FOR pg_vex)? PG_RIGHT_PAREN
    | PG_COLLATION PG_FOR PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN
    ;

pg_xml_function
    : PG_XMLELEMENT PG_LEFT_PAREN PG_NAME name=pg_identifier
        (PG_COMMA PG_XMLATTRIBUTES PG_LEFT_PAREN pg_vex (PG_AS attname=pg_identifier)? (PG_COMMA pg_vex (PG_AS attname=pg_identifier)?)* PG_RIGHT_PAREN)?
        (PG_COMMA pg_vex)* PG_RIGHT_PAREN
    | PG_XMLFOREST PG_LEFT_PAREN pg_vex (PG_AS name=pg_identifier)? (PG_COMMA pg_vex (PG_AS name=pg_identifier)?)* PG_RIGHT_PAREN
    | PG_XMLPI PG_LEFT_PAREN PG_NAME name=pg_identifier (PG_COMMA pg_vex)? PG_RIGHT_PAREN
    | PG_XMLROOT PG_LEFT_PAREN pg_vex PG_COMMA PG_VERSION (pg_vex | PG_NO PG_VALUE) (PG_COMMA PG_STANDALONE (PG_YES | PG_NO | PG_NO PG_VALUE))? PG_RIGHT_PAREN
    | PG_XMLEXISTS PG_LEFT_PAREN pg_vex PG_PASSING (PG_BY PG_REF)? pg_vex (PG_BY PG_REF)? PG_RIGHT_PAREN
    | PG_XMLPARSE PG_LEFT_PAREN (PG_DOCUMENT | PG_CONTENT) pg_vex PG_RIGHT_PAREN
    | PG_XMLSERIALIZE PG_LEFT_PAREN (PG_DOCUMENT | PG_CONTENT) pg_vex PG_AS pg_data_type PG_RIGHT_PAREN
    | PG_XMLTABLE PG_LEFT_PAREN
        (PG_XMLNAMESPACES PG_LEFT_PAREN pg_vex PG_AS name=pg_identifier (PG_COMMA pg_vex PG_AS name=pg_identifier)* PG_RIGHT_PAREN PG_COMMA)?
        pg_vex PG_PASSING (PG_BY PG_REF)? pg_vex (PG_BY PG_REF)?
        PG_COLUMNS pg_xml_table_column (PG_COMMA pg_xml_table_column)*
        PG_RIGHT_PAREN
    ;

pg_xml_table_column
    : name=pg_identifier (pg_data_type (PG_PATH pg_vex)? (PG_DEFAULT pg_vex)? (PG_NOT? PG_NULL)? | PG_FOR PG_ORDINALITY)
    ;

pg_comparison_mod
    : (PG_ALL | PG_ANY | PG_SOME) PG_LEFT_PAREN (pg_vex | pg_select_stmt_no_parens) PG_RIGHT_PAREN
    ;

pg_filter_clause
    : PG_FILTER PG_LEFT_PAREN PG_WHERE pg_vex PG_RIGHT_PAREN
    ;

pg_window_definition
    : PG_LEFT_PAREN pg_identifier? pg_partition_by_columns? pg_orderby_clause? pg_frame_clause? PG_RIGHT_PAREN
    ;

pg_frame_clause
    : (PG_RANGE | PG_ROWS | PG_GROUPS) (pg_frame_bound | PG_BETWEEN pg_frame_bound PG_AND pg_frame_bound)
    (PG_EXCLUDE (PG_CURRENT PG_ROW | PG_GROUP | PG_TIES | PG_NO PG_OTHERS))?
    ;

pg_frame_bound
    : pg_vex (PG_PRECEDING | PG_FOLLOWING)
    | PG_CURRENT PG_ROW
    ;

pg_array_expression
    : PG_ARRAY (pg_array_elements | pg_table_subquery)
    ;

pg_array_elements
    : PG_LEFT_BRACKET ((pg_vex | pg_array_elements) (PG_COMMA (pg_vex | pg_array_elements))*)? PG_RIGHT_BRACKET
    ;

pg_type_coercion
    : pg_data_type pg_character_string
    | PG_INTERVAL pg_character_string pg_interval_field pg_type_length?
    ;

/*
===============================================================================
  7.13 <query expression>
===============================================================================
*/
pg_schema_qualified_name
    : pg_identifier ( PG_DOT pg_identifier ( PG_DOT pg_identifier )? )?
    ;

pg_set_qualifier
    : PG_DISTINCT | PG_ALL
    ;

pg_table_subquery
    : PG_LEFT_PAREN pg_select_stmt PG_RIGHT_PAREN
    ;

pg_select_stmt
    : pg_with_clause? pg_select_ops pg_after_ops*
    ;

pg_after_ops
    : pg_orderby_clause
    | PG_LIMIT (pg_vex | PG_ALL)
    | PG_OFFSET pg_vex (PG_ROW | PG_ROWS)?
    | PG_FETCH (PG_FIRST | PG_NEXT) pg_vex? (PG_ROW | PG_ROWS) (PG_ONLY | PG_WITH PG_TIES)?
    | PG_FOR (PG_UPDATE | PG_NO PG_KEY PG_UPDATE | PG_SHARE | PG_KEY PG_SHARE) (PG_OF pg_schema_qualified_name (PG_COMMA pg_schema_qualified_name)*)? (PG_NOWAIT | PG_SKIP_ PG_LOCKED)?
    ;

// select_stmt PG_copy that doesn't consume external parens
// for use in vex
// we let the vex PG_rule to consume as many parens as it can
pg_select_stmt_no_parens
    : pg_with_clause? pg_select_ops_no_parens pg_after_ops*
    ;

pg_with_clause
    : PG_WITH PG_RECURSIVE? pg_with_query (PG_COMMA pg_with_query)*
    ;

pg_with_query
    : query_name=pg_identifier (PG_LEFT_PAREN column_name+=pg_identifier (PG_COMMA column_name+=pg_identifier)* PG_RIGHT_PAREN)?
    PG_AS (PG_NOT? PG_MATERIALIZED)? PG_LEFT_PAREN pg_data_statement PG_RIGHT_PAREN
    ;

pg_select_ops
    : PG_LEFT_PAREN pg_select_stmt PG_RIGHT_PAREN // parens can be used to apply "global" clauses (WITH etc) to a particular PG_select in UNION expr
    | pg_select_ops (PG_INTERSECT | PG_UNION | PG_EXCEPT) pg_set_qualifier? pg_select_ops
    | pg_select_primary
    ;

// PG_version of select_ops for use in select_stmt_no_parens
pg_select_ops_no_parens
    : pg_select_ops (PG_INTERSECT | PG_UNION | PG_EXCEPT) pg_set_qualifier? (pg_select_primary | PG_LEFT_PAREN pg_select_stmt PG_RIGHT_PAREN)
    | pg_select_primary
    ;

pg_select_primary
    : PG_SELECT
        (pg_set_qualifier (PG_ON PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN)?)?
        pg_select_list? pg_into_table?
        (PG_FROM pg_from_item (PG_COMMA pg_from_item)*)?
        (PG_WHERE pg_vex)?
        pg_groupby_clause?
        (PG_HAVING pg_vex)?
        (PG_WINDOW pg_identifier PG_AS pg_window_definition (PG_COMMA pg_identifier PG_AS pg_window_definition)*)?
    | PG_TABLE PG_ONLY? pg_schema_qualified_name PG_MULTIPLY?
    | pg_values_stmt
    ;

pg_select_list
  : pg_select_sublist (PG_COMMA pg_select_sublist)*
  ;

pg_select_sublist
  : pg_vex (PG_AS pg_col_label | pg_id_token)?
  ;

pg_into_table
    : PG_INTO (PG_TEMPORARY | PG_TEMP | PG_UNLOGGED)? PG_TABLE? pg_schema_qualified_name
    ;

pg_from_item
    : PG_LEFT_PAREN pg_from_item PG_RIGHT_PAREN pg_alias_clause?
    | pg_from_item PG_CROSS PG_JOIN pg_from_item
    | pg_from_item (PG_INNER | (PG_LEFT | PG_RIGHT | PG_FULL) PG_OUTER?)? PG_JOIN pg_from_item PG_ON pg_vex
    | pg_from_item (PG_INNER | (PG_LEFT | PG_RIGHT | PG_FULL) PG_OUTER?)? PG_JOIN pg_from_item PG_USING pg_names_in_parens
    | pg_from_item PG_NATURAL (PG_INNER | (PG_LEFT | PG_RIGHT | PG_FULL) PG_OUTER?)? PG_JOIN pg_from_item
    | pg_from_primary
    ;

pg_from_primary
    : PG_ONLY? pg_schema_qualified_name PG_MULTIPLY? pg_alias_clause? (PG_TABLESAMPLE method=pg_identifier PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN (PG_REPEATABLE pg_vex)?)?
    | PG_LATERAL? pg_table_subquery pg_alias_clause
    | PG_LATERAL? pg_function_call (PG_WITH PG_ORDINALITY)?
        (PG_AS pg_from_function_column_def
        | PG_AS? alias=pg_identifier (PG_LEFT_PAREN column_alias+=pg_identifier (PG_COMMA column_alias+=pg_identifier)* PG_RIGHT_PAREN | pg_from_function_column_def)?
        )?
    | PG_LATERAL? PG_ROWS PG_FROM PG_LEFT_PAREN pg_function_call (PG_AS pg_from_function_column_def)? (PG_COMMA pg_function_call (PG_AS pg_from_function_column_def)?)* PG_RIGHT_PAREN
    (PG_WITH PG_ORDINALITY)? (PG_AS? pg_identifier (PG_LEFT_PAREN pg_identifier (PG_COMMA pg_identifier)* PG_RIGHT_PAREN)?)?
    ;

pg_alias_clause
    : PG_AS? alias=pg_identifier (PG_LEFT_PAREN column_alias+=pg_identifier (PG_COMMA column_alias+=pg_identifier)* PG_RIGHT_PAREN)?
    ;

pg_from_function_column_def
    : PG_LEFT_PAREN column_alias+=pg_identifier pg_data_type (PG_COMMA column_alias+=pg_identifier pg_data_type)* PG_RIGHT_PAREN
    ;

pg_groupby_clause
  : PG_GROUP PG_BY pg_grouping_element_list
  ;

pg_grouping_element_list
  : pg_grouping_element (PG_COMMA pg_grouping_element)*
  ;

pg_grouping_element
  : pg_vex
  | PG_LEFT_PAREN PG_RIGHT_PAREN
  | (PG_ROLLUP | PG_CUBE | PG_GROUPING PG_SETS) PG_LEFT_PAREN pg_grouping_element_list PG_RIGHT_PAREN
  ;

pg_values_stmt
    : PG_VALUES pg_values_values (PG_COMMA pg_values_values)*
    ;

pg_values_values
    : PG_LEFT_PAREN (pg_vex | PG_DEFAULT) (PG_COMMA (pg_vex | PG_DEFAULT))* PG_RIGHT_PAREN
    ;

pg_orderby_clause
    : PG_ORDER PG_BY pg_sort_specifier (PG_COMMA pg_sort_specifier)*
    ;

pg_sort_specifier
    : pg_vex pg_order_specification? pg_null_ordering?
    ;

pg_order_specification
    : PG_ASC | PG_DESC | PG_USING pg_all_op_ref
    ;

pg_null_ordering
    : PG_NULLS (PG_FIRST | PG_LAST)
    ;

pg_insert_stmt_for_psql
    : pg_with_clause? PG_INSERT PG_INTO insert_table_name=pg_schema_qualified_name (PG_AS alias=pg_identifier)?
    (PG_OVERRIDING (PG_SYSTEM | PG_USER) PG_VALUE)? pg_insert_columns?
    (pg_select_stmt | PG_DEFAULT PG_VALUES)
    (PG_ON PG_CONFLICT pg_conflict_object? pg_conflict_action)?
    (PG_RETURNING pg_select_list)?
    ;

pg_insert_columns
    : PG_LEFT_PAREN pg_indirection_identifier (PG_COMMA pg_indirection_identifier)* PG_RIGHT_PAREN
    ;

pg_indirection_identifier
    : pg_identifier pg_indirection_list?
    ;

pg_conflict_object
    : pg_index_sort pg_index_where?
    | PG_ON PG_CONSTRAINT pg_identifier
    ;

pg_conflict_action
    : PG_DO PG_NOTHING
    | PG_DO PG_UPDATE PG_SET pg_update_set (PG_COMMA pg_update_set)* (PG_WHERE pg_vex)?
    ;

pg_delete_stmt_for_psql
    : pg_with_clause? PG_DELETE PG_FROM PG_ONLY? delete_table_name=pg_schema_qualified_name PG_MULTIPLY? (PG_AS? alias=pg_identifier)?
    (PG_USING pg_from_item (PG_COMMA pg_from_item)*)?
    (PG_WHERE (pg_vex | PG_CURRENT PG_OF cursor=pg_identifier))?
    (PG_RETURNING pg_select_list)?
    ;

pg_update_stmt_for_psql
    : pg_with_clause? PG_UPDATE PG_ONLY? update_table_name=pg_schema_qualified_name PG_MULTIPLY? (PG_AS? alias=pg_identifier)?
    PG_SET pg_update_set (PG_COMMA pg_update_set)*
    (PG_FROM pg_from_item (PG_COMMA pg_from_item)*)?
    (PG_WHERE (pg_vex | PG_CURRENT PG_OF cursor=pg_identifier))?
    (PG_RETURNING pg_select_list)?
    ;

pg_update_set
    : column+=pg_indirection_identifier PG_EQUAL (value+=pg_vex | PG_DEFAULT)
    | PG_LEFT_PAREN column+=pg_indirection_identifier (PG_COMMA column+=pg_indirection_identifier)* PG_RIGHT_PAREN PG_EQUAL PG_ROW?
    (PG_LEFT_PAREN (value+=pg_vex | PG_DEFAULT) (PG_COMMA (value+=pg_vex | PG_DEFAULT))* PG_RIGHT_PAREN | pg_table_subquery)
    ;

pg_notify_stmt
    : PG_NOTIFY channel=pg_identifier (PG_COMMA payload=pg_character_string)?
    ;

pg_truncate_stmt
    : PG_TRUNCATE PG_TABLE? pg_only_table_multiply (PG_COMMA pg_only_table_multiply)*
    ((PG_RESTART | PG_CONTINUE) PG_IDENTITY)? pg_cascade_restrict?
    ;

pg_identifier_list
    : pg_identifier (PG_COMMA pg_identifier)*
    ;

pg_anonymous_block
    : PG_DO (PG_LANGUAGE (pg_identifier | pg_character_string))? pg_character_string
    | PG_DO pg_character_string PG_LANGUAGE (pg_identifier | pg_character_string)
    ;

// plpgsql rules

pg_comp_options
    : PG_HASH_SIGN pg_identifier (pg_identifier | pg_truth_value)
    ;

pg_function_block
    : pg_start_label? pg_declarations?
    PG_BEGIN pg_function_statements pg_exception_statement?
    PG_END end_label=pg_identifier?
    ;

pg_start_label
    : PG_LESS_LESS pg_col_label PG_GREATER_GREATER
    ;

pg_declarations
    : PG_DECLARE pg_declaration*
    ;

pg_declaration
    : PG_DECLARE* pg_identifier pg_type_declaration PG_SEMI_COLON
    ;

pg_type_declaration
    : PG_CONSTANT? pg_data_type_dec pg_collate_identifier? (PG_NOT PG_NULL)? ((PG_DEFAULT | PG_COLON_EQUAL | PG_EQUAL) pg_vex)?
    | PG_ALIAS PG_FOR (pg_identifier | PG_DOLLAR_NUMBER)
    | (PG_NO? PG_SCROLL)? PG_CURSOR (PG_LEFT_PAREN pg_arguments_list PG_RIGHT_PAREN)? (PG_FOR | PG_IS) pg_select_stmt
    ;

pg_arguments_list
    : pg_identifier pg_data_type (PG_COMMA pg_identifier pg_data_type)*
    ;

pg_data_type_dec
    : pg_data_type
    | pg_schema_qualified_name PG_MODULAR PG_TYPE
    | pg_schema_qualified_name_nontype PG_MODULAR PG_ROWTYPE
    ;

pg_exception_statement
    : PG_EXCEPTION (PG_WHEN pg_vex PG_THEN pg_function_statements)+
    ;

pg_function_statements
    : (pg_function_statement PG_SEMI_COLON)*
    ;

pg_function_statement
    : pg_function_block
    | pg_base_statement
    | pg_control_statement
    | pg_transaction_statement
    | pg_cursor_statement
    | pg_message_statement
    | pg_schema_statement
    | pg_plpgsql_query
    | pg_additional_statement
    ;

pg_base_statement
    : pg_assign_stmt
    | PG_PERFORM pg_perform_stmt
    | PG_GET (PG_CURRENT | PG_STACKED)? PG_DIAGNOSTICS pg_diagnostic_option (PG_COMMA pg_diagnostic_option)*
    | PG_NULL
    ;

pg_var
    : (pg_schema_qualified_name | PG_DOLLAR_NUMBER) (PG_LEFT_BRACKET pg_vex PG_RIGHT_BRACKET)*
    ;

pg_diagnostic_option
    : pg_var (PG_COLON_EQUAL | PG_EQUAL) pg_identifier
    ;

// keep this in sync with select_primary (except intended differences)
pg_perform_stmt
    : (pg_set_qualifier (PG_ON PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN)?)?
    pg_select_list
    (PG_FROM pg_from_item (PG_COMMA pg_from_item)*)?
    (PG_WHERE pg_vex)?
    pg_groupby_clause?
    (PG_HAVING pg_vex)?
    (PG_WINDOW pg_identifier PG_AS pg_window_definition (PG_COMMA pg_identifier PG_AS pg_window_definition)*)?
    ((PG_INTERSECT | PG_UNION | PG_EXCEPT) pg_set_qualifier? pg_select_ops)?
    pg_after_ops*
    ;

pg_assign_stmt
    : pg_var (PG_COLON_EQUAL | PG_EQUAL) (pg_select_stmt_no_parens | pg_perform_stmt)
    ;

pg_execute_stmt
    : PG_EXECUTE pg_vex pg_using_vex?
    ;

pg_control_statement
    : pg_return_stmt
    | PG_CALL pg_function_call
    | pg_if_statement
    | pg_case_statement
    | pg_loop_statement
    ;

pg_cursor_statement
    : PG_OPEN pg_var (PG_NO? PG_SCROLL)? PG_FOR pg_plpgsql_query
    | PG_OPEN pg_var (PG_LEFT_PAREN pg_option (PG_COMMA pg_option)* PG_RIGHT_PAREN)?
    | PG_FETCH pg_fetch_move_direction? (PG_FROM | PG_IN)? pg_var
    | PG_MOVE pg_fetch_move_direction? (PG_FROM | PG_IN)? pg_var
    | PG_CLOSE pg_var
    ;

pg_option
    : (pg_identifier PG_COLON_EQUAL)? pg_vex
    ;

pg_transaction_statement
    : (PG_COMMIT | PG_ROLLBACK) (PG_AND PG_NO? PG_CHAIN)?
    | pg_lock_table
    ;

pg_message_statement
    : PG_RAISE pg_log_level? (pg_character_string (PG_COMMA pg_vex)*)? pg_raise_using?
    | PG_RAISE pg_log_level? pg_identifier pg_raise_using?
    | PG_RAISE pg_log_level? PG_SQLSTATE pg_character_string pg_raise_using?
    | PG_ASSERT pg_vex (PG_COMMA pg_vex)?
    ;

pg_log_level
    : PG_DEBUG
    | PG_LOG
    | PG_INFO
    | PG_NOTICE
    | PG_WARNING
    | PG_EXCEPTION
    ;

pg_raise_using
    : PG_USING pg_raise_param PG_EQUAL pg_vex (PG_COMMA pg_raise_param PG_EQUAL pg_vex)*
    ;

pg_raise_param
    : PG_MESSAGE
    | PG_DETAIL
    | PG_HINT
    | PG_ERRCODE
    | PG_COLUMN
    | PG_CONSTRAINT
    | PG_DATATYPE
    | PG_TABLE
    | PG_SCHEMA
    ;

pg_return_stmt
    : PG_RETURN pg_perform_stmt?
    | PG_RETURN PG_NEXT pg_vex
    | PG_RETURN PG_QUERY pg_plpgsql_query
    ;

pg_loop_statement
    : pg_start_label? pg_loop_start? PG_LOOP pg_function_statements PG_END PG_LOOP pg_identifier?
    | (PG_EXIT | PG_CONTINUE) pg_col_label? (PG_WHEN pg_vex)?
    ;

pg_loop_start
    : PG_WHILE pg_vex
    | PG_FOR alias=pg_identifier PG_IN PG_REVERSE? pg_vex PG_DOUBLE_DOT pg_vex (PG_BY pg_vex)?
    | PG_FOR pg_identifier_list PG_IN pg_plpgsql_query
    | PG_FOR cursor=pg_identifier PG_IN pg_identifier (PG_LEFT_PAREN pg_option (PG_COMMA pg_option)* PG_RIGHT_PAREN)? // cursor loop
    | PG_FOREACH pg_identifier_list (PG_SLICE PG_NUMBER_LITERAL)? PG_IN PG_ARRAY pg_vex
    ;

pg_using_vex
    : PG_USING pg_vex (PG_COMMA pg_vex)*
    ;

pg_if_statement
    : PG_IF pg_vex PG_THEN pg_function_statements ((PG_ELSIF | PG_ELSEIF) pg_vex PG_THEN pg_function_statements)* (PG_ELSE pg_function_statements)? PG_END PG_IF
    ;

// plpgsql case
pg_case_statement
    : PG_CASE pg_vex? (PG_WHEN pg_vex (PG_COMMA pg_vex)* PG_THEN pg_function_statements)+ (PG_ELSE pg_function_statements)? PG_END PG_CASE
    ;

pg_plpgsql_query
    : pg_data_statement
    | pg_execute_stmt
    | pg_show_statement
    | pg_explain_statement
    ;
