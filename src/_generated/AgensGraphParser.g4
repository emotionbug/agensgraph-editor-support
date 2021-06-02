parser grammar AgensGraphParser;

options {
    tokenVocab=AgensGraphLexer;
}
// to start parsing, it is recommended to use only rules with EOF
// this eliminates the ambiguous parsing options and speeds up the process
/******* Start symbols *******/

pg_sql
    : PG_BOM? PG_SEMI_COLON* (raw (PG_SEMI_COLON+ | EOF))* EOF
    ;

raw:
    pg_statement;

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
    : (PG_START SP PG_TRANSACTION | PG_BEGIN SP? (PG_WORK | PG_TRANSACTION)?) (SP pg_transaction_mode SP?(PG_COMMA SP? pg_transaction_mode SP?)*)?
    | (PG_COMMIT | PG_END | PG_ABORT | PG_ROLLBACK) (SP (PG_WORK | PG_TRANSACTION))? (SP PG_AND SP (PG_NO SP)? PG_CHAIN)?
    | (PG_COMMIT SP PG_PREPARED | PG_PREPARE SP PG_TRANSACTION) SP PG_Character_String_Literal
    | (PG_SAVEPOINT | PG_RELEASE (SP PG_SAVEPOINT)?) SP pg_identifier
    | PG_ROLLBACK SP PG_PREPARED SP PG_Character_String_Literal
    | PG_ROLLBACK SP ((PG_WORK | PG_TRANSACTION) SP)? PG_TO SP (PG_SAVEPOINT SP)? pg_identifier
    | pg_lock_table
    ;

pg_transaction_mode
    : PG_ISOLATION SP PG_LEVEL SP (PG_SERIALIZABLE | PG_REPEATABLE SP PG_READ | PG_READ SP PG_COMMITTED | PG_READ SP PG_UNCOMMITTED)
    | PG_READ SP PG_WRITE
    | PG_READ SP PG_ONLY
    | (PG_NOT SP)? PG_DEFERRABLE
    ;

pg_lock_table
    : PG_LOCK SP (PG_TABLE SP)? pg_only_table_multiply SP? (PG_COMMA pg_only_table_multiply SP?)* (PG_IN SP pg_lock_mode SP PG_MODE)? SP? PG_NOWAIT?
    ;

pg_lock_mode
    : (PG_ROW | PG_ACCESS) SP PG_SHARE
    | PG_ROW SP PG_EXCLUSIVE
    | PG_SHARE SP (PG_ROW | PG_UPDATE) SP PG_EXCLUSIVE
    | PG_SHARE
    | (PG_ACCESS SP)? PG_EXCLUSIVE
    ;

pg_script_additional
    : pg_additional_statement
    | PG_VACUUM (SP pg_vacuum_mode pg_table_cols_list)?
    | (PG_FETCH | PG_MOVE) (SP pg_fetch_move_direction)? (SP(PG_FROM | PG_IN))? SP pg_identifier
    | PG_CLOSE SP (pg_identifier | PG_ALL)
    | PG_CALL SP pg_function_call
    | PG_DISCARD SP (PG_ALL | PG_PLANS | PG_SEQUENCES | PG_TEMPORARY | PG_TEMP)
    | pg_declare_statement
    | pg_execute_statement
    | pg_explain_statement
    | pg_show_statement
    | ag_cypher_statement
    ;

pg_additional_statement
    : pg_anonymous_block
    | PG_LISTEN SP pg_identifier
    | PG_UNLISTEN (SP pg_identifier | PG_MULTIPLY)
    | PG_ANALYZE (SP PG_LEFT_PAREN SP? pg_analyze_mode (SP? PG_COMMA SP? pg_analyze_mode)* SP? PG_RIGHT_PAREN | SP PG_VERBOSE)? (SP pg_table_cols_list)?
    | PG_CLUSTER (SP PG_VERBOSE)? (SP pg_identifier SP PG_ON pg_schema_qualified_name | SP pg_schema_qualified_name (SP PG_USING pg_identifier)?)?
    | PG_CHECKPOINT
    | PG_LOAD SP PG_Character_String_Literal
    | PG_DEALLOCATE (SP PG_PREPARE)? (SP pg_identifier | SP PG_ALL)
    | PG_REINDEX (SP PG_LEFT_PAREN SP? PG_VERBOSE SP? PG_RIGHT_PAREN)? SP (PG_INDEX | PG_TABLE | PG_SCHEMA | PG_DATABASE | PG_SYSTEM | AG_VLABEL | AG_ELABEL) (SP PG_CONCURRENTLY)? SP pg_schema_qualified_name
    | PG_RESET SP ((pg_identifier PG_DOT)? pg_identifier | PG_TIME SP PG_ZONE | PG_SESSION SP PG_AUTHORIZATION | PG_ALL)
    | PG_REFRESH SP PG_MATERIALIZED SP PG_VIEW (SP PG_CONCURRENTLY)? SP pg_schema_qualified_name (SP PG_WITH (SP PG_NO)? SP PG_DATA)?
    | PG_PREPARE SP pg_identifier (SP? PG_LEFT_PAREN pg_data_type (SP? PG_COMMA pg_data_type)* SP? PG_RIGHT_PAREN)? SP PG_AS SP pg_data_statement
    | PG_REASSIGN SP PG_OWNED SP PG_BY SP pg_user_name (SP? PG_COMMA pg_user_name)* SP PG_TO SP pg_user_name
    | pg_copy_statement
    | pg_truncate_stmt
    | pg_notify_stmt
    ;

pg_explain_statement
    : PG_EXPLAIN ((SP PG_ANALYZE)? (SP PG_VERBOSE)? | SP PG_LEFT_PAREN SP? pg_explain_option (SP? PG_COMMA pg_explain_option)* SP? PG_RIGHT_PAREN) SP pg_explain_query;

pg_explain_query
    : pg_data_statement
    | pg_execute_statement
    | pg_declare_statement
    | ag_cypher_statement
    | PG_CREATE SP (pg_create_table_as_statement | pg_create_view_statement)
    ;

pg_execute_statement
    : PG_EXECUTE SP pg_identifier (SP? PG_LEFT_PAREN SP? pg_vex (SP? PG_COMMA pg_vex)* SP? PG_RIGHT_PAREN)?
    ;

pg_declare_statement
    : PG_DECLARE SP pg_identifier (SP PG_BINARY)? (SP PG_INSENSITIVE)? (SP PG_NO? PG_SCROLL)? SP PG_CURSOR (SP (PG_WITH | PG_WITHOUT) SP PG_HOLD)? SP PG_FOR SP pg_select_stmt
    ;

pg_show_statement
    : PG_SHOW SP ((pg_identifier PG_DOT)? pg_identifier | PG_ALL | PG_TIME SP PG_ZONE | PG_TRANSACTION SP PG_ISOLATION SP PG_LEVEL | PG_SESSION SP PG_AUTHORIZATION)
    ;

pg_explain_option
    : (PG_ANALYZE | PG_VERBOSE | PG_COSTS | PG_SETTINGS | PG_BUFFERS | PG_WAL | PG_TIMING | PG_SUMMARY) (SP pg_boolean_value)?
    | PG_FORMAT SP (PG_TEXT | PG_XML | PG_JSON | PG_YAML)
    ;

pg_user_name
    : pg_identifier | PG_CURRENT_USER | PG_SESSION_USER
    ;

pg_table_cols_list
    : pg_table_cols (SP? PG_COMMA pg_table_cols)*
    ;

pg_table_cols
    : pg_schema_qualified_name (SP? PG_LEFT_PAREN SP? pg_identifier (SP? PG_COMMA SP? pg_identifier)* SP? PG_RIGHT_PAREN)?
    ;

pg_vacuum_mode
    : PG_LEFT_PAREN SP? pg_vacuum_option SP? (SP? PG_COMMA SP? pg_vacuum_option)* SP? PG_RIGHT_PAREN
    | PG_FULL? (SP? PG_FREEZE)? (SP? PG_VERBOSE)? (SP? PG_ANALYZE)?
    ;

pg_vacuum_option
    : (PG_FULL | PG_FREEZE | PG_VERBOSE | PG_ANALYZE | PG_DISABLE_PAGE_SKIPPING | PG_SKIP_LOCKED | PG_INDEX_CLEANUP | PG_TRUNCATE) (SP pg_boolean_value)?
    | PG_PARALLEL SP PG_NUMBER_LITERAL
    ;

pg_analyze_mode
    : (PG_VERBOSE | PG_SKIP_LOCKED) (SP pg_boolean_value)?
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
    | ((PG_ABSOLUTE | PG_RELATIVE) SP)? pg_signed_number_literal
    | PG_ALL
    | PG_FORWARD (SP (PG_NUMBER_LITERAL | PG_ALL))?
    | PG_BACKWARD (SP (PG_NUMBER_LITERAL | PG_ALL))?
    ;

pg_schema_statement
    : pg_schema_create
    | pg_schema_alter
    | pg_schema_drop
    ;

pg_schema_create
    : PG_CREATE SP (pg_create_access_method_statement
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
    | ag_create_graph_statement
    | ag_create_label_statement)

    | pg_comment_on_statement
    | pg_rule_common
    | pg_schema_import
    | pg_security_label
    | pg_set_statement
    ;

pg_schema_alter
    : PG_ALTER SP (pg_alter_aggregate_statement
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
    | ag_alter_graph_statement
    | ag_alter_label_statement)
    ;

pg_schema_drop
    : PG_DROP SP (pg_drop_cast_statement
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
    : PG_IMPORT SP PG_FOREIGN SP PG_SCHEMA SP name=pg_identifier
    (SP (PG_LIMIT SP PG_TO | PG_EXCEPT) SP? PG_LEFT_PAREN SP? pg_identifier_list SP? PG_RIGHT_PAREN)?
    SP PG_FROM SP PG_SERVER SP pg_identifier SP PG_INTO SP pg_identifier
    (SP pg_define_foreign_options)?
    ;

pg_alter_function_statement
    : (PG_FUNCTION | PG_PROCEDURE) (SP pg_function_parameters)? (
        (pg_function_actions_common | PG_RESET SP ((pg_identifier PG_DOT)? SP pg_identifier | PG_ALL))+ (SP PG_RESTRICT)?
        | pg_rename_to
        | pg_set_schema
        | (PG_NO SP)? PG_DEPENDS SP PG_ON SP PG_EXTENSION SP pg_identifier
    )
    ;

pg_alter_aggregate_statement
    : PG_AGGREGATE SP pg_function_parameters SP (pg_rename_to | pg_set_schema)
    ;

pg_alter_extension_statement
    : PG_EXTENSION SP pg_identifier SP pg_alter_extension_action
    ;

pg_alter_extension_action
    : pg_set_schema
    | PG_UPDATE (SP PG_TO SP (pg_identifier | pg_character_string))?
    | (PG_ADD | PG_DROP) SP pg_extension_member_object
    ;

pg_extension_member_object
    : PG_ACCESS SP PG_METHOD SP pg_schema_qualified_name
    | PG_AGGREGATE SP pg_function_parameters
    | PG_CAST SP PG_LEFT_PAREN SP? pg_schema_qualified_name SP PG_AS SP pg_schema_qualified_name SP? PG_RIGHT_PAREN
    | PG_COLLATION SP pg_identifier
    | PG_CONVERSION SP pg_identifier
    | PG_DOMAIN SP pg_schema_qualified_name
    | PG_EVENT SP PG_TRIGGER SP pg_identifier
    | PG_FOREIGN SP PG_DATA SP PG_WRAPPER SP pg_identifier
    | PG_FOREIGN SP PG_TABLE SP pg_schema_qualified_name
    | PG_FUNCTION SP pg_function_parameters
    | (PG_MATERIALIZED SP)? PG_VIEW SP pg_schema_qualified_name
    | PG_OPERATOR SP pg_operator_name
    | PG_OPERATOR SP PG_CLASS SP pg_schema_qualified_name SP PG_USING SP pg_identifier
    | PG_OPERATOR SP PG_FAMILY SP pg_schema_qualified_name SP PG_USING SP pg_identifier
    | (PG_PROCEDURAL SP)? PG_LANGUAGE SP pg_identifier
    | PG_PROCEDURE SP pg_function_parameters
    | PG_ROUTINE SP pg_function_parameters
    | PG_SCHEMA SP pg_identifier
    | PG_SEQUENCE SP pg_schema_qualified_name
    | PG_SERVER SP pg_identifier
    | PG_TABLE SP pg_schema_qualified_name
    | PG_TEXT SP PG_SEARCH SP PG_CONFIGURATION SP pg_schema_qualified_name
    | PG_TEXT SP PG_SEARCH SP PG_DICTIONARY SP pg_schema_qualified_name
    | PG_TEXT SP PG_SEARCH SP PG_PARSER SP pg_schema_qualified_name
    | PG_TEXT SP PG_SEARCH SP PG_TEMPLATE SP pg_schema_qualified_name
    | PG_TRANSFORM SP PG_FOR SP pg_identifier SP PG_LANGUAGE SP pg_identifier
    | PG_TYPE SP pg_schema_qualified_name
    ;

pg_alter_schema_statement
    : PG_SCHEMA SP pg_identifier SP pg_rename_to
    ;

pg_alter_language_statement
    : (PG_PROCEDURAL SP)? PG_LANGUAGE SP name=pg_identifier SP (pg_rename_to | pg_owner_to)
    ;

pg_alter_table_statement
    : (PG_FOREIGN SP)? PG_TABLE SP (pg_if_exists SP)? (PG_ONLY SP)? name=pg_schema_qualified_name (SP? PG_MULTIPLY)?
    (SP (
        pg_table_action (SP? PG_COMMA SP? pg_table_action)*
        | PG_RENAME SP (PG_COLUMN SP)? pg_identifier SP PG_TO SP pg_identifier
        | pg_set_schema
        | pg_rename_to
        | PG_RENAME SP PG_CONSTRAINT SP pg_identifier PG_TO pg_identifier
        | PG_ATTACH SP PG_PARTITION SP child=pg_schema_qualified_name pg_for_values_bound
        | PG_DETACH SP PG_PARTITION SP child=pg_schema_qualified_name
    ))
    ;

pg_table_action
    : PG_ADD SP (PG_COLUMN SP)? (pg_if_not_exists SP)? pg_table_column_definition
    | PG_DROP SP (PG_COLUMN SP)? (pg_if_exists SP)? column=pg_identifier (SP pg_cascade_restrict)?
    | PG_ALTER SP (PG_COLUMN SP)? column=pg_identifier SP pg_column_action
    | PG_ADD SP tabl_constraint=pg_constraint_common (SP PG_NOT not_valid=PG_VALID)?
    | pg_validate_constraint
    | pg_drop_constraint
    | (PG_DISABLE | PG_ENABLE) SP PG_TRIGGER (SP (trigger_name=pg_schema_qualified_name | PG_ALL | PG_USER))?
    | PG_ENABLE SP (PG_REPLICA | PG_ALWAYS) SP PG_TRIGGER SP trigger_name=pg_schema_qualified_name
    | (PG_DISABLE | PG_ENABLE) SP PG_RULE SP rewrite_rule_name=pg_schema_qualified_name
    | PG_ENABLE SP (PG_REPLICA | PG_ALWAYS) SP PG_RULE SP rewrite_rule_name=pg_schema_qualified_name
    | (PG_DISABLE | PG_ENABLE) SP PG_ROW SP PG_LEVEL SP PG_SECURITY
    | (PG_NO SP)? PG_FORCE SP PG_ROW SP PG_LEVEL SP PG_SECURITY
    | PG_CLUSTER SP PG_ON SP index_name=pg_schema_qualified_name
    | PG_SET SP PG_WITHOUT SP (PG_CLUSTER | PG_OIDS)
    | PG_SET SP PG_WITH SP PG_OIDS
    | PG_SET SP (PG_LOGGED | PG_UNLOGGED)
    | PG_SET SP pg_storage_parameter
    | PG_RESET SP? pg_names_in_parens
    | pg_define_foreign_options
    | PG_INHERIT SP parent_table=pg_schema_qualified_name
    | PG_NO SP PG_INHERIT SP parent_table=pg_schema_qualified_name
    | PG_OF SP type_name=pg_schema_qualified_name
    | PG_NOT SP PG_OF
    | pg_owner_to
    | pg_set_tablespace
    | PG_REPLICA SP PG_IDENTITY SP (PG_DEFAULT | PG_FULL | PG_NOTHING | PG_USING SP PG_INDEX pg_identifier)
    | PG_ALTER SP PG_CONSTRAINT SP pg_identifier (SP pg_table_deferrable)? (SP pg_table_initialy_immed)?
    ;

pg_column_action
    : (PG_SET SP PG_DATA SP)? PG_TYPE SP pg_data_type (SP pg_collate_identifier?) (SP PG_USING pg_vex)?
    | PG_ADD SP pg_identity_body
    | pg_set_def_column
    | pg_drop_def
    | (set=PG_SET | PG_DROP) SP PG_NOT SP PG_NULL
    | PG_DROP SP PG_IDENTITY (SP pg_if_exists)?
    | PG_DROP SP PG_EXPRESSION (SP pg_if_exists)?
    | PG_SET SP pg_storage_parameter
    | pg_set_statistics
    | PG_SET SP PG_STORAGE SP pg_storage_option
    | PG_RESET SP? pg_names_in_parens
    | pg_define_foreign_options
    | pg_alter_identity+
    ;

pg_identity_body
    : PG_GENERATED SP (PG_ALWAYS | PG_BY SP PG_DEFAULT) SP PG_AS SP PG_IDENTITY (SP? PG_LEFT_PAREN SP? pg_sequence_body+ SP? PG_RIGHT_PAREN)?
    ;

pg_alter_identity
    : PG_SET SP PG_GENERATED SP (PG_ALWAYS | PG_BY SP PG_DEFAULT)
    | PG_SET SP pg_sequence_body
    | PG_RESTART (SP (PG_WITH SP)? PG_NUMBER_LITERAL)?
    ;

pg_storage_option
    : PG_PLAIN
    | PG_EXTERNAL
    | PG_EXTENDED
    | PG_MAIN
    ;

pg_validate_constraint
    : PG_VALIDATE SP PG_CONSTRAINT SP constraint_name=pg_schema_qualified_name
    ;

pg_drop_constraint
    : PG_DROP SP PG_CONSTRAINT SP (pg_if_exists SP)? constraint_name=pg_identifier (SP pg_cascade_restrict)?
    ;

pg_table_deferrable
    : (PG_NOT SP)? PG_DEFERRABLE
    ;

pg_table_initialy_immed
    : PG_INITIALLY SP (PG_DEFERRED | PG_IMMEDIATE)
    ;

pg_function_actions_common
    : (PG_CALLED | PG_RETURNS SP PG_NULL) SP PG_ON SP PG_NULL SP PG_INPUT
    | PG_TRANSFORM SP pg_transform_for_type SP? (SP? PG_COMMA SP? pg_transform_for_type)*
    | PG_STRICT
    | PG_IMMUTABLE
    | PG_VOLATILE
    | PG_STABLE
    | (PG_NOT SP)? PG_LEAKPROOF
    | (PG_EXTERNAL SP)? PG_SECURITY SP (PG_INVOKER | PG_DEFINER)
    | PG_PARALLEL SP (PG_SAFE | PG_UNSAFE | PG_RESTRICTED)
    | PG_COST SP execution_cost=pg_unsigned_numeric_literal
    | PG_ROWS SP result_rows=pg_unsigned_numeric_literal
    | PG_SUPPORT SP pg_schema_qualified_name
    | PG_SET SP (config_scope=pg_identifier PG_DOT)? config_param=pg_identifier SP ((PG_TO | PG_EQUAL) SP pg_set_statement_value | PG_FROM SP PG_CURRENT)
    | PG_LANGUAGE SP lang_name=pg_identifier
    | PG_WINDOW
    | PG_AS SP pg_function_def
    ;

pg_function_def
    : definition=pg_character_string (SP? PG_COMMA SP? symbol=pg_character_string)?
    ;

pg_alter_index_statement
    : PG_INDEX SP (pg_if_exists SP)? pg_schema_qualified_name SP pg_index_def_action
    | PG_INDEX SP PG_ALL SP PG_IN SP PG_TABLESPACE SP pg_identifier SP (PG_OWNED SP PG_BY SP pg_identifier_list SP)? pg_set_tablespace
    ;

pg_index_def_action
    : pg_rename_to
    | PG_ATTACH SP PG_PARTITION SP index=pg_schema_qualified_name
    | (PG_NO SP)? PG_DEPENDS SP PG_ON SP PG_EXTENSION SP pg_schema_qualified_name
    | PG_ALTER SP (PG_COLUMN SP)? (PG_NUMBER_LITERAL | pg_identifier) SP pg_set_statistics
    | PG_RESET SP PG_LEFT_PAREN SP? pg_identifier_list SP? PG_RIGHT_PAREN
    | pg_set_tablespace
    | PG_SET pg_storage_parameter
    ;

pg_alter_default_privileges_statement
    : PG_DEFAULT SP PG_PRIVILEGES SP
    (PG_FOR SP (PG_ROLE | PG_USER) SP? pg_identifier_list SP)?
    (PG_IN SP PG_SCHEMA SP pg_identifier_list SP)?
    pg_abbreviated_grant_or_revoke
    ;

pg_abbreviated_grant_or_revoke
    : (PG_GRANT | PG_REVOKE (SP pg_grant_option_for)?) SP (
        pg_table_column_privilege SP? (SP? PG_COMMA SP? pg_table_column_privilege)* SP PG_ON SP PG_TABLES
        | (pg_usage_select_update SP? (SP? PG_COMMA SP? pg_usage_select_update)* | PG_ALL SP (PG_PRIVILEGES SP)?) PG_ON SP PG_SEQUENCES
        | (PG_EXECUTE | PG_ALL (SP PG_PRIVILEGES)?) SP PG_ON SP PG_FUNCTIONS
        | (PG_USAGE | PG_CREATE | PG_ALL (SP PG_PRIVILEGES)?) SP PG_ON SP PG_SCHEMAS
        | (PG_USAGE | PG_ALL (SP PG_PRIVILEGES)?) SP PG_ON SP PG_TYPES)
    (pg_grant_to_rule | pg_revoke_from_cascade_restrict)
    ;

pg_grant_option_for
    : PG_GRANT SP PG_OPTION SP PG_FOR
    ;

pg_alter_sequence_statement
    : PG_SEQUENCE SP (pg_if_exists SP)? name=pg_schema_qualified_name SP
        ( (pg_sequence_body | PG_RESTART (SP (PG_WITH SP)? pg_signed_number_literal)?)*
        | pg_set_schema
        | pg_rename_to)
    ;

pg_alter_view_statement
    : PG_VIEW SP (pg_if_exists SP)? name=pg_schema_qualified_name SP pg_alter_view_action
    ;

pg_alter_view_action
    : PG_ALTER SP (PG_COLUMN SP)? column_name=pg_identifier SP pg_set_def_column
    | PG_ALTER SP (PG_COLUMN SP)? column_name=pg_identifier SP pg_drop_def
    | PG_RENAME SP (PG_COLUMN SP)? pg_identifier SP PG_TO SP pg_identifier
    | pg_rename_to
    | pg_set_schema
    | PG_SET SP pg_storage_parameter
    | PG_RESET SP pg_names_in_parens
    ;

pg_alter_materialized_view_statement
    : PG_MATERIALIZED SP PG_VIEW SP (pg_if_exists SP)? pg_schema_qualified_name SP pg_alter_materialized_view_action
    | PG_MATERIALIZED SP PG_VIEW SP PG_ALL SP PG_IN SP PG_TABLESPACE SP pg_identifier SP (PG_OWNED SP PG_BY pg_identifier_list SP)? pg_set_tablespace
    ;

pg_alter_materialized_view_action
    : pg_rename_to
    | pg_set_schema
    | PG_RENAME SP (PG_COLUMN SP)? pg_identifier SP PG_TO SP pg_identifier
    | (PG_NO SP)? PG_DEPENDS SP PG_ON SP PG_EXTENSION SP pg_identifier
    | pg_materialized_view_action SP? (SP? PG_COMMA SP? pg_materialized_view_action)*
    ;

pg_materialized_view_action
    : PG_ALTER SP (PG_COLUMN SP)? pg_identifier SP SP pg_set_statistics
    | PG_ALTER SP (PG_COLUMN SP)? pg_identifier SP PG_SET SP pg_storage_parameter
    | PG_ALTER SP (PG_COLUMN SP)? pg_identifier SP PG_RESET SP pg_names_in_parens
    | PG_ALTER SP (PG_COLUMN SP)? pg_identifier SP PG_SET SP PG_STORAGE SP pg_storage_option
    | PG_CLUSTER SP PG_ON SP index_name=pg_schema_qualified_name
    | PG_SET SP PG_WITHOUT SP PG_CLUSTER
    | PG_SET SP pg_storage_parameter
    | PG_RESET SP pg_names_in_parens
    ;

pg_alter_event_trigger_statement
    : PG_EVENT SP PG_TRIGGER SP name=pg_identifier SP pg_alter_event_trigger_action
    ;

pg_alter_event_trigger_action
    : PG_DISABLE
    | PG_ENABLE (SP (PG_REPLICA | PG_ALWAYS))?
    | pg_owner_to
    | pg_rename_to
    ;

pg_alter_type_statement
    : PG_TYPE SP name=pg_schema_qualified_name
      SP (pg_set_schema
      | pg_rename_to
      | PG_ADD SP PG_VALUE SP (pg_if_not_exists SP)? new_enum_value=pg_character_string (SP (PG_BEFORE | PG_AFTER) SP existing_enum_value=pg_character_string)?
      | PG_RENAME SP PG_ATTRIBUTE SP attribute_name=pg_identifier SP PG_TO SP new_attribute_name=pg_identifier (SP pg_cascade_restrict)?
      | PG_RENAME SP PG_VALUE SP existing_enum_name=pg_character_string SP PG_TO SP new_enum_name=pg_character_string
      | pg_type_action SP? (SP? PG_COMMA SP? pg_type_action)*
      | PG_SET SP? PG_LEFT_PAREN SP? pg_type_property (SP? PG_COMMA SP? pg_type_property)* SP? PG_RIGHT_PAREN)
    ;

pg_alter_domain_statement
    : PG_DOMAIN SP name=pg_schema_qualified_name SP
    (pg_set_def_column
    | pg_drop_def
    | (PG_SET | PG_DROP) SP PG_NOT SP PG_NULL
    | PG_ADD SP dom_constraint=pg_domain_constraint (SP PG_NOT not_valid=PG_VALID)?
    | pg_drop_constraint
    | PG_RENAME SP PG_CONSTRAINT SP pg_schema_qualified_name SP PG_TO SP pg_schema_qualified_name
    | pg_validate_constraint
    | pg_rename_to
    | pg_set_schema)
    ;

pg_alter_server_statement
    : PG_SERVER SP pg_identifier SP pg_alter_server_action
    ;

pg_alter_server_action
    : (PG_VERSION SP pg_character_string SP)? pg_define_foreign_options
    | PG_VERSION SP pg_character_string
    | pg_owner_to
    | pg_rename_to
    ;

pg_alter_fts_statement
    : PG_TEXT SP PG_SEARCH
      ((PG_TEMPLATE | PG_DICTIONARY | PG_CONFIGURATION | PG_PARSER) SP name=pg_schema_qualified_name SP (pg_rename_to | pg_set_schema)
      | PG_DICTIONARY SP name=pg_schema_qualified_name pg_storage_parameter
      | PG_CONFIGURATION SP name=pg_schema_qualified_name pg_alter_fts_configuration)
    ;

pg_alter_fts_configuration
    : (PG_ADD | PG_ALTER) SP PG_MAPPING SP PG_FOR SP pg_identifier_list SP PG_WITH SP pg_schema_qualified_name SP? (SP? PG_COMMA SP? pg_schema_qualified_name)*
    | PG_ALTER SP PG_MAPPING SP (PG_FOR pg_identifier_list SP)? PG_REPLACE SP pg_schema_qualified_name SP PG_WITH SP pg_schema_qualified_name
    | PG_DROP SP PG_MAPPING SP (PG_IF PG_EXISTS SP)? PG_FOR SP pg_identifier_list
    ;

pg_type_action
    : PG_ADD SP PG_ATTRIBUTE SP pg_identifier (SP pg_data_type pg_collate_identifier)? (SP pg_cascade_restrict)?
    | PG_DROP SP PG_ATTRIBUTE SP (pg_if_exists SP)? pg_identifier (SP pg_cascade_restrict)?
    | PG_ALTER SP PG_ATTRIBUTE SP pg_identifier SP (PG_SET SP PG_DATA SP)? PG_TYPE SP pg_data_type (SP pg_collate_identifier)? (SP pg_cascade_restrict)?
    ;

pg_type_property
    : (PG_RECEIVE | PG_SEND | PG_TYPMOD_IN | PG_TYPMOD_OUT | PG_ANALYZE) SP PG_EQUAL SP pg_schema_qualified_name
    | PG_STORAGE SP PG_EQUAL SP storage=pg_storage_option
    ;

pg_set_def_column
    : PG_SET SP PG_DEFAULT SP pg_vex
    ;

pg_drop_def
    : PG_DROP SP PG_DEFAULT
    ;

pg_create_index_statement
    : (PG_UNIQUE SP)? PG_INDEX SP (PG_CONCURRENTLY SP)? (pg_if_not_exists SP)? (name=pg_identifier SP)? PG_ON SP (PG_ONLY SP)? table_name=pg_schema_qualified_name SP pg_index_rest
    ;

pg_index_rest
    : (PG_USING SP method=pg_identifier SP)? pg_index_sort (SP pg_including_index)? (SP pg_with_storage_parameter)? (SP pg_table_space)? (SP pg_index_where)?
    ;

pg_index_sort
    : PG_LEFT_PAREN SP? pg_index_column SP? (SP? PG_COMMA SP? pg_index_column)* SP? PG_RIGHT_PAREN
    ;

pg_index_column
    : column=pg_vex SP (SP operator_class=pg_schema_qualified_name)?
    (SP PG_LEFT_PAREN SP? pg_option_with_value SP? (SP? PG_COMMA SP? pg_option_with_value)* SP? PG_RIGHT_PAREN)?
    (SP pg_order_specification)? (SP pg_null_ordering)?
    ;

pg_including_index
    : PG_INCLUDE SP PG_LEFT_PAREN SP? pg_identifier SP? (SP? PG_COMMA SP? pg_identifier)* SP? PG_RIGHT_PAREN
    ;

pg_index_where
    : PG_WHERE SP pg_vex
    ;

 pg_create_extension_statement
    : PG_EXTENSION SP (pg_if_not_exists SP)? name=pg_identifier
    (SP PG_WITH)?
    (SP PG_SCHEMA schema=pg_identifier)?
    (SP PG_VERSION SP (pg_identifier | pg_character_string))?
    (SP PG_FROM SP (pg_identifier | pg_character_string))?
    (SP PG_CASCADE)?
    ;

pg_create_language_statement
    : (PG_OR SP PG_REPLACE SP)? (PG_TRUSTED SP)? (PG_PROCEDURAL SP)? PG_LANGUAGE SP name=pg_identifier
    (SP PG_HANDLER SP pg_schema_qualified_name (SP PG_INLINE SP pg_schema_qualified_name)? (SP PG_VALIDATOR SP pg_schema_qualified_name)?)?
    ;

pg_create_event_trigger_statement
    : PG_EVENT SP PG_TRIGGER SP name=pg_identifier SP PG_ON SP pg_identifier SP
    (PG_WHEN (SP pg_schema_qualified_name SP PG_IN SP PG_LEFT_PAREN SP? pg_character_string (SP? PG_COMMA SP? pg_character_string)* SP? PG_RIGHT_PAREN (SP PG_AND)?)+ SP)?
    PG_EXECUTE SP (PG_PROCEDURE | PG_FUNCTION) SP pg_vex
    ;

pg_create_type_statement
    : PG_TYPE SP name=pg_schema_qualified_name SP? (PG_AS SP?(
        PG_LEFT_PAREN SP? (attrs+=pg_table_column_definition SP? (SP? PG_COMMA SP? attrs+=pg_table_column_definition)*)? SP? PG_RIGHT_PAREN
        | PG_ENUM SP? PG_LEFT_PAREN SP? (enums+=pg_character_string SP? (SP? PG_COMMA SP? enums+=pg_character_string)* )? SP? PG_RIGHT_PAREN
        | PG_RANGE SP? PG_LEFT_PAREN SP?
                (PG_SUBTYPE SP? PG_EQUAL SP? subtype_name=pg_data_type
                | PG_SUBTYPE_OPCLASS SP? PG_EQUAL SP? subtype_operator_class=pg_identifier
                | PG_COLLATION SP? PG_EQUAL SP? collation=pg_schema_qualified_name
                | PG_CANONICAL SP? PG_EQUAL SP? canonical_function=pg_schema_qualified_name
                | PG_SUBTYPE_DIFF SP? PG_EQUAL SP? subtype_diff_function=pg_schema_qualified_name)?
                (SP? PG_COMMA SP? (PG_SUBTYPE SP? PG_EQUAL SP? subtype_name=pg_data_type
                | PG_SUBTYPE_OPCLASS SP? PG_EQUAL SP? subtype_operator_class=pg_identifier
                | PG_COLLATION SP? PG_EQUAL SP? collation=pg_schema_qualified_name
                | PG_CANONICAL SP? PG_EQUAL SP? canonical_function=pg_schema_qualified_name
                | PG_SUBTYPE_DIFF SP? PG_EQUAL SP? subtype_diff_function=pg_schema_qualified_name))*
            SP? PG_RIGHT_PAREN)
    | PG_LEFT_PAREN SP?
            // pg_dump prints PG_internallength first
            (PG_INTERNALLENGTH SP? PG_EQUAL SP? (internallength=pg_signed_numerical_literal | PG_VARIABLE) PG_COMMA SP?)?
            PG_INPUT SP? PG_EQUAL SP? input_function=pg_schema_qualified_name PG_COMMA SP?
            PG_OUTPUT SP? PG_EQUAL SP? output_function=pg_schema_qualified_name SP?
            (SP? PG_COMMA SP? (PG_RECEIVE SP? PG_EQUAL SP? receive_function=pg_schema_qualified_name
            | PG_SEND SP? PG_EQUAL SP? send_function=pg_schema_qualified_name
            | PG_TYPMOD_IN SP? PG_EQUAL SP? type_modifier_input_function=pg_schema_qualified_name
            | PG_TYPMOD_OUT SP? PG_EQUAL SP? type_modifier_output_function=pg_schema_qualified_name
            | PG_ANALYZE SP? PG_EQUAL SP? analyze_function=pg_schema_qualified_name
            | PG_INTERNALLENGTH SP? PG_EQUAL SP? (internallength=pg_signed_numerical_literal | PG_VARIABLE )
            | PG_PASSEDBYVALUE
            | PG_ALIGNMENT SP? PG_EQUAL SP? alignment=pg_data_type
            | PG_STORAGE SP? PG_EQUAL SP? storage=pg_storage_option
            | PG_LIKE SP? PG_EQUAL SP? like_type=pg_data_type
            | PG_CATEGORY SP? PG_EQUAL SP? category=pg_character_string
            | PG_PREFERRED SP? PG_EQUAL SP? preferred=pg_truth_value
            | PG_DEFAULT SP? PG_EQUAL SP? default_value=pg_vex
            | PG_ELEMENT SP? PG_EQUAL SP? element=pg_data_type
            | PG_DELIMITER SP? PG_EQUAL SP? delimiter=pg_character_string
            | PG_COLLATABLE SP? PG_EQUAL SP? collatable=pg_truth_value))*
        SP? PG_RIGHT_PAREN)?
    ;

pg_create_domain_statement
    : PG_DOMAIN SP name=pg_schema_qualified_name SP (PG_AS SP)? dat_type=pg_data_type
    (SP (pg_collate_identifier | PG_DEFAULT def_value=pg_vex | dom_constraint+=pg_domain_constraint))*
    ;

pg_create_server_statement
    : PG_SERVER SP (pg_if_not_exists SP)? pg_identifier SP (PG_TYPE pg_character_string SP)? (PG_VERSION pg_character_string SP)?
    PG_FOREIGN SP PG_DATA SP PG_WRAPPER SP pg_identifier
    (SP pg_define_foreign_options)?
    ;

pg_create_fts_dictionary_statement
    : PG_TEXT SP PG_SEARCH SP PG_DICTIONARY SP name=pg_schema_qualified_name SP?
    PG_LEFT_PAREN SP?
        PG_TEMPLATE SP? PG_EQUAL SP? template=pg_schema_qualified_name SP? (SP? PG_COMMA SP? pg_option_with_value)*
    SP? PG_RIGHT_PAREN
    ;

pg_option_with_value
    : pg_identifier SP? PG_EQUAL SP? pg_vex
    ;

pg_create_fts_configuration_statement
    : PG_TEXT SP PG_SEARCH SP PG_CONFIGURATION SP name=pg_schema_qualified_name SP?
    PG_LEFT_PAREN SP?
        (PG_PARSER SP? PG_EQUAL SP? parser_name=pg_schema_qualified_name
        | PG_COPY SP? PG_EQUAL SP? config_name=pg_schema_qualified_name) SP?
    PG_RIGHT_PAREN
    ;

pg_create_fts_template_statement
    : PG_TEXT SP PG_SEARCH SP PG_TEMPLATE SP name=pg_schema_qualified_name SP?
    PG_LEFT_PAREN SP?
        (PG_INIT SP? PG_EQUAL SP? init_name=pg_schema_qualified_name SP? PG_COMMA SP?)?
        PG_LEXIZE SP? PG_EQUAL SP? lexize_name=pg_schema_qualified_name SP?
        (PG_COMMA SP? PG_INIT SP? PG_EQUAL SP? init_name=pg_schema_qualified_name SP?)?
    PG_RIGHT_PAREN
    ;

pg_create_fts_parser_statement
    : PG_TEXT SP PG_SEARCH SP PG_PARSER SP name=pg_schema_qualified_name
    PG_LEFT_PAREN SP?
        PG_START SP? PG_EQUAL SP? start_func=pg_schema_qualified_name SP? PG_COMMA SP?
        PG_GETTOKEN SP? PG_EQUAL SP? gettoken_func=pg_schema_qualified_name SP? PG_COMMA SP?
        PG_END SP? PG_EQUAL SP? end_func=pg_schema_qualified_name SP? PG_COMMA SP?
        (PG_HEADLINE SP? PG_EQUAL SP? headline_func=pg_schema_qualified_name SP? PG_COMMA SP?)?
        PG_LEXTYPES SP? PG_EQUAL SP? lextypes_func=pg_schema_qualified_name
        (PG_COMMA SP? PG_HEADLINE SP? PG_EQUAL SP? headline_func=pg_schema_qualified_name)?
    SP? PG_RIGHT_PAREN
    ;

pg_create_collation_statement
    : PG_COLLATION SP (pg_if_not_exists SP)? name=pg_schema_qualified_name SP
    (PG_FROM SP pg_schema_qualified_name | PG_LEFT_PAREN SP? (pg_collation_option (SP? PG_COMMA SP? pg_collation_option)* SP?)? PG_RIGHT_PAREN)
    ;

pg_alter_collation_statement
    : PG_COLLATION SP name=pg_schema_qualified_name SP (PG_REFRESH SP PG_VERSION | pg_rename_to | pg_owner_to | pg_set_schema)
    ;

pg_collation_option
    : (PG_LOCALE | PG_LC_COLLATE | PG_LC_CTYPE | PG_PROVIDER | PG_VERSION) SP? PG_EQUAL SP? (pg_character_string | pg_identifier)
    | PG_DETERMINISTIC SP? PG_EQUAL SP? pg_boolean_value
    ;

pg_create_user_mapping_statement
    : PG_USER SP PG_MAPPING SP (pg_if_not_exists SP)? PG_FOR SP (pg_user_name | PG_USER) SP PG_SERVER SP pg_identifier (SP pg_define_foreign_options)?
    ;

pg_alter_user_mapping_statement
    : PG_USER SP PG_MAPPING SP PG_FOR SP (pg_user_name | PG_USER) SP PG_SERVER SP pg_identifier (SP pg_define_foreign_options?)
    ;

pg_alter_user_or_role_statement
    : (PG_USER | PG_ROLE) SP (pg_alter_user_or_role_set_reset | pg_identifier pg_rename_to | pg_user_name (SP PG_WITH)? (SP pg_user_or_role_option_for_alter)+)
    ;

pg_alter_user_or_role_set_reset
    : (pg_user_name | PG_ALL) SP (PG_IN PG_DATABASE pg_identifier SP)? pg_set_reset_parameter
    ;

pg_set_reset_parameter
    : PG_SET SP (pg_identifier PG_DOT)? pg_identifier SP (PG_TO | PG_EQUAL) SP pg_set_statement_value
    | PG_SET SP (pg_identifier PG_DOT)? pg_identifier SP PG_FROM SP PG_CURRENT
    | PG_RESET SP (pg_identifier PG_DOT)? pg_identifier
    | PG_RESET SP PG_ALL
    ;

pg_alter_group_statement
    : PG_GROUP SP pg_alter_group_action
    ;

pg_alter_group_action
    : name=pg_identifier SP pg_rename_to
    | pg_user_name SP (PG_ADD | PG_DROP) SP PG_USER SP? pg_identifier_list
    ;

pg_alter_tablespace_statement
    : PG_TABLESPACE SP name=pg_identifier SP pg_alter_tablespace_action
    ;

pg_alter_owner_statement
    : (PG_OPERATOR SP pg_target_operator
        | PG_LARGE SP PG_OBJECT SP PG_NUMBER_LITERAL
        | (PG_FUNCTION | PG_PROCEDURE | PG_AGGREGATE) SP name=pg_schema_qualified_name SP? pg_function_args
        | (PG_TEXT SP PG_SEARCH SP PG_DICTIONARY | PG_TEXT SP PG_SEARCH SP PG_CONFIGURATION | PG_DOMAIN | PG_SCHEMA | PG_SEQUENCE | PG_TYPE | (PG_MATERIALIZED SP)? PG_VIEW)
        SP (pg_if_exists SP)? name=pg_schema_qualified_name) SP pg_owner_to
    ;

pg_alter_tablespace_action
    : pg_rename_to
    | pg_owner_to
    | PG_SET SP? PG_LEFT_PAREN SP? pg_option_with_value SP? (SP? PG_COMMA SP? pg_option_with_value)* SP? PG_RIGHT_PAREN
    | PG_RESET SP? PG_LEFT_PAREN SP? pg_identifier_list SP? PG_RIGHT_PAREN
    ;

pg_alter_statistics_statement
    : PG_STATISTICS SP name=pg_schema_qualified_name SP (pg_rename_to | pg_set_schema | pg_owner_to | pg_set_statistics)
    ;

pg_set_statistics
    : PG_SET SP PG_STATISTICS SP pg_signed_number_literal
    ;

pg_alter_foreign_data_wrapper
    : PG_FOREIGN SP PG_DATA SP PG_WRAPPER SP name=pg_identifier SP pg_alter_foreign_data_wrapper_action
    ;

pg_alter_foreign_data_wrapper_action
    : (PG_HANDLER SP pg_schema_qualified_name_nontype | PG_NO SP PG_HANDLER )? SP? (PG_VALIDATOR SP pg_schema_qualified_name_nontype | PG_NO SP PG_VALIDATOR)? SP? pg_define_foreign_options?
    | pg_owner_to
    | pg_rename_to
    ;

pg_alter_operator_statement
    : PG_OPERATOR SP pg_target_operator SP pg_alter_operator_action
    ;

pg_alter_operator_action
    : pg_set_schema
    | PG_SET SP? PG_LEFT_PAREN SP? pg_operator_set_restrict_join SP? (SP? PG_COMMA SP? pg_operator_set_restrict_join)* SP? PG_RIGHT_PAREN
    ;

pg_operator_set_restrict_join
    : (PG_RESTRICT | PG_JOIN) SP? PG_EQUAL SP? pg_schema_qualified_name
    ;

pg_drop_user_mapping_statement
    : PG_USER SP PG_MAPPING SP (pg_if_exists SP)? PG_FOR SP (pg_user_name | PG_USER) SP PG_SERVER SP pg_identifier
    ;

pg_drop_owned_statement
    : PG_OWNED SP PG_BY SP pg_user_name SP? (SP? PG_COMMA SP? pg_user_name)* (SP pg_cascade_restrict)?
    ;

pg_drop_operator_statement
    : PG_OPERATOR SP (SP pg_if_exists)? pg_target_operator SP? (SP? PG_COMMA SP? pg_target_operator)* (SP pg_cascade_restrict)?
    ;

pg_target_operator
    : name=pg_operator_name SP? PG_LEFT_PAREN SP? (left_type=pg_data_type | PG_NONE) SP? PG_COMMA SP? (right_type=pg_data_type | PG_NONE) SP? PG_RIGHT_PAREN
    ;

pg_domain_constraint
    : (PG_CONSTRAINT SP name=pg_identifier SP)? (PG_CHECK SP? PG_LEFT_PAREN SP? pg_vex SP? PG_RIGHT_PAREN | (PG_NOT SP)? PG_NULL)
    ;

pg_create_transform_statement
    : (PG_OR SP PG_REPLACE SP)? PG_TRANSFORM SP PG_FOR SP pg_data_type SP PG_LANGUAGE SP pg_identifier SP?
    PG_LEFT_PAREN SP?
        PG_FROM SP PG_SQL SP PG_WITH SP PG_FUNCTION SP pg_function_parameters SP? PG_COMMA SP?
        PG_TO SP PG_SQL SP PG_WITH SP PG_FUNCTION SP pg_function_parameters
    PG_RIGHT_PAREN
    ;

pg_create_access_method_statement
    : PG_ACCESS SP PG_METHOD SP pg_identifier SP PG_TYPE SP (PG_TABLE | PG_INDEX) SP PG_HANDLER SP pg_schema_qualified_name
    ;

pg_create_user_or_role_statement
    : (PG_USER | PG_ROLE) SP name=pg_identifier (SP (PG_WITH SP)? pg_user_or_role_option (SP pg_user_or_role_option)*)?
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
    | (PG_ENCRYPTED SP)? PG_PASSWORD SP (password=PG_Character_String_Literal | PG_NULL)
    | PG_VALID SP PG_UNTIL SP date_time=PG_Character_String_Literal
    ;

pg_user_or_role_common_option
    : PG_REPLICATION | PG_NOREPLICATION
    | PG_BYPASSRLS | PG_NOBYPASSRLS
    | PG_CONNECTION SP PG_LIMIT SP pg_signed_number_literal
    ;

pg_user_or_role_or_group_option_for_create
    : PG_SYSID SP pg_vex
    | (PG_IN SP PG_ROLE | PG_IN SP PG_GROUP | PG_ROLE | PG_ADMIN | PG_USER) SP pg_identifier_list
    ;

pg_create_group_statement
    : PG_GROUP SP name=pg_identifier ((SP PG_WITH)? (SP? pg_group_option)+)?
    ;

pg_group_option
    : pg_user_or_role_or_group_common_option
    | pg_user_or_role_or_group_option_for_create
    ;

pg_create_tablespace_statement
    : PG_TABLESPACE SP name=pg_identifier SP (PG_OWNER SP pg_user_name SP)?
    PG_LOCATION SP directory=PG_Character_String_Literal
    (SP PG_WITH SP? PG_LEFT_PAREN SP? pg_option_with_value (SP? PG_COMMA SP? pg_option_with_value)* SP? PG_RIGHT_PAREN)?
    ;

pg_create_statistics_statement
    : PG_STATISTICS SP (pg_if_not_exists SP)? SP name=pg_schema_qualified_name
    (SP? PG_LEFT_PAREN SP? pg_identifier_list SP? PG_RIGHT_PAREN)? SP?
    PG_ON SP pg_identifier SP? PG_COMMA SP? pg_identifier_list SP
    PG_FROM SP pg_schema_qualified_name
    ;

pg_create_foreign_data_wrapper_statement
    : PG_FOREIGN SP PG_DATA SP PG_WRAPPER SP name=pg_identifier (SP (PG_HANDLER SP pg_schema_qualified_name_nontype | PG_NO SP PG_HANDLER ))?
    (SP (PG_VALIDATOR pg_schema_qualified_name_nontype | PG_NO PG_VALIDATOR))?
    (SP PG_OPTIONS SP? PG_LEFT_PAREN SP? pg_option_without_equal (SP? PG_COMMA SP? pg_option_without_equal)* SP? PG_RIGHT_PAREN )?
    ;

pg_option_without_equal
    : pg_identifier SP PG_Character_String_Literal
    ;

pg_create_operator_statement
    : PG_OPERATOR SP name=pg_operator_name SP? PG_LEFT_PAREN SP? pg_operator_option (SP? PG_COMMA SP? pg_operator_option)* SP? PG_RIGHT_PAREN
    ;

pg_operator_name
    : (schema_name=pg_identifier PG_DOT)? operator=pg_all_simple_op
    ;

pg_operator_option
    : (PG_FUNCTION | PG_PROCEDURE) SP? PG_EQUAL SP? func_name=pg_schema_qualified_name
    | PG_RESTRICT SP? PG_EQUAL SP? restr_name=pg_schema_qualified_name
    | PG_JOIN SP? PG_EQUAL SP? join_name=pg_schema_qualified_name
    | (PG_LEFTARG | PG_RIGHTARG) SP? PG_EQUAL SP? type=pg_data_type
    | (PG_COMMUTATOR | PG_NEGATOR) SP? PG_EQUAL SP? addition_oper_name=pg_all_op_ref
    | PG_HASHES
    | PG_MERGES
    ;

pg_create_aggregate_statement
    : (PG_OR SP PG_REPLACE SP)? PG_AGGREGATE SP name=pg_schema_qualified_name (SP? pg_function_args)? SP? PG_LEFT_PAREN SP?
    (PG_BASETYPE SP? PG_EQUAL SP? base_type=pg_data_type SP? PG_COMMA SP?)?
    PG_SFUNC SP? PG_EQUAL SP? sfunc_name=pg_schema_qualified_name SP? PG_COMMA SP?
    PG_STYPE SP? PG_EQUAL SP? type=pg_data_type
    (SP? PG_COMMA SP? pg_aggregate_param)* SP?
    PG_RIGHT_PAREN
    ;

pg_aggregate_param
    : PG_SSPACE SP? PG_EQUAL SP? s_space=PG_NUMBER_LITERAL
    | PG_FINALFUNC SP? PG_EQUAL SP? final_func=pg_schema_qualified_name
    | PG_FINALFUNC_EXTRA
    | PG_FINALFUNC_MODIFY SP? PG_EQUAL SP? (PG_READ_ONLY | PG_SHAREABLE | PG_READ_WRITE)
    | PG_COMBINEFUNC SP? PG_EQUAL SP? combine_func=pg_schema_qualified_name
    | PG_SERIALFUNC SP? PG_EQUAL SP? serial_func=pg_schema_qualified_name
    | PG_DESERIALFUNC SP? PG_EQUAL SP? deserial_func=pg_schema_qualified_name
    | PG_INITCOND SP? PG_EQUAL SP? init_cond=pg_vex
    | PG_MSFUNC SP? PG_EQUAL SP? ms_func=pg_schema_qualified_name
    | PG_MINVFUNC SP? PG_EQUAL SP? minv_func=pg_schema_qualified_name
    | PG_MSTYPE SP? PG_EQUAL SP? ms_type=pg_data_type
    | PG_MSSPACE SP? PG_EQUAL SP? ms_space=PG_NUMBER_LITERAL
    | PG_MFINALFUNC SP? PG_EQUAL SP? mfinal_func=pg_schema_qualified_name
    | PG_MFINALFUNC_EXTRA
    | PG_MFINALFUNC_MODIFY SP? PG_EQUAL SP? (PG_READ_ONLY | PG_SHAREABLE | PG_READ_WRITE)
    | PG_MINITCOND SP? PG_EQUAL SP? minit_cond=pg_vex
    | PG_SORTOP SP? PG_EQUAL SP? pg_all_op_ref
    | PG_PARALLEL SP? PG_EQUAL SP? (PG_SAFE | PG_RESTRICTED | PG_UNSAFE)
    | PG_HYPOTHETICAL
    ;

pg_set_statement
    : PG_SET SP pg_set_action
    ;

pg_set_action
    : PG_CONSTRAINTS SP (PG_ALL | pg_names_references) SP (PG_DEFERRED | PG_IMMEDIATE)
    | PG_TRANSACTION SP pg_transaction_mode (SP? PG_COMMA SP? pg_transaction_mode)*
    | PG_TRANSACTION SP PG_SNAPSHOT SP PG_Character_String_Literal
    | PG_SESSION SP PG_CHARACTERISTICS SP PG_AS SP PG_TRANSACTION SP pg_transaction_mode (SP? PG_COMMA SP? pg_transaction_mode)*
    | ((PG_SESSION | PG_LOCAL) SP)? pg_session_local_option
    | PG_XML SP PG_OPTION SP (PG_DOCUMENT | PG_CONTENT)
    ;

pg_session_local_option
    : PG_SESSION SP PG_AUTHORIZATION SP (PG_Character_String_Literal | pg_identifier | PG_DEFAULT)
    | PG_TIME SP PG_ZONE SP (PG_Character_String_Literal | pg_signed_numerical_literal | PG_LOCAL | PG_DEFAULT)
    | (pg_identifier PG_DOT)? config_param=pg_identifier (SP PG_TO SP | SP ? PG_EQUAL SP ?) pg_set_statement_value
    | PG_ROLE SP (pg_identifier | PG_NONE)
    ;

pg_set_statement_value
    : pg_vex (SP? PG_COMMA SP? pg_vex)*
    | PG_DEFAULT
    ;

pg_create_rewrite_statement
    : (PG_OR SP PG_REPLACE SP)? PG_RULE SP name=pg_identifier SP PG_AS SP PG_ON SP event=(PG_SELECT | PG_INSERT | PG_DELETE | PG_UPDATE)
     PG_TO SP table_name=pg_schema_qualified_name SP (PG_WHERE pg_vex SP?)? PG_DO SP ((PG_ALSO | PG_INSTEAD) SP)?
     (PG_NOTHING
        | pg_rewrite_command
        | (PG_LEFT_PAREN SP? (pg_rewrite_command SP? PG_SEMI_COLON SP?)* pg_rewrite_command SP? PG_SEMI_COLON? SP? PG_RIGHT_PAREN)
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
    : (PG_CONSTRAINT SP)? PG_TRIGGER SP name=pg_identifier SP (before_true=PG_BEFORE | (PG_INSTEAD SP PG_OF) | PG_AFTER)
    (SP? ((insert_true=PG_INSERT | delete_true=PG_DELETE | truncate_true=PG_TRUNCATE)
    | update_true=PG_UPDATE (SP PG_OF SP pg_identifier_list)?) (SP PG_OR)?)+ SP
    PG_ON SP table_name=pg_schema_qualified_name SP
    (PG_FROM SP referenced_table_name=pg_schema_qualified_name SP)?
    (pg_table_deferrable SP)? (pg_table_initialy_immed SP)?
    (PG_REFERENCING SP pg_trigger_referencing (SP pg_trigger_referencing)? SP)?
    (for_each_true=PG_FOR SP (PG_EACH SP)? SP (PG_ROW | PG_STATEMENT) SP)?
    (pg_when_trigger SP)?
    PG_EXECUTE SP (PG_FUNCTION | PG_PROCEDURE) SP func_name=pg_function_call
    ;

pg_trigger_referencing
    : (PG_OLD | PG_NEW) SP PG_TABLE SP (PG_AS SP)? pg_identifier
    ;

pg_when_trigger
    : PG_WHEN SP? PG_LEFT_PAREN SP? pg_vex SP? PG_RIGHT_PAREN
    ;

pg_rule_common
    : (PG_GRANT | PG_REVOKE (SP pg_grant_option_for)?) SP
    (pg_permissions | pg_columns_permissions) SP
    PG_ON SP pg_rule_member_object SP
    (PG_TO | PG_FROM) SP pg_roles_names (SP (PG_WITH PG_GRANT PG_OPTION | pg_cascade_restrict))?
    | pg_other_rules
    ;

pg_rule_member_object
    : (PG_TABLE SP)? table_names=pg_names_references
    | PG_SEQUENCE SP pg_names_references
    | PG_DATABASE SP pg_names_references
    | PG_DOMAIN SP pg_names_references
    | PG_FOREIGN SP PG_DATA SP PG_WRAPPER SP pg_names_references
    | PG_FOREIGN SP PG_SERVER SP pg_names_references
    | (PG_FUNCTION | PG_PROCEDURE | PG_ROUTINE) SP func_name+=pg_function_parameters (SP? PG_COMMA SP? func_name+=pg_function_parameters)*
    | PG_LARGE SP PG_OBJECT SP PG_NUMBER_LITERAL (SP? PG_COMMA SP? PG_NUMBER_LITERAL)*
    | PG_LANGUAGE SP pg_names_references
    | PG_SCHEMA SP schema_names=pg_names_references
    | PG_TABLESPACE SP pg_names_references
    | PG_TYPE SP pg_names_references
    | PG_ALL SP (PG_TABLES | PG_SEQUENCES | PG_FUNCTIONS | PG_PROCEDURES | PG_ROUTINES) SP PG_IN SP PG_SCHEMA SP pg_names_references
    ;

pg_columns_permissions
    : pg_table_column_privileges (SP? PG_COMMA SP? pg_table_column_privileges)*
    ;

pg_table_column_privileges
    : pg_table_column_privilege SP? PG_LEFT_PAREN SP? pg_identifier_list SP? PG_RIGHT_PAREN
    ;

pg_permissions
    : pg_permission (SP? PG_COMMA SP? pg_permission)*
    ;

pg_permission
    : PG_ALL (SP PG_PRIVILEGES)?
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
    : PG_GRANT SP pg_names_references SP PG_TO SP pg_names_references (SP (PG_WITH PG_ADMIN PG_OPTION))?
    | PG_REVOKE SP (PG_ADMIN PG_OPTION PG_FOR SP)? pg_names_references SP PG_FROM SP pg_names_references (SP pg_cascade_restrict)?
    ;

pg_grant_to_rule
    : PG_TO SP pg_roles_names (SP PG_WITH PG_GRANT PG_OPTION)?
    ;

pg_revoke_from_cascade_restrict
    : PG_FROM SP pg_roles_names (SP pg_cascade_restrict)?
    ;

pg_roles_names
    : pg_role_name_with_group (SP? PG_COMMA SP? pg_role_name_with_group)*
    ;

pg_role_name_with_group
    : (PG_GROUP SP)? pg_user_name
    ;

pg_comment_on_statement
    : PG_COMMENT SP PG_ON SP pg_comment_member_object SP PG_IS SP (pg_character_string | PG_NULL)
    ;

pg_security_label
    : PG_SECURITY SP PG_LABEL SP (PG_FOR (pg_identifier | pg_character_string) SP)? PG_ON SP pg_label_member_object SP PG_IS SP (pg_character_string | PG_NULL)
    ;

pg_comment_member_object
    : PG_ACCESS SP PG_METHOD SP pg_identifier
    | (PG_AGGREGATE | PG_PROCEDURE | PG_FUNCTION | PG_ROUTINE) SP name=pg_schema_qualified_name SP? pg_function_args
    | PG_CAST SP? PG_LEFT_PAREN SP? source=pg_data_type SP PG_AS SP target=pg_data_type SP? PG_RIGHT_PAREN
    | PG_COLLATION SP pg_identifier
    | PG_COLUMN SP name=pg_schema_qualified_name
    | PG_CONSTRAINT SP pg_identifier SP PG_ON SP (PG_DOMAIN SP)? table_name=pg_schema_qualified_name
    | PG_CONVERSION SP name=pg_schema_qualified_name
    | PG_DATABASE SP pg_identifier
    | PG_DOMAIN SP name=pg_schema_qualified_name
    | PG_EXTENSION SP pg_identifier
    | PG_EVENT SP PG_TRIGGER SP pg_identifier
    | PG_FOREIGN SP PG_DATA SP PG_WRAPPER SP pg_identifier
    | (PG_FOREIGN SP)? PG_TABLE SP name=pg_schema_qualified_name
    | PG_INDEX SP name=pg_schema_qualified_name
    | PG_LARGE SP PG_OBJECT SP PG_NUMBER_LITERAL
    | (PG_MATERIALIZED SP)? PG_VIEW SP name=pg_schema_qualified_name
    | PG_OPERATOR SP pg_target_operator
    | PG_OPERATOR SP (PG_FAMILY| PG_CLASS) SP name=pg_schema_qualified_name SP PG_USING SP index_method=pg_identifier
    | PG_POLICY SP pg_identifier SP PG_ON SP table_name=pg_schema_qualified_name
    | (PG_PROCEDURAL SP)? PG_LANGUAGE SP name=pg_schema_qualified_name
    | PG_PUBLICATION SP pg_identifier
    | PG_ROLE SP pg_identifier
    | PG_RULE SP pg_identifier SP PG_ON SP table_name=pg_schema_qualified_name
    | PG_SCHEMA SP pg_identifier
    | PG_SEQUENCE SP name=pg_schema_qualified_name
    | PG_SERVER SP pg_identifier
    | PG_STATISTICS SP name=pg_schema_qualified_name
    | PG_SUBSCRIPTION SP pg_identifier
    | PG_TABLESPACE SP pg_identifier
    | PG_TEXT SP PG_SEARCH SP PG_CONFIGURATION SP name=pg_schema_qualified_name
    | PG_TEXT SP PG_SEARCH SP PG_DICTIONARY SP name=pg_schema_qualified_name
    | PG_TEXT SP PG_SEARCH SP PG_PARSER SP name=pg_schema_qualified_name
    | PG_TEXT SP PG_SEARCH SP PG_TEMPLATE SP name=pg_schema_qualified_name
    | PG_TRANSFORM SP PG_FOR SP name=pg_schema_qualified_name SP PG_LANGUAGE SP pg_identifier
    | PG_TRIGGER SP pg_identifier SP PG_ON SP table_name=pg_schema_qualified_name
    | PG_TYPE SP name=pg_schema_qualified_name
    ;

pg_label_member_object
    : (PG_AGGREGATE | PG_PROCEDURE | PG_FUNCTION | PG_ROUTINE) SP pg_schema_qualified_name SP? pg_function_args
    | PG_COLUMN SP pg_schema_qualified_name
    | PG_DATABASE SP pg_identifier
    | PG_DOMAIN SP pg_schema_qualified_name
    | PG_EVENT SP PG_TRIGGER SP pg_identifier
    | (PG_FOREIGN SP)? PG_TABLE SP pg_schema_qualified_name
    | PG_LARGE SP PG_OBJECT SP PG_NUMBER_LITERAL
    | (PG_MATERIALIZED SP)? PG_VIEW SP pg_schema_qualified_name
    | (PG_PROCEDURAL SP)? PG_LANGUAGE SP pg_schema_qualified_name
    | PG_PUBLICATION SP pg_identifier
    | PG_ROLE SP pg_identifier
    | PG_SCHEMA SP pg_identifier
    | PG_SEQUENCE SP pg_schema_qualified_name
    | PG_SUBSCRIPTION SP pg_identifier
    | PG_TABLESPACE SP pg_identifier
    | PG_TYPE SP pg_schema_qualified_name
    ;

/*
===============================================================================
  Function and Procedure Definition
===============================================================================
*/
pg_create_function_statement
    : (PG_OR SP PG_REPLACE SP)? (PG_FUNCTION | PG_PROCEDURE) SP pg_function_parameters SP
    (PG_RETURNS SP (rettype_data=pg_data_type | ret_table=pg_function_ret_table) SP)?
    pg_create_funct_params
    ;

pg_create_funct_params
    : (SP? pg_function_actions_common)+ (SP? pg_with_storage_parameter)?
    ;

pg_transform_for_type
    : PG_FOR SP PG_TYPE SP pg_data_type
    ;

pg_function_ret_table
    : PG_TABLE SP? PG_LEFT_PAREN SP? pg_function_column_name_type (SP? PG_COMMA SP? pg_function_column_name_type)* SP? PG_RIGHT_PAREN
    ;

pg_function_column_name_type
    : pg_identifier SP pg_data_type
    ;

pg_function_parameters
    : pg_schema_qualified_name SP? pg_function_args
    ;

pg_function_args
    : PG_LEFT_PAREN SP? ((pg_function_arguments (SP? PG_COMMA SP? pg_function_arguments)* SP?)? pg_agg_order? | PG_MULTIPLY) SP? PG_RIGHT_PAREN
    ;

pg_agg_order
    : PG_ORDER SP PG_BY SP pg_function_arguments (SP? PG_COMMA SP? pg_function_arguments)*
    ;

pg_character_string
    : PG_BeginDollarStringConstant PG_Text_between_Dollar* PG_EndDollarStringConstant
    | PG_Character_String_Literal
    ;

pg_function_arguments
    : (pg_argmode SP)? (pg_identifier_nontype SP)? pg_data_type (SP (PG_DEFAULT | PG_EQUAL) SP pg_vex)?
    ;

pg_argmode
    : PG_IN | PG_OUT | PG_INOUT | PG_VARIADIC
    ;

pg_create_sequence_statement
    : (SP (PG_TEMPORARY | PG_TEMP))? PG_SEQUENCE SP (pg_if_not_exists SP)? name=pg_schema_qualified_name (SP pg_sequence_body)*
    ;

pg_sequence_body
    : PG_AS SP type=(PG_SMALLINT | PG_INTEGER | PG_BIGINT)
    | PG_SEQUENCE SP PG_NAME SP name=pg_schema_qualified_name
    | PG_INCREMENT SP (PG_BY SP)? incr=pg_signed_numerical_literal
    | (PG_MINVALUE SP minval=pg_signed_numerical_literal | PG_NO SP PG_MINVALUE)
    | (PG_MAXVALUE SP maxval=pg_signed_numerical_literal | PG_NO SP PG_MAXVALUE)
    | PG_START SP (PG_WITH SP)? start_val=pg_signed_numerical_literal
    | PG_CACHE SP cache_val=pg_signed_numerical_literal
    | (cycle_true=PG_NO SP)? cycle_val=PG_CYCLE
    | PG_OWNED SP PG_BY SP col_name=pg_schema_qualified_name
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
    : PG_SCHEMA (SP pg_if_not_exists)? (SP name=pg_identifier)? (SP PG_AUTHORIZATION pg_user_name)?
    ;

pg_create_policy_statement
    : PG_POLICY SP pg_identifier SP PG_ON SP pg_schema_qualified_name
    (SP PG_AS SP (PG_PERMISSIVE | PG_RESTRICTIVE))?
    (SP PG_FOR SP event=(PG_ALL | PG_SELECT | PG_INSERT | PG_UPDATE | PG_DELETE))?
    (SP PG_TO SP pg_user_name (SP? PG_COMMA SP? pg_user_name)*)?
    (SP PG_USING SP using=pg_vex)? (SP PG_WITH SP PG_CHECK SP check=pg_vex)?
    ;

pg_alter_policy_statement
    : PG_POLICY SP pg_identifier SP PG_ON SP pg_schema_qualified_name SP pg_rename_to
    | PG_POLICY SP pg_identifier SP PG_ON SP pg_schema_qualified_name (SP PG_TO SP pg_user_name (SP? PG_COMMA SP? pg_user_name)*)? (SP PG_USING SP pg_vex)? (SP PG_WITH SP PG_CHECK SP pg_vex)?
    ;

pg_drop_policy_statement
    : PG_POLICY SP (pg_if_exists SP)? pg_identifier SP PG_ON SP pg_schema_qualified_name (SP pg_cascade_restrict)?
    ;

pg_create_subscription_statement
    : PG_SUBSCRIPTION SP pg_identifier SP
    PG_CONNECTION SP PG_Character_String_Literal SP
    PG_PUBLICATION SP pg_identifier_list
    (SP pg_with_storage_parameter)?
    ;

pg_alter_subscription_statement
    : PG_SUBSCRIPTION SP pg_identifier SP pg_alter_subscription_action
    ;

pg_alter_subscription_action
    : PG_CONNECTION SP pg_character_string
    | PG_SET SP PG_PUBLICATION SP pg_identifier_list (SP pg_with_storage_parameter)?
    | PG_REFRESH SP PG_PUBLICATION (SP pg_with_storage_parameter)?
    | PG_ENABLE
    | PG_DISABLE
    | PG_SET SP pg_storage_parameter
    | pg_owner_to
    | pg_rename_to
    ;

pg_create_cast_statement
    : PG_CAST SP? PG_LEFT_PAREN SP? source=pg_data_type SP PG_AS SP target=pg_data_type SP? PG_RIGHT_PAREN SP?
    (PG_WITH SP PG_FUNCTION SP func_name=pg_schema_qualified_name SP? pg_function_args | PG_WITHOUT SP PG_FUNCTION | PG_WITH SP PG_INOUT)
    (SP PG_AS SP PG_ASSIGNMENT | SP PG_AS SP PG_IMPLICIT)?
    ;

pg_drop_cast_statement
    : PG_CAST SP (pg_if_exists SP)? PG_LEFT_PAREN SP? source=pg_data_type SP PG_AS SP target=pg_data_type SP? PG_RIGHT_PAREN (SP pg_cascade_restrict)?
    ;

pg_create_operator_family_statement
    : PG_OPERATOR SP PG_FAMILY SP pg_schema_qualified_name SP PG_USING SP pg_identifier
    ;

pg_alter_operator_family_statement
    : PG_OPERATOR SP PG_FAMILY SP pg_schema_qualified_name SP PG_USING SP pg_identifier SP pg_operator_family_action
    ;

pg_operator_family_action
    : pg_rename_to
    | pg_owner_to
    | pg_set_schema
    | PG_ADD SP pg_add_operator_to_family (SP? PG_COMMA SP? pg_add_operator_to_family)*
    | PG_DROP SP pg_drop_operator_from_family (SP? PG_COMMA SP? pg_drop_operator_from_family)*
    ;

pg_add_operator_to_family
    : PG_OPERATOR SP pg_unsigned_numeric_literal SP pg_target_operator (SP PG_FOR SP PG_SEARCH | SP PG_FOR SP PG_ORDER SP PG_BY SP pg_schema_qualified_name)?
    | PG_FUNCTION SP pg_unsigned_numeric_literal SP (PG_LEFT_PAREN SP? (pg_data_type | PG_NONE) (SP? PG_COMMA SP? (pg_data_type | PG_NONE))? SP? PG_RIGHT_PAREN SP?)? pg_function_call
    ;

pg_drop_operator_from_family
    : (PG_OPERATOR | PG_FUNCTION) SP pg_unsigned_numeric_literal SP PG_LEFT_PAREN SP? (pg_data_type | PG_NONE) (SP? PG_COMMA SP? (pg_data_type | PG_NONE))? SP? PG_RIGHT_PAREN
    ;

pg_drop_operator_family_statement
    : PG_OPERATOR SP PG_FAMILY SP (pg_if_exists SP)? pg_schema_qualified_name SP PG_USING SP pg_identifier (SP pg_cascade_restrict)?
    ;

pg_create_operator_class_statement
    : PG_OPERATOR SP PG_CLASS SP pg_schema_qualified_name SP (PG_DEFAULT SP)? PG_FOR SP PG_TYPE SP pg_data_type SP
    PG_USING SP pg_identifier SP (PG_FAMILY pg_schema_qualified_name SP)? PG_AS SP
    pg_create_operator_class_option (SP? PG_COMMA SP? pg_create_operator_class_option)*
    ;

pg_create_operator_class_option
    : PG_OPERATOR SP pg_unsigned_numeric_literal SP name=pg_operator_name
        (SP? PG_LEFT_PAREN SP? (pg_data_type | PG_NONE) SP? PG_COMMA SP? (pg_data_type | PG_NONE) SP? PG_RIGHT_PAREN)?
        (SP (PG_FOR SP PG_SEARCH | PG_FOR SP PG_ORDER SP PG_BY SP pg_schema_qualified_name))?
    | PG_FUNCTION SP pg_unsigned_numeric_literal
        (SP? PG_LEFT_PAREN SP? (pg_data_type | PG_NONE) (SP? PG_COMMA SP? (pg_data_type | PG_NONE))? SP? PG_RIGHT_PAREN)?
        SP? pg_function_call
    | PG_STORAGE SP pg_data_type
    ;

pg_alter_operator_class_statement
    : PG_OPERATOR SP PG_CLASS SP pg_schema_qualified_name SP PG_USING SP pg_identifier SP (pg_rename_to | pg_owner_to | pg_set_schema)
    ;

pg_drop_operator_class_statement
    : PG_OPERATOR SP PG_CLASS SP (pg_if_exists SP)? pg_schema_qualified_name SP PG_USING SP pg_identifier (SP pg_cascade_restrict)?
    ;

pg_create_conversion_statement
    : (PG_DEFAULT SP)? PG_CONVERSION SP pg_schema_qualified_name SP PG_FOR SP PG_Character_String_Literal SP PG_TO SP PG_Character_String_Literal SP PG_FROM SP pg_schema_qualified_name
    ;

pg_alter_conversion_statement
    : PG_CONVERSION SP pg_schema_qualified_name SP (pg_rename_to | pg_owner_to | pg_set_schema)
    ;

pg_create_publication_statement
    : PG_PUBLICATION SP pg_identifier
    (SP (PG_FOR SP PG_TABLE SP pg_only_table_multiply (SP? PG_COMMA SP? pg_only_table_multiply)* | PG_FOR SP PG_ALL SP PG_TABLES))?
    (SP pg_with_storage_parameter)?
    ;

pg_alter_publication_statement
    : PG_PUBLICATION SP pg_identifier SP pg_alter_publication_action
    ;

pg_alter_publication_action
    : pg_rename_to
    | pg_owner_to
    | PG_SET SP pg_storage_parameter
    | (PG_ADD | PG_DROP | PG_SET) SP PG_TABLE SP pg_only_table_multiply (SP? PG_COMMA SP? pg_only_table_multiply)*
    ;

pg_only_table_multiply
    : (PG_ONLY SP)? pg_schema_qualified_name (SP? PG_MULTIPLY)?
    ;

pg_alter_trigger_statement
    : PG_TRIGGER SP pg_identifier SP PG_ON SP pg_schema_qualified_name SP (pg_rename_to | (PG_NO SP)? PG_DEPENDS SP PG_ON SP PG_EXTENSION SP pg_identifier)
    ;

pg_alter_rule_statement
    : PG_RULE SP pg_identifier SP PG_ON SP pg_schema_qualified_name SP pg_rename_to
    ;

pg_copy_statement
    : pg_copy_to_statement
    | pg_copy_from_statement
    ;

pg_copy_from_statement
    : PG_COPY SP pg_table_cols SP
    PG_FROM SP ((PG_PROGRAM SP)? PG_Character_String_Literal | PG_STDIN)
    (SP (PG_WITH SP)? (PG_LEFT_PAREN SP? pg_copy_option_list SP? PG_RIGHT_PAREN | pg_copy_option_list))?
    (SP PG_WHERE SP pg_vex)?
    ;

pg_copy_to_statement
    : PG_COPY SP (pg_table_cols | PG_LEFT_PAREN SP? pg_data_statement SP? PG_RIGHT_PAREN) SP
    PG_TO SP ((PG_PROGRAM SP)? PG_Character_String_Literal | PG_STDOUT)
    (SP (PG_WITH SP)? (PG_LEFT_PAREN SP? pg_copy_option_list SP? PG_RIGHT_PAREN | pg_copy_option_list))?
    ;

pg_copy_option_list
    : pg_copy_option SP (SP? PG_COMMA? SP? pg_copy_option)*
    ;

pg_copy_option
    : (PG_FORMAT SP)? (PG_TEXT | PG_CSV | PG_BINARY)
    | PG_OIDS (SP pg_truth_value)?
    | PG_FREEZE (SP pg_truth_value)?
    | PG_DELIMITER SP (PG_AS SP)? PG_Character_String_Literal
    | PG_NULL SP (PG_AS SP)? PG_Character_String_Literal
    | PG_HEADER (SP pg_truth_value)?
    | PG_QUOTE SP PG_Character_String_Literal
    | PG_ESCAPE SP PG_Character_String_Literal
    | PG_FORCE SP PG_QUOTE SP (PG_MULTIPLY | pg_identifier_list)
    | PG_FORCE_QUOTE SP (PG_MULTIPLY | PG_LEFT_PAREN SP? pg_identifier_list SP? PG_RIGHT_PAREN)
    | PG_FORCE SP PG_NOT SP PG_NULL SP pg_identifier_list
    | PG_FORCE_NOT_NULL SP PG_LEFT_PAREN SP? pg_identifier_list SP? PG_RIGHT_PAREN
    | PG_FORCE_NULL SP PG_LEFT_PAREN SP? pg_identifier_list SP? PG_RIGHT_PAREN
    | PG_ENCODING SP PG_Character_String_Literal
    ;

pg_create_view_statement
    : (PG_OR SP PG_REPLACE SP)? ((PG_TEMP | PG_TEMPORARY) SP)? (PG_RECURSIVE SP)? (PG_MATERIALIZED SP)? PG_VIEW SP
    (pg_if_not_exists SP)? name=pg_schema_qualified_name (SP column_names=pg_view_columns)?
    (SP PG_USING pg_identifier)?
    (SP PG_WITH pg_storage_parameter)?
    (SP pg_table_space)?
    SP PG_AS SP v_query=pg_select_stmt
    (SP pg_with_check_option)?
    (SP PG_WITH SP (PG_NO SP)? PG_DATA)?
    ;

pg_if_exists
    : PG_IF SP PG_EXISTS
    ;

pg_if_not_exists
    : PG_IF SP PG_NOT SP PG_EXISTS
    ;

pg_view_columns
    : PG_LEFT_PAREN SP? pg_identifier (SP? PG_COMMA SP? pg_identifier)* SP? PG_RIGHT_PAREN
    ;

pg_with_check_option
    : PG_WITH SP ((PG_CASCADED|PG_LOCAL) SP)? PG_CHECK SP PG_OPTION
    ;

pg_create_database_statement
    : PG_DATABASE SP pg_identifier ((SP PG_WITH)? (SP pg_create_database_option)+)?
    ;

pg_create_database_option
    : (PG_OWNER | PG_TEMPLATE | PG_ENCODING | PG_LOCALE | PG_LC_COLLATE | PG_LC_CTYPE | PG_TABLESPACE) SP? PG_EQUAL? SP? (pg_character_string | pg_identifier | PG_DEFAULT)
    | pg_alter_database_option
    ;

pg_alter_database_statement
    : PG_DATABASE SP pg_identifier (SP pg_alter_database_action)?
    ;

pg_alter_database_action
    : (SP PG_WITH)? (SP pg_alter_database_option)+
    | (SP PG_WITH)? PG_TABLESPACE (SP? PG_EQUAL SP?|SP) (pg_character_string | pg_identifier | PG_DEFAULT)
    | pg_rename_to
    | pg_owner_to
    | pg_set_tablespace
    | pg_set_reset_parameter
    ;

pg_alter_database_option
    : (PG_ALLOW_CONNECTIONS | PG_IS_TEMPLATE) (SP? PG_EQUAL SP?|SP) (pg_boolean_value | PG_DEFAULT)
    | PG_CONNECTION SP PG_LIMIT (SP? PG_EQUAL SP?|SP) (pg_signed_number_literal | PG_DEFAULT)
    ;

pg_create_table_statement
    : ((((PG_GLOBAL | PG_LOCAL) SP)? (PG_TEMPORARY | PG_TEMP) | PG_UNLOGGED) SP)? PG_TABLE SP (pg_if_not_exists SP)? name=pg_schema_qualified_name
    SP? pg_define_table
    (SP pg_partition_by)?
    (SP PG_USING pg_identifier)?
    (SP pg_storage_parameter_oid)?
    (SP pg_on_commit)?
    (SP pg_table_space)?
    ;

pg_create_table_as_statement
    : ((((PG_GLOBAL | PG_LOCAL) SP)? (PG_TEMPORARY | PG_TEMP) | PG_UNLOGGED) SP)? PG_TABLE SP (pg_if_not_exists SP)? name=pg_schema_qualified_name
    (SP? pg_names_in_parens)?
    (SP PG_USING pg_identifier)?
    (SP pg_storage_parameter_oid)?
    (SP pg_on_commit)?
    (SP pg_table_space)?
    SP PG_AS SP (pg_select_stmt | PG_EXECUTE SP pg_function_call)
    (SP PG_WITH SP (PG_NO SP)? PG_DATA)?
    ;

pg_create_foreign_table_statement
    : PG_FOREIGN SP PG_TABLE SP (pg_if_not_exists SP)? name=pg_schema_qualified_name SP?
    (pg_define_columns | pg_define_partition) SP
    pg_define_server
    ;

pg_define_table
    : pg_define_columns
    | pg_define_type
    | pg_define_partition
    ;

pg_define_partition
    : PG_PARTITION SP PG_OF SP parent_table=pg_schema_qualified_name
    (SP? pg_list_of_type_column_def)?
    SP pg_for_values_bound
    ;

pg_for_values_bound
    : PG_FOR SP PG_VALUES SP pg_partition_bound_spec
    | PG_DEFAULT
    ;

pg_partition_bound_spec
    : PG_IN SP PG_LEFT_PAREN SP? pg_vex (SP? PG_COMMA SP? pg_vex)* SP? PG_RIGHT_PAREN
    | PG_FROM SP pg_partition_bound_part SP PG_TO SP pg_partition_bound_part
    | PG_WITH SP PG_LEFT_PAREN SP? PG_MODULUS SP PG_NUMBER_LITERAL SP? PG_COMMA SP? PG_REMAINDER SP PG_NUMBER_LITERAL SP? PG_RIGHT_PAREN
    ;

pg_partition_bound_part
    : PG_LEFT_PAREN SP? pg_vex (SP? PG_COMMA SP? pg_vex)* SP? PG_RIGHT_PAREN
    ;

pg_define_columns
    : PG_LEFT_PAREN (SP? pg_table_column_def (SP? PG_COMMA SP? pg_table_column_def)*)? SP? PG_RIGHT_PAREN (SP PG_INHERITS SP pg_names_in_parens)?
    ;

pg_define_type
    : PG_OF SP type_name=pg_data_type (SP? pg_list_of_type_column_def)?
    ;

pg_partition_by
    : PG_PARTITION SP PG_BY SP pg_partition_method
    ;

pg_partition_method
    : (PG_RANGE | PG_LIST | PG_HASH) SP? PG_LEFT_PAREN SP? pg_partition_column (SP? PG_COMMA SP? pg_partition_column)* SP? PG_RIGHT_PAREN
    ;

pg_partition_column
    : pg_vex (SP pg_identifier)?
    ;

pg_define_server
    : PG_SERVER SP pg_identifier (SP pg_define_foreign_options)?
    ;

pg_define_foreign_options
    : PG_OPTIONS SP PG_LEFT_PAREN SP? (pg_foreign_option (SP? PG_COMMA SP? pg_foreign_option)*) SP? PG_RIGHT_PAREN
    ;

pg_foreign_option
    : ((PG_ADD | PG_SET | PG_DROP) SP)? pg_foreign_option_name SP pg_character_string?
    ;

pg_foreign_option_name
    : pg_identifier
    | PG_USER
    ;

pg_list_of_type_column_def
    : PG_LEFT_PAREN SP? (pg_table_of_type_column_def (SP? PG_COMMA SP? pg_table_of_type_column_def)*) SP? PG_RIGHT_PAREN
    ;

pg_table_column_def
    : pg_table_column_definition
    | tabl_constraint=pg_constraint_common
    | PG_LIKE SP pg_schema_qualified_name (SP pg_like_option)*
    ;

pg_table_of_type_column_def
    : pg_identifier (SP PG_WITH SP PG_OPTIONS)? (SP pg_constraint_common)*
    | tabl_constraint=pg_constraint_common
    ;

pg_table_column_definition
    : pg_identifier SP pg_data_type (SP pg_define_foreign_options)? (SP pg_collate_identifier)? (SP pg_constraint_common)*
    ;

pg_like_option
    : (PG_INCLUDING | PG_EXCLUDING) SP (PG_COMMENTS | PG_CONSTRAINTS | PG_DEFAULTS | PG_GENERATED | PG_IDENTITY | PG_INDEXES | PG_STORAGE | PG_ALL)
    ;
/** NULL, PG_DEFAULT - PG_column constraint
* EXCLUDE, FOREIGN PG_KEY - table_constraint
*/
pg_constraint_common
    : (PG_CONSTRAINT SP pg_identifier SP)? pg_constr_body (SP pg_table_deferrable)? (SP pg_table_initialy_immed)?
    ;

pg_constr_body
    : PG_EXCLUDE (SP PG_USING index_method=pg_identifier)?
            SP? PG_LEFT_PAREN SP? pg_index_column SP PG_WITH SP pg_all_op (SP? PG_COMMA SP? pg_index_column SP PG_WITH SP pg_all_op)* SP? PG_RIGHT_PAREN SP
            pg_index_parameters (SP PG_where=PG_WHERE SP exp=pg_vex)?
    | (PG_FOREIGN SP PG_KEY SP? pg_names_in_parens SP?)? PG_REFERENCES SP pg_schema_qualified_name (SP? ref=pg_names_in_parens SP?)?
        (PG_MATCH SP (PG_FULL | PG_PARTIAL | PG_SIMPLE) | PG_ON SP (PG_DELETE | PG_UPDATE) (SP pg_action))*
    | PG_CHECK SP? PG_LEFT_PAREN SP? expression=pg_vex SP? PG_RIGHT_PAREN (SP PG_NO SP PG_INHERIT)?
    | (PG_NOT SP)? PG_NULL
    | (PG_UNIQUE | PG_PRIMARY SP PG_KEY) (SP? col=pg_names_in_parens)? SP pg_index_parameters
    | PG_DEFAULT SP default_expr=pg_vex
    | pg_identity_body
    | PG_GENERATED SP PG_ALWAYS SP PG_AS SP PG_LEFT_PAREN SP? pg_vex SP? PG_RIGHT_PAREN SP PG_STORED
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
    : (pg_including_index)? (SP? pg_with_storage_parameter)? (SP? PG_USING SP PG_INDEX SP (pg_table_space | pg_schema_qualified_name))?
    ;

pg_names_in_parens
    : PG_LEFT_PAREN SP? pg_names_references SP? PG_RIGHT_PAREN
    ;

pg_names_references
    : pg_schema_qualified_name (SP? PG_COMMA SP? pg_schema_qualified_name)*
    ;

pg_storage_parameter
    : PG_LEFT_PAREN SP? pg_storage_parameter_option (SP? PG_COMMA SP? pg_storage_parameter_option)* SP? PG_RIGHT_PAREN
    ;

pg_storage_parameter_option
    : pg_storage_parameter_name (SP? PG_EQUAL SP? pg_vex)?
    ;

pg_storage_parameter_name
    : pg_col_label (PG_DOT pg_col_label)?
    ;

pg_with_storage_parameter
    : PG_WITH SP pg_storage_parameter
    ;

pg_storage_parameter_oid
    : pg_with_storage_parameter | ((PG_WITH|PG_WITHOUT) SP PG_OIDS)
    ;

pg_on_commit
    : PG_ON SP PG_COMMIT SP (PG_PRESERVE SP PG_ROWS | PG_DELETE SP PG_ROWS | PG_DROP)
    ;

pg_table_space
    : PG_TABLESPACE SP pg_identifier
    ;

pg_set_tablespace
    : PG_SET PG_TABLESPACE SP pg_identifier (SP PG_NOWAIT)?
    ;

pg_action
    : pg_cascade_restrict
    | PG_SET SP (PG_NULL | PG_DEFAULT)
    | PG_NO SP PG_ACTION
    ;

pg_owner_to
    : PG_OWNER SP PG_TO SP (name=pg_identifier | PG_CURRENT_USER | PG_SESSION_USER)
    ;

pg_rename_to
    : PG_RENAME SP PG_TO SP name=pg_identifier
    ;

pg_set_schema
    : PG_SET SP PG_SCHEMA SP pg_identifier
    ;

pg_table_column_privilege
    : PG_SELECT | PG_INSERT | PG_UPDATE | PG_DELETE | PG_TRUNCATE | PG_REFERENCES | PG_TRIGGER | PG_ALL (SP PG_PRIVILEGES)?
    ;

pg_usage_select_update
    : PG_USAGE | PG_SELECT | PG_UPDATE
    ;

pg_partition_by_columns
    : PG_PARTITION SP PG_BY SP pg_vex (SP? PG_COMMA SP? pg_vex)*
    ;

pg_cascade_restrict
    : PG_CASCADE | PG_RESTRICT
    ;

pg_collate_identifier
    : PG_COLLATE SP collation=pg_schema_qualified_name
    ;

pg_indirection_var
    : (pg_identifier | pg_dollar_number) (SP? pg_indirection_list)?
    ;

pg_dollar_number
    : PG_DOLLAR_NUMBER
    ;

/* todo: check indrection */
pg_indirection_list
    : (SP? pg_indirection)+
    | (SP? pg_indirection)* SP? PG_DOT SP? PG_MULTIPLY
    ;

pg_indirection
    : PG_DOT pg_col_label
    | PG_LEFT_BRACKET SP? pg_vex SP? PG_RIGHT_BRACKET
    | PG_LEFT_BRACKET SP? pg_vex? SP? PG_COLON SP? pg_vex? SP? PG_RIGHT_BRACKET
    ;

/*
===============================================================================
  11.21 <data types>
===============================================================================
*/

pg_drop_database_statement
    : PG_DATABASE SP (pg_if_exists SP)? pg_identifier (SP? (PG_WITH SP?)? PG_LEFT_PAREN SP? PG_FORCE SP? PG_RIGHT_PAREN)?
    ;

pg_drop_function_statement
    : (PG_FUNCTION | PG_PROCEDURE | PG_AGGREGATE) SP (pg_if_exists SP)? name=pg_schema_qualified_name (SP pg_function_args)? (SP pg_cascade_restrict)?
    ;

pg_drop_trigger_statement
    : PG_TRIGGER SP (pg_if_exists SP)? name=pg_identifier SP PG_ON SP table_name=pg_schema_qualified_name (SP pg_cascade_restrict)?
    ;

pg_drop_rule_statement
    : PG_RULE SP (pg_if_exists SP)? name=pg_identifier SP PG_ON SP pg_schema_qualified_name (SP pg_cascade_restrict)?
    ;

pg_drop_statements
    : (PG_ACCESS SP PG_METHOD
    | PG_COLLATION
    | PG_CONVERSION
    | PG_DOMAIN
    | PG_EVENT SP PG_TRIGGER
    | PG_EXTENSION
    | PG_GROUP
    | (SP PG_FOREIGN)? PG_TABLE
    | PG_FOREIGN SP PG_DATA SP PG_WRAPPER
    | PG_INDEX (SP PG_CONCURRENTLY)?
    | (PG_MATERIALIZED SP)? PG_VIEW
    | (PG_PROCEDURAL SP)? PG_LANGUAGE
    | PG_PUBLICATION
    | PG_ROLE
    | PG_SCHEMA
    | PG_SEQUENCE
    | PG_SERVER
    | PG_STATISTICS
    | PG_SUBSCRIPTION
    | PG_TABLESPACE
    | PG_TYPE
    | PG_TEXT SP PG_SEARCH SP (PG_CONFIGURATION | PG_DICTIONARY | PG_PARSER | PG_TEMPLATE)
    | PG_USER
    | AG_GRAPH
    | AG_ELABEL
    | AG_VLABEL) SP pg_if_exist_names_restrict_cascade
    ;

pg_if_exist_names_restrict_cascade
    : (pg_if_exists SP)? pg_names_references (SP pg_cascade_restrict)?
    ;

ag_create_graph_statement
    : AG_GRAPH SP (pg_if_not_exists SP)? name=pg_identifier (SP PG_AUTHORIZATION SP pg_user_name)?
    ;

ag_alter_graph_statement
    : AG_GRAPH SP pg_identifier SP (pg_rename_to | pg_owner_to)
    ;

ag_define_table
    : (PG_INHERITS SP pg_names_in_parens)
    | pg_define_type
    | pg_define_partition
    ;

ag_create_label_statement
    : ((((PG_GLOBAL | PG_LOCAL) SP)? (PG_TEMPORARY | PG_TEMP) | PG_UNLOGGED) SP)? (AG_VLABEL | AG_ELABEL) SP (pg_if_not_exists SP)? name=pg_schema_qualified_name
    (SP ag_define_table)?
    (SP pg_partition_by)?
    (SP PG_USING SP pg_identifier)?
    (SP pg_storage_parameter_oid)?
    (SP pg_on_commit)?
    (SP pg_table_space)?
    ;

ag_alter_label_statement
    : (AG_VLABEL | AG_ELABEL) SP (pg_if_exists SP)? (PG_ONLY SP)? name=pg_schema_qualified_name (SP? PG_MULTIPLY)? SP? (
        pg_table_action (SP? PG_COMMA SP? pg_table_action)*
        | PG_RENAME SP (PG_COLUMN SP)? pg_identifier SP PG_TO SP pg_identifier
        | pg_set_schema
        | pg_rename_to
        | PG_RENAME SP PG_CONSTRAINT SP pg_identifier SP PG_TO SP pg_identifier
        | PG_ATTACH SP PG_PARTITION SP child=pg_schema_qualified_name SP pg_for_values_bound
        | PG_DETACH SP PG_PARTITION SP child=pg_schema_qualified_name
        | PG_DISABLE SP PG_INDEX)
    ;
ag_cypher_statement
    : cypherQuery;
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
    : pg_data_type (SP? PG_COMMA SP? pg_data_type)*
    ;

pg_data_type
    : (PG_SETOF SP)? pg_predefined_type (SP? (PG_ARRAY pg_array_type? | (SP? pg_array_type)+))?
    ;

pg_array_type
    : PG_LEFT_BRACKET SP? PG_NUMBER_LITERAL? SP? PG_RIGHT_BRACKET
    ;

pg_predefined_type
    : PG_BIGINT
    | PG_BIT (SP PG_VARYING)? (SP pg_type_length)?
    | PG_BOOLEAN
    | PG_DEC (SP pg_precision_param)?
    | PG_DECIMAL (SP pg_precision_param)?
    | PG_DOUBLE SP PG_PRECISION
    | PG_FLOAT (SP pg_precision_param)?
    | PG_INT
    | PG_INTEGER
    | PG_INTERVAL (SP pg_interval_field)? (SP pg_type_length)?
    | (PG_NATIONAL SP)? (PG_CHARACTER | PG_CHAR) (SP PG_VARYING)? (SP pg_type_length)?
    | PG_NCHAR (SP PG_VARYING)? (SP pg_type_length)?
    | PG_NUMERIC (SP pg_precision_param)?
    | PG_REAL
    | PG_SMALLINT
    | PG_TIME (SP pg_type_length)? (SP (PG_WITH | PG_WITHOUT) SP PG_TIME SP PG_ZONE)?
    | PG_TIMESTAMP (SP pg_type_length)? (SP (PG_WITH | PG_WITHOUT) SP PG_TIME SP PG_ZONE)?
    | PG_VARCHAR (SP pg_type_length)?
    | pg_schema_qualified_name_nontype (SP? PG_LEFT_PAREN SP? pg_vex (SP? PG_COMMA SP? pg_vex)* SP? PG_RIGHT_PAREN)?
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
    : PG_LEFT_PAREN SP? PG_NUMBER_LITERAL SP? PG_RIGHT_PAREN
    ;

pg_precision_param
    : PG_LEFT_PAREN SP? precision=PG_NUMBER_LITERAL (SP? PG_COMMA SP? scale=PG_NUMBER_LITERAL)? SP? PG_RIGHT_PAREN
    ;

/*
===============================================================================
  6.25 <value expression>
===============================================================================
*/

pg_vex
  : pg_vex SP? PG_CAST_EXPRESSION SP? pg_data_type
  | PG_LEFT_PAREN SP? pg_vex SP? PG_RIGHT_PAREN SP? pg_indirection_list?
  | PG_LEFT_PAREN SP? pg_vex SP? (SP? PG_COMMA SP? pg_vex)+ SP? PG_RIGHT_PAREN
  | pg_vex SP pg_collate_identifier
  | <assoc=right>SP? (PG_PLUS | PG_MINUS) SP? pg_vex
  | pg_vex SP PG_AT SP PG_TIME SP PG_ZONE SP pg_vex
  | pg_vex SP? PG_EXP SP? pg_vex
  | pg_vex SP? (PG_MULTIPLY | PG_DIVIDE | PG_MODULAR) SP? pg_vex
  | pg_vex SP? (PG_PLUS | PG_MINUS) SP? pg_vex
  // TODO a lot of ambiguities between 3 next alternatives
  | pg_vex SP? pg_op SP? pg_vex
  | pg_op SP? pg_vex
  | pg_vex SP? pg_op
  | pg_vex SP (PG_NOT SP)? PG_IN SP PG_LEFT_PAREN SP? (pg_select_stmt_no_parens | pg_vex (SP? PG_COMMA SP? pg_vex)*) SP? PG_RIGHT_PAREN
  | pg_vex SP (PG_NOT SP)? PG_BETWEEN SP ((PG_ASYMMETRIC | PG_SYMMETRIC) SP)? pg_vex_b SP PG_AND SP pg_vex
  | pg_vex SP (PG_NOT SP)? (PG_LIKE | PG_ILIKE | PG_SIMILAR SP PG_TO) SP pg_vex
  | pg_vex SP (PG_NOT SP)? (PG_LIKE | PG_ILIKE | PG_SIMILAR SP PG_TO) SP pg_vex SP PG_ESCAPE SP pg_vex
  | pg_vex SP? (PG_LTH | PG_GTH | PG_LEQ | PG_GEQ | PG_EQUAL | PG_NOT_EQUAL) SP? pg_vex
  | pg_vex PG_IS SP (PG_NOT SP)? (pg_truth_value | PG_NULL)
  | pg_vex PG_IS SP (PG_NOT SP)? PG_DISTINCT SP PG_FROM SP pg_vex
  | pg_vex PG_IS SP (PG_NOT SP)? PG_DOCUMENT
  | pg_vex PG_IS SP (PG_NOT SP)? PG_UNKNOWN
  | pg_vex PG_IS SP (PG_NOT SP)? PG_OF SP PG_LEFT_PAREN SP? pg_type_list SP? PG_RIGHT_PAREN
  | pg_vex SP PG_ISNULL
  | pg_vex SP PG_NOTNULL
  | <assoc=right> SP PG_NOT SP pg_vex
  | pg_vex SP PG_AND SP pg_vex
  | pg_vex SP PG_OR SP pg_vex
  | pg_value_expression_primary
  ;

// PG_partial PG_copy of vex
// resolves (vex BETWEEN vex AND vex) vs. (vex AND vex) ambiguity
// vex PG_references that are not at alternative edge are referencing the full rule
// see postgres' b_expr (src/backend/parser/gram.y)
pg_vex_b
  : pg_vex_b SP? PG_CAST_EXPRESSION SP? pg_data_type
  | PG_LEFT_PAREN SP? pg_vex SP? PG_RIGHT_PAREN (SP pg_indirection_list)?
  | PG_LEFT_PAREN SP? pg_vex (SP? PG_COMMA SP? pg_vex)+ SP? PG_RIGHT_PAREN
  | <assoc=right> SP? (PG_PLUS | PG_MINUS) SP? pg_vex_b
  | pg_vex_b SP? PG_EXP SP? pg_vex_b
  | pg_vex_b SP? (PG_MULTIPLY | PG_DIVIDE | PG_MODULAR) SP? pg_vex_b
  | pg_vex_b SP? (PG_PLUS | PG_MINUS) SP? pg_vex_b
  | pg_vex_b SP? pg_op SP? pg_vex_b
  | pg_op SP? pg_vex_b
  | pg_vex_b SP? pg_op
  | pg_vex_b SP? (PG_LTH | PG_GTH | PG_LEQ | PG_GEQ | PG_EQUAL | PG_NOT_EQUAL) SP? pg_vex_b
  | pg_vex_b SP PG_IS SP (PG_NOT SP)? PG_DISTINCT SP PG_FROM SP pg_vex_b
  | pg_vex_b SP PG_IS SP (PG_NOT SP)? PG_DOCUMENT
  | pg_vex_b SP PG_IS SP (PG_NOT SP)? PG_UNKNOWN
  | pg_vex_b SP PG_IS SP (PG_NOT SP)? PG_OF SP PG_LEFT_PAREN SP? pg_type_list SP? PG_RIGHT_PAREN
  | pg_value_expression_primary
  ;

pg_op
  : pg_op_chars
  | PG_OPERATOR SP? PG_LEFT_PAREN SP? pg_identifier PG_DOT pg_all_simple_op SP? PG_RIGHT_PAREN
  ;

pg_all_op_ref
  : pg_all_simple_op
  | PG_OPERATOR SP? PG_LEFT_PAREN SP? pg_identifier PG_DOT pg_all_simple_op SP? PG_RIGHT_PAREN
  ;

pg_datetime_overlaps
  : PG_LEFT_PAREN SP? pg_vex SP? PG_COMMA SP? pg_vex SP? PG_RIGHT_PAREN SP PG_OVERLAPS SP PG_LEFT_PAREN SP? pg_vex SP? PG_COMMA SP? pg_vex SP? PG_RIGHT_PAREN
  ;

pg_value_expression_primary
  : pg_unsigned_value_specification
  | PG_LEFT_PAREN SP? pg_select_stmt_no_parens SP? PG_RIGHT_PAREN (SP pg_indirection_list)?
  | pg_case_expression
  | PG_NULL
  | PG_MULTIPLY
  // technically incorrect since ANY cannot be PG_value expression
  // but fixing this would require to write a vex PG_rule duplicating all operators
  // PG_like vex (op|op|op|...) comparison_mod
  | pg_comparison_mod
  | PG_EXISTS SP pg_table_subquery
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
  : PG_CASE SP (pg_vex SP)? (SP? PG_WHEN SP pg_vex SP PG_THEN r+=pg_vex)+ (SP PG_ELSE SP r+=pg_vex)? SP PG_END
  ;

pg_cast_specification
  : (PG_CAST | PG_TREAT) SP? PG_LEFT_PAREN SP? pg_vex SP PG_AS SP pg_data_type SP? PG_RIGHT_PAREN
  ;

// using data_type for function name because keyword-named functions
// use the same PG_category of keywords as keyword-named types
pg_function_call
    : pg_schema_qualified_name_nontype SP? PG_LEFT_PAREN SP? ((pg_set_qualifier SP)? pg_vex_or_named_notation SP (SP? PG_COMMA SP? pg_vex_or_named_notation)* SP? pg_orderby_clause?)? SP? PG_RIGHT_PAREN
        (SP? PG_WITHIN SP PG_GROUP SP? PG_LEFT_PAREN SP? pg_orderby_clause SP? PG_RIGHT_PAREN)?
        (SP? pg_filter_clause)? (SP? PG_OVER SP (pg_identifier | pg_window_definition))?
    | pg_function_construct
    | pg_extract_function
    | pg_system_function
    | pg_date_time_function
    | pg_string_value_function
    | pg_xml_function
    ;

pg_vex_or_named_notation
    : (PG_VARIADIC SP)? (argname=pg_identifier SP? pg_pointer SP?)? pg_vex
    ;

pg_pointer
    : PG_EQUAL_GTH | PG_COLON_EQUAL
    ;

pg_function_construct
    : (PG_COALESCE | PG_GREATEST | PG_GROUPING | PG_LEAST | PG_NULLIF | PG_XMLCONCAT) SP? PG_LEFT_PAREN SP? pg_vex (SP? PG_COMMA SP? pg_vex)* SP? PG_RIGHT_PAREN
    | PG_ROW SP? PG_LEFT_PAREN SP? (pg_vex (SP? PG_COMMA SP? pg_vex)* SP?)? PG_RIGHT_PAREN
    ;

pg_extract_function
    : PG_EXTRACT SP? PG_LEFT_PAREN SP? (pg_identifier | pg_character_string) SP PG_FROM SP pg_vex SP? PG_RIGHT_PAREN
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
    | PG_CURRENT_TIME (SP pg_type_length)?
    | PG_CURRENT_TIMESTAMP (SP pg_type_length)?
    | PG_LOCALTIME (SP pg_type_length)?
    | PG_LOCALTIMESTAMP (SP pg_type_length)?
    ;

pg_string_value_function
    : PG_TRIM SP? PG_LEFT_PAREN SP? ((PG_LEADING | PG_TRAILING | PG_BOTH) SP)? (chars=pg_vex SP PG_FROM SP str=pg_vex | (PG_FROM SP)? str=pg_vex SP (SP? PG_COMMA SP? chars=pg_vex)?) SP? PG_RIGHT_PAREN
    | PG_SUBSTRING SP? PG_LEFT_PAREN SP? pg_vex (SP? PG_COMMA SP? pg_vex)* SP? (PG_FROM SP pg_vex SP?)? (PG_FOR SP pg_vex SP?)? PG_RIGHT_PAREN
    | PG_POSITION SP? PG_LEFT_PAREN SP? pg_vex_b SP PG_IN SP pg_vex SP? PG_RIGHT_PAREN
    | PG_OVERLAY SP? PG_LEFT_PAREN SP? pg_vex SP PG_PLACING SP pg_vex SP PG_FROM SP pg_vex SP? (PG_FOR SP pg_vex)? SP? PG_RIGHT_PAREN
    | PG_COLLATION SP PG_FOR SP? PG_LEFT_PAREN SP? pg_vex SP? PG_RIGHT_PAREN
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
    : PG_SELECT SP
        (pg_set_qualifier (PG_ON PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN)?)?
        pg_select_list? SP? pg_into_table? SP?
        (PG_FROM SP pg_from_item (PG_COMMA pg_from_item)*)?
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
    : pg_identifier SP? (SP? PG_COMMA SP? pg_identifier)*
    ;

pg_anonymous_block
    : PG_DO SP (PG_LANGUAGE SP (pg_identifier | pg_character_string) SP)? pg_character_string
    | PG_DO SP pg_character_string SP PG_LANGUAGE SP (pg_identifier | pg_character_string)
    ;

// plpgsql rules
pg_function_block
    : (pg_start_label SP)? (pg_declarations SP)?
    PG_BEGIN SP pg_function_statements SP (pg_exception_statement SP)?
    PG_END (SP end_label=pg_identifier)?
    ;

pg_start_label
    : PG_LESS_LESS SP? pg_col_label SP? PG_GREATER_GREATER
    ;

pg_declarations
    : PG_DECLARE (SP pg_declaration)*
    ;

pg_declaration
    : (PG_DECLARE SP)* pg_identifier SP pg_type_declaration SP PG_SEMI_COLON
    ;

pg_type_declaration
    : (PG_CONSTANT SP)? pg_data_type_dec (SP pg_collate_identifier)? (SP PG_NOT SP PG_NULL)? (SP? (PG_DEFAULT | PG_COLON_EQUAL | PG_EQUAL) SP? pg_vex)?
    | PG_ALIAS SP PG_FOR SP (pg_identifier | PG_DOLLAR_NUMBER)
    | ((PG_NO SP)? PG_SCROLL SP)? PG_CURSOR (SP? PG_LEFT_PAREN SP? pg_arguments_list SP? PG_RIGHT_PAREN SP?)? SP (PG_FOR | PG_IS) SP pg_select_stmt
    ;

pg_arguments_list
    : pg_identifier SP pg_data_type (SP? PG_COMMA SP? pg_identifier SP pg_data_type)*
    ;

pg_data_type_dec
    : pg_data_type
    | pg_schema_qualified_name SP PG_MODULAR SP PG_TYPE
    | pg_schema_qualified_name_nontype SP PG_MODULAR SP PG_ROWTYPE
    ;

pg_exception_statement
    : PG_EXCEPTION (SP PG_WHEN SP pg_vex SP PG_THEN SP pg_function_statements)+
    ;

pg_function_statements
    : (SP? pg_function_statement SP? PG_SEMI_COLON)*
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
    | PG_PERFORM SP pg_perform_stmt
    | PG_GET SP ((PG_CURRENT | PG_STACKED) SP)? PG_DIAGNOSTICS SP pg_diagnostic_option (SP? PG_COMMA SP? pg_diagnostic_option)*
    | PG_NULL
    ;

pg_var
    : (pg_schema_qualified_name | PG_DOLLAR_NUMBER) (SP? PG_LEFT_BRACKET SP? pg_vex SP? PG_RIGHT_BRACKET)*
    ;

pg_diagnostic_option
    : pg_var SP? (PG_COLON_EQUAL | PG_EQUAL) SP? pg_identifier
    ;

// keep this in sync with select_primary (except intended differences)
pg_perform_stmt
    : (pg_set_qualifier (SP PG_ON SP? PG_LEFT_PAREN SP? pg_vex (SP? PG_COMMA SP? pg_vex)* SP? PG_RIGHT_PAREN)? SP?)?
    pg_select_list
    (PG_FROM pg_from_item (PG_COMMA pg_from_item)*)?
    (PG_WHERE pg_vex)?
    pg_groupby_clause?
    (PG_HAVING pg_vex)?
    (PG_WINDOW pg_identifier PG_AS pg_window_definition (PG_COMMA pg_identifier PG_AS pg_window_definition)*)?
    (SP (PG_INTERSECT | PG_UNION | PG_EXCEPT) (SP pg_set_qualifier)? SP pg_select_ops)?
    (SP pg_after_ops)*
    ;

pg_assign_stmt
    : pg_var SP? (PG_COLON_EQUAL | PG_EQUAL) SP? (pg_select_stmt_no_parens | pg_perform_stmt)
    ;

pg_execute_stmt
    : PG_EXECUTE SP pg_vex (SP pg_using_vex)?
    ;

pg_control_statement
    : pg_return_stmt
    | PG_CALL SP pg_function_call
    | pg_if_statement
    | pg_case_statement
    | pg_loop_statement
    ;

pg_cursor_statement
    : PG_OPEN SP pg_var SP ((PG_NO SP)? PG_SCROLL SP)? PG_FOR SP pg_plpgsql_query
    | PG_OPEN SP pg_var (SP? PG_LEFT_PAREN SP? pg_option (SP? PG_COMMA SP? pg_option)* SP? PG_RIGHT_PAREN)?
    | PG_FETCH SP (pg_fetch_move_direction SP)? ((PG_FROM | PG_IN) SP)? pg_var
    | PG_MOVE SP (pg_fetch_move_direction SP)? ((PG_FROM | PG_IN) SP)? pg_var
    | PG_CLOSE SP pg_var
    ;

pg_option
    : (pg_identifier SP? PG_COLON_EQUAL SP?)? pg_vex
    ;

pg_transaction_statement
    : (PG_COMMIT | PG_ROLLBACK) (SP PG_AND SP (PG_NO SP)? PG_CHAIN)?
    | pg_lock_table
    ;

pg_message_statement
    : PG_RAISE (SP pg_log_level)? (SP pg_character_string (SP? PG_COMMA SP? pg_vex)*)? (SP pg_raise_using)?
    | PG_RAISE (SP pg_log_level)? SP pg_identifier (SP pg_raise_using)?
    | PG_RAISE (SP pg_log_level)? SP PG_SQLSTATE pg_character_string (SP pg_raise_using)?
    | PG_ASSERT SP pg_vex (SP? PG_COMMA SP? pg_vex)?
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
    : PG_USING SP pg_raise_param SP? PG_EQUAL SP? pg_vex (SP? PG_COMMA SP? pg_raise_param SP? PG_EQUAL SP? pg_vex)*
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
    : PG_RETURN (SP pg_perform_stmt)?
    | PG_RETURN SP PG_NEXT SP pg_vex
    | PG_RETURN SP PG_QUERY SP pg_plpgsql_query
    ;

pg_loop_statement
    : (pg_start_label SP)? (pg_loop_start SP)? PG_LOOP SP pg_function_statements SP PG_END SP PG_LOOP (SP pg_identifier)?
    | (PG_EXIT | PG_CONTINUE) (SP pg_col_label)? (SP PG_WHEN pg_vex)?
    ;

pg_loop_start
    : PG_WHILE SP pg_vex
    | PG_FOR SP alias=pg_identifier SP PG_IN SP (PG_REVERSE SP)? pg_vex SP? PG_DOUBLE_DOT SP? pg_vex (SP PG_BY pg_vex)?
    | PG_FOR SP pg_identifier_list SP PG_IN SP pg_plpgsql_query
    | PG_FOR SP cursor=pg_identifier SP PG_IN SP pg_identifier (SP? PG_LEFT_PAREN SP? pg_option (SP? PG_COMMA SP? pg_option)* SP? PG_RIGHT_PAREN)? // cursor loop
    | PG_FOREACH SP pg_identifier_list SP (PG_SLICE SP PG_NUMBER_LITERAL SP)? PG_IN SP PG_ARRAY SP? pg_vex
    ;

pg_using_vex
    : PG_USING SP pg_vex (SP? PG_COMMA SP? pg_vex)*
    ;

pg_if_statement
    : PG_IF SP pg_vex SP PG_THEN SP pg_function_statements (SP? (PG_ELSIF | PG_ELSEIF) pg_vex PG_THEN pg_function_statements)* (SP? PG_ELSE pg_function_statements)? SP PG_END SP PG_IF
    ;

// plpgsql case
pg_case_statement
    : PG_CASE SP (pg_vex)? (SP? PG_WHEN SP pg_vex (SP? PG_COMMA SP? pg_vex)* SP PG_THEN SP pg_function_statements)+ (SP? PG_ELSE SP pg_function_statements)? SP PG_END SP PG_CASE
    ;

pg_plpgsql_query
    : pg_data_statement
    | pg_execute_stmt
    | pg_show_statement
    | pg_explain_statement
    ;


/* CYPHER */
cypherQuery : statement ;

statement : query;

query : regularQuery
      | loadCSVQuery
      ;

regularQuery : singleQuery ( SP? union )* ;

singleQuery : clause ( SP? clause )* ;

loadCSVQuery : loadCSVClause ( SP? clause )* ;

union : ( PG_UNION PG_ALL SP? singleQuery )
      | ( PG_UNION SP? singleQuery )
      ;

clause : loadCSVClause
       | matchClause
       | unwindClause
       | mergeClause
       | createClause
       | createUniqueClause
       | setClause
       | deleteClause
       | removeClause
       | withClause
       | returnClause
       ;

loadCSVClause : PG_LOAD PG_CSV ( PG_WITH HEADERS )? PG_FROM cypherExpression PG_AS variable ( FIELDTERMINATOR stringLiteral )? ;

matchClause : ( OPTIONAL )? PG_MATCH SP? pattern ( SP? where )? ;

unwindClause : UNWIND SP? cypherExpression PG_AS variable ;

mergeClause : PG_MERGE SP? patternPart ( SP? mergeAction )* ;

mergeAction : ( PG_ON PG_MATCH setClause )
            | ( PG_ON PG_CREATE setClause )
            ;

createClause : PG_CREATE SP? pattern ;

createUniqueClause : PG_CREATE PG_UNIQUE SP? pattern ;

setClause : PG_SET SP? setItem ( SP? PG_COMMA SP? setItem )* ;

setItem : ( propertyExpression SP? PG_EQUAL SP? cypherExpression )
        | ( variable SP? PG_EQUAL SP? cypherExpression )
        | ( variable SP? PLUS_EQUAL SP? cypherExpression )
        | ( variable SP? nodeLabels )
        ;

deleteClause : ( PG_DETACH )? PG_DELETE SP? cypherExpression ( SP? PG_COMMA SP? cypherExpression )* ;

removeClause : REMOVE removeItem ( SP? PG_COMMA SP? removeItem )* ;

removeItem : ( variable nodeLabels )
           | propertyExpression
           ;

withClause : PG_WITH ( SP? PG_DISTINCT )? returnBody ( SP? where )? ;

returnClause : PG_RETURN ( SP? PG_DISTINCT )? SP? returnBody ;

returnBody : returnItems ( order )? ( skip )? ( limit )? ;

func : procedureInvocation SP? procedureResults? ;

returnItems : ( PG_MULTIPLY ( SP? PG_COMMA SP? returnItem )* )
            | ( returnItem ( SP? PG_COMMA SP? returnItem )* )
			| func
            ;

returnItem : ( cypherExpression PG_AS variable )
           | cypherExpression
           ;

procedureInvocation : procedureInvocationBody SP? procedureArguments? ;

procedureInvocationBody : namespace procedureName ;

procedureArguments : cypherLeftParen SP? cypherExpression? ( SP? PG_COMMA SP? cypherExpression )* SP? cypherRightParen ;

procedureResults : YIELD procedureResult ( SP? PG_COMMA SP? procedureResult )* (where)?;

procedureResult : aliasedProcedureResult
                | simpleProcedureResult ;

aliasedProcedureResult : procedureOutput PG_AS variable ;

simpleProcedureResult : procedureOutput ;

procedureOutput : symbolicName ;

order : PG_ORDER PG_BY sortItem ( SP? PG_COMMA SP? sortItem )* ;

skip : PG_SKIP_ cypherExpression ;

limit : PG_LIMIT cypherExpression ;

sortItem : cypherExpression ( SP? ( ASCENDING | PG_ASC | DESCENDING | PG_DESC ) SP? )? ;

where : PG_WHERE cypherExpression ;

pattern : patternPart ( SP? PG_COMMA SP? patternPart )* ;

patternPart : ( variable SP? PG_EQUAL SP? anonymousPatternPart )
            | anonymousPatternPart
            ;

anonymousPatternPart : shortestPathPatternFunction
                     | patternElement
                     ;

patternElement : ( nodePattern ( SP? patternElementChain )* )
               | ( cypherLeftParen patternElement cypherRightParen )
               ;

nodePattern : cypherLeftParen SP? ( variable SP? )? ( nodeLabels SP? )? ( properties SP? )? cypherRightParen ;

patternElementChain : relationshipPattern SP? nodePattern ;

relationshipPattern : relationshipPatternStart SP? relationshipDetail? SP? relationshipPatternEnd;

relationshipPatternStart : ( leftArrowHead SP? dash )
                         | ( dash )
                         ;

relationshipPatternEnd : ( dash SP? rightArrowHead )
                       | ( dash )
                       ;

relationshipDetail : PG_LEFT_BRACKET SP? ( variable SP? )? ( relationshipTypes SP? )? rangeLiteral? ( properties SP? )? PG_RIGHT_BRACKET ;

properties : mapLiteral
           | parameter
           ;

relationshipTypes : relationshipType ( SP? CHAR_OR relationshipTypeOptionalColon )* ;

relationshipType : ':' relTypeName ;

relationshipTypeOptionalColon : ':'? relTypeName ;

nodeLabels : nodeLabel ( SP? nodeLabel )* ;

nodeLabel : ':' labelName ;

rangeLiteral : PG_MULTIPLY SP? ( integerLiteral SP? )? ( '..' SP? ( integerLiteral SP? )? )? ;

labelName : symbolicName ;

relTypeName : symbolicName ;

cypherExpression : orExpression ;

orExpression : xorExpression ( PG_OR xorExpression )* ;

xorExpression : andExpression ( XOR andExpression )* ;

andExpression : notExpression ( PG_AND notExpression )* ;

notExpression : ( PG_NOT SP? )* comparisonExpression ;

comparisonExpression : addOrSubtractExpression ( SP? partialComparisonExpression )* ;

addOrSubtractExpression : multiplyDivideModuloExpression ( ( SP? PG_PLUS SP? multiplyDivideModuloExpression ) | ( SP? PG_MINUS SP? multiplyDivideModuloExpression ) )* ;

multiplyDivideModuloExpression : powerOfExpression ( ( SP? PG_MULTIPLY SP? powerOfExpression ) | ( SP? PG_DIVIDE SP? powerOfExpression ) | ( SP? PG_MODULAR SP? powerOfExpression ) )* ;

powerOfExpression : unaryAddOrSubtractExpression ( SP? PG_EXP SP? unaryAddOrSubtractExpression )* ;

unaryAddOrSubtractExpression : ( ( PG_PLUS | PG_MINUS ) SP? )* stringListNullOperatorExpression ;

stringListNullOperatorExpression : propertyOrLabelsExpression ( ( SP? PG_LEFT_BRACKET cypherExpression PG_RIGHT_BRACKET ) | ( SP? PG_LEFT_BRACKET cypherExpression? '..' cypherExpression? PG_RIGHT_BRACKET ) | ( ( ( SP? ALMOST_EQUAL ) | ( PG_IN ) | ( STARTS PG_WITH ) | ( ENDS PG_WITH ) | ( CONTAINS ) ) SP? propertyOrLabelsExpression ) | ( PG_IS PG_NULL ) | ( PG_IS PG_NOT PG_NULL ) )* ;

propertyOrLabelsExpression : atom ( SP? ( propertyLookup | nodeLabels ) )* ;

filterFunction : ( filterFunctionName SP? cypherLeftParen SP? filterExpression SP? cypherRightParen ) ;

filterFunctionName : PG_FILTER ;

existsFunction : ( existsFunctionName SP? cypherLeftParen SP? cypherExpression SP? cypherRightParen ) ;

existsFunctionName: PG_EXISTS ;

allFunction : ( allFunctionName SP? cypherLeftParen SP? filterExpression SP? cypherRightParen ) ;

allFunctionName : PG_ALL ;

anyFunction : ( anyFunctionName SP? cypherLeftParen SP? filterExpression SP? cypherRightParen ) ;

anyFunctionName : PG_ANY ;

noneFunction : ( noneFunctionName SP? cypherLeftParen SP? filterExpression SP? cypherRightParen ) ;

noneFunctionName : PG_NONE ;

singleFunction : ( singleFunctionName SP? cypherLeftParen SP? filterExpression SP? cypherRightParen ) ;

singleFunctionName : SINGLE ;

extractFunction : ( extractFunctionName SP? cypherLeftParen SP? filterExpression ( SP? CHAR_OR SP? cypherExpression )? SP? cypherRightParen ) ;

extractFunctionName : PG_EXTRACT ;

reduceFunction : ( reduceFunctionName SP? cypherLeftParen SP? variable SP? PG_EQUAL SP? cypherExpression SP? PG_COMMA SP? idInColl SP? CHAR_OR SP? cypherExpression SP? cypherRightParen );

reduceFunctionName : REDUCE ;

shortestPathPatternFunction : (  shortestPathFunctionName SP? cypherLeftParen SP? patternElement SP? cypherRightParen )
                            | (  allShortestPathFunctionName SP? cypherLeftParen SP? patternElement SP? cypherRightParen )
                            ;

shortestPathFunctionName : SHORTESTPATH ;

allShortestPathFunctionName : ALLSHORTESTPATHS ;

atom : literal
     | parameter
     | caseExpression
     | ( COUNT SP? cypherLeftParen SP? PG_MULTIPLY SP? cypherRightParen )
     | listComprehension
     | patternComprehension
     | filterFunction
     | extractFunction
     | reduceFunction
     | allFunction
     | anyFunction
     | noneFunction
     | singleFunction
     | existsFunction
     | shortestPathPatternFunction
     | relationshipsPattern
     | parenthesizedExpression
     | functionInvocation
     | variable
     ;

literal : numberLiteral
        | stringLiteral
        | booleanLiteral
        | PG_NULL
        | mapLiteral
        | listLiteral
        | mapProjection
        ;

stringLiteral : PG_Character_String_Literal ;

booleanLiteral : PG_TRUE
               | PG_FALSE
               ;

listLiteral : PG_LEFT_BRACKET SP? ( cypherExpression SP? ( PG_COMMA SP? cypherExpression SP? )* )? PG_RIGHT_BRACKET ;

partialComparisonExpression : ( PG_EQUAL SP? addOrSubtractExpression )
                            | ( PG_NOT_EQUAL SP? addOrSubtractExpression )
                            | ( PG_LTH SP? addOrSubtractExpression )
                            | ( PG_GTH SP? addOrSubtractExpression )
                            | ( PG_LEQ SP? addOrSubtractExpression )
                            | ( PG_GEQ SP? addOrSubtractExpression )
                            ;

parenthesizedExpression : cypherLeftParen SP? cypherExpression SP? cypherRightParen ;

relationshipsPattern : nodePattern ( SP? patternElementChain )+ ;

filterExpression : idInColl ( SP? where )? ;

idInColl : variable PG_IN cypherExpression ;

functionInvocation : functionInvocationBody SP? cypherLeftParen SP? ( PG_DISTINCT SP? )? ( cypherExpression SP? ( PG_COMMA SP? cypherExpression SP? )* )? cypherRightParen ;

functionInvocationBody : namespace functionName ;

functionName : pg_identifier
             | COUNT ;

procedureName : symbolicName ;

listComprehension : PG_LEFT_BRACKET SP? filterExpression ( SP? CHAR_OR SP? cypherExpression )? SP? PG_RIGHT_BRACKET ;

patternComprehension : PG_LEFT_BRACKET SP? ( variable SP? PG_EQUAL SP? )? relationshipsPattern SP? ( PG_WHERE SP? cypherExpression SP? )? CHAR_OR SP? cypherExpression SP? PG_RIGHT_BRACKET ;

propertyLookup : '.' SP? ( propertyKeyName ) ;

caseExpression : ( ( PG_CASE ( SP? caseAlternatives )+ ) | ( PG_CASE SP? cypherExpression ( SP? caseAlternatives )+ ) ) ( SP? PG_ELSE SP? cypherExpression )? SP? PG_END ;

caseAlternatives : PG_WHEN SP? cypherExpression SP? PG_THEN SP? cypherExpression ;

variable : symbolicName ;

numberLiteral : doubleLiteral
              | integerLiteral
              ;

mapLiteral : cypherBraketOpen SP? ( literalEntry SP? ( PG_COMMA SP? literalEntry SP? )* )? cypherBraketClose ;

mapProjection : variable SP? cypherBraketOpen SP?  mapProjectionVariants? (SP? PG_COMMA SP? mapProjectionVariants  )* SP? cypherBraketClose ;

mapProjectionVariants : ( literalEntry | propertySelector | variableSelector | allPropertiesSelector) ;

literalEntry : propertyKeyName SP? ':' SP? cypherExpression ;

propertySelector : '.' variable ;

variableSelector : variable ;

allPropertiesSelector : '.' PG_MULTIPLY ;

parameter : legacyParameter
          | newParameter
          ;

legacyParameter : cypherBraketOpen SP? parameterName SP? cypherBraketClose ;

newParameter : '$' parameterName ;

parameterName : symbolicName
              | PG_NUMBER_LITERAL
              ;

propertyExpression : atom ( SP? propertyLookup )+ ;

propertyKeyName: symbolicName;

integerLiteral: PG_NUMBER_LITERAL;

doubleLiteral: PG_REAL_NUMBER;

namespace: ( symbolicName '.')*;

cypherBraketOpen: BRACKET_OPEN;
cypherBraketClose: BRACKET_CLOSE;

cypherLeftParen: PG_LEFT_PAREN;
cypherRightParen: PG_RIGHT_PAREN;

leftArrowHead: PG_LTH;

rightArrowHead: PG_GTH;

dash:
	PG_MINUS;

symbolicName:
    pg_identifier
    | keyword
    ;

keyword: PG_EXPLAIN
	| PG_UNION
	| PG_ALL
	| PG_CREATE
	| PG_ON
	| PG_IS
	| PG_UNIQUE
	| PG_EXISTS
	| PG_LOAD
	| PG_CSV
	| PG_WITH
	| HEADERS
	| PG_FROM
	| PG_AS
	| FIELDTERMINATOR
	| OPTIONAL
	| PG_MATCH
	| UNWIND
	| PG_MERGE
	| PG_SET
	| PG_DETACH
	| PG_DELETE
	| REMOVE
	| PG_IN
	| PG_DISTINCT
	| PG_RETURN
	| PG_ORDER
	| PG_BY
	| PG_SKIP_
	| PG_LIMIT
	| ASCENDING
	| PG_ASC
	| DESCENDING
	| PG_DESC
	| PG_WHERE
	| SHORTESTPATH
	| ALLSHORTESTPATHS
	| PG_OR
	| XOR
	| PG_AND
	| PG_NOT
	| STARTS
	| ENDS
	| CONTAINS
	| PG_NULL
	| COUNT
	| PG_FILTER
	| PG_EXTRACT
	| PG_ANY
	| PG_NONE
	| SINGLE
	| PG_TRUE
	| PG_FALSE
	| REDUCE
	| PG_CASE
	| PG_ELSE
	| PG_END
	| PG_WHEN
	| PG_THEN
	| YIELD;
