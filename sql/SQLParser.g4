parser grammar SQLParser;

options {
    tokenVocab=SQLLexer;
}
// to start parsing, it is recommended to use only rules with EOF
// this eliminates the ambiguous parsing options and speeds up the process
/******* Start symbols *******/

pg_sql
    : BOM? SEMI_COLON* (pg_statement (SEMI_COLON+ | EOF))* EOF
    ;

pg_qname_parser
    : pg_schema_qualified_name EOF
    ;

pg_function_args_parser
    : pg_schema_qualified_name? function_args EOF
    ;

pg_vex_eof
    : pg_vex (PG_COMMA pg_vex)* EOF
    ;

pg_plpgsql_function
    : comp_options? function_block SEMI_COLON? EOF
    ;

pg_plpgsql_function_test_list
    : (comp_options? function_block SEMI_COLON)* EOF
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
    | PG_ROLLBACK (PG_WORK | PG_TRANSACTION)? TO PG_SAVEPOINT? pg_identifier
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
    | REASSIGN OWNED BY pg_user_name (PG_COMMA pg_user_name)* TO pg_user_name
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
    | pg_create_view_statement)

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
    | pg_alter_view_statement)
    ;
// TODO
pg_schema_drop
    : DROP (drop_cast_statement
    | drop_database_statement
    | drop_function_statement
    | drop_operator_class_statement
    | drop_operator_family_statement
    | drop_operator_statement
    | drop_owned_statement
    | drop_policy_statement
    | drop_rule_statement
    | drop_statements
    | drop_trigger_statement
    | drop_user_mapping_statement)
    ;

pg_schema_import
    : IMPORT FOREIGN PG_SCHEMA name=pg_identifier
    ((LIMIT TO | EXCEPT) PG_LEFT_PAREN identifier_list PG_RIGHT_PAREN)?
    PG_FROM SERVER pg_identifier INTO pg_identifier
    define_foreign_options?
    ;

pg_alter_function_statement
    : (FUNCTION | PROCEDURE) function_parameters?
      ((function_actions_common | PG_RESET ((pg_identifier PG_DOT)? pg_identifier | PG_ALL))+ RESTRICT?
    | rename_to
    | set_schema
    | PG_NO? DEPENDS PG_ON EXTENSION pg_identifier)
    ;

pg_alter_aggregate_statement
    : AGGREGATE function_parameters (rename_to | set_schema)
    ;

pg_alter_extension_statement
    : EXTENSION pg_identifier alter_extension_action
    ;

alter_extension_action
    : set_schema
    | PG_UPDATE (TO (pg_identifier | pg_character_string))?
    | (ADD | DROP) extension_member_object
    ;

extension_member_object
    : PG_ACCESS METHOD pg_schema_qualified_name
    | AGGREGATE function_parameters
    | CAST PG_LEFT_PAREN pg_schema_qualified_name PG_AS pg_schema_qualified_name PG_RIGHT_PAREN
    | COLLATION pg_identifier
    | CONVERSION pg_identifier
    | DOMAIN pg_schema_qualified_name
    | EVENT TRIGGER pg_identifier
    | FOREIGN PG_DATA WRAPPER pg_identifier
    | FOREIGN PG_TABLE pg_schema_qualified_name
    | FUNCTION function_parameters
    | PG_MATERIALIZED? PG_VIEW pg_schema_qualified_name
    | OPERATOR operator_name
    | OPERATOR CLASS pg_schema_qualified_name PG_USING pg_identifier
    | OPERATOR FAMILY pg_schema_qualified_name PG_USING pg_identifier
    | PROCEDURAL? LANGUAGE pg_identifier
    | PROCEDURE function_parameters
    | ROUTINE function_parameters
    | PG_SCHEMA pg_identifier
    | SEQUENCE pg_schema_qualified_name
    | SERVER pg_identifier
    | PG_TABLE pg_schema_qualified_name
    | PG_TEXT SEARCH CONFIGURATION pg_schema_qualified_name
    | PG_TEXT SEARCH DICTIONARY pg_schema_qualified_name
    | PG_TEXT SEARCH PARSER pg_schema_qualified_name
    | PG_TEXT SEARCH TEMPLATE pg_schema_qualified_name
    | TRANSFORM PG_FOR pg_identifier LANGUAGE pg_identifier
    | TYPE pg_schema_qualified_name
    ;

pg_alter_schema_statement
    : PG_SCHEMA pg_identifier rename_to
    ;

pg_alter_language_statement
    : PROCEDURAL? LANGUAGE name=pg_identifier (rename_to | owner_to)
    ;

pg_alter_table_statement
    : FOREIGN? PG_TABLE if_exists? PG_ONLY? name=pg_schema_qualified_name PG_MULTIPLY?(
        table_action (PG_COMMA table_action)*
        | RENAME COLUMN? pg_identifier TO pg_identifier
        | set_schema
        | rename_to
        | RENAME CONSTRAINT pg_identifier TO pg_identifier
        | ATTACH PARTITION child=pg_schema_qualified_name for_values_bound
        | DETACH PARTITION child=pg_schema_qualified_name)
    ;

table_action
    : ADD COLUMN? if_not_exists? table_column_definition
    | DROP COLUMN? if_exists? column=pg_identifier cascade_restrict?
    | PG_ALTER COLUMN? column=pg_identifier column_action
    | ADD tabl_constraint=constraint_common (PG_NOT not_valid=VALID)?
    | validate_constraint
    | drop_constraint
    | (DISABLE | ENABLE) TRIGGER (trigger_name=pg_schema_qualified_name | PG_ALL | USER)?
    | ENABLE (REPLICA | ALWAYS) TRIGGER trigger_name=pg_schema_qualified_name
    | (DISABLE | ENABLE) RULE rewrite_rule_name=pg_schema_qualified_name
    | ENABLE (REPLICA | ALWAYS) RULE rewrite_rule_name=pg_schema_qualified_name
    | (DISABLE | ENABLE) PG_ROW PG_LEVEL SECURITY
    | PG_NO? FORCE PG_ROW PG_LEVEL SECURITY
    | PG_CLUSTER PG_ON index_name=pg_schema_qualified_name
    | SET PG_WITHOUT (PG_CLUSTER | OIDS)
    | SET PG_WITH OIDS
    | SET (LOGGED | UNLOGGED)
    | SET storage_parameter
    | PG_RESET names_in_parens
    | define_foreign_options
    | INHERIT parent_table=pg_schema_qualified_name
    | PG_NO INHERIT parent_table=pg_schema_qualified_name
    | OF type_name=pg_schema_qualified_name
    | PG_NOT OF
    | owner_to
    | set_tablespace
    | REPLICA IDENTITY (DEFAULT | PG_FULL | NOTHING | PG_USING PG_INDEX pg_identifier)
    | PG_ALTER CONSTRAINT pg_identifier table_deferrable? table_initialy_immed?
    ;

column_action
    : (SET PG_DATA)? TYPE pg_data_type collate_identifier? (PG_USING pg_vex)?
    | ADD identity_body
    | set_def_column
    | drop_def
    | (set=SET | DROP) PG_NOT NULL
    | DROP IDENTITY if_exists?
    | DROP EXPRESSION if_exists?
    | SET storage_parameter
    | set_statistics
    | SET STORAGE storage_option
    | PG_RESET names_in_parens
    | define_foreign_options
    | alter_identity+
    ;

identity_body
    : GENERATED (ALWAYS | BY DEFAULT) PG_AS IDENTITY (PG_LEFT_PAREN sequence_body+ PG_RIGHT_PAREN)?
    ;

alter_identity
    : SET GENERATED (ALWAYS | BY DEFAULT)
    | SET sequence_body
    | RESTART (PG_WITH? PG_NUMBER_LITERAL)?
    ;

storage_option
    : PLAIN
    | EXTERNAL
    | EXTENDED
    | MAIN
    ;

validate_constraint
    : VALIDATE CONSTRAINT constraint_name=pg_schema_qualified_name
    ;

drop_constraint
    : DROP CONSTRAINT if_exists? constraint_name=pg_identifier cascade_restrict?
    ;

table_deferrable
    : PG_NOT? PG_DEFERRABLE
    ;

table_initialy_immed
    : INITIALLY (DEFERRED | IMMEDIATE)
    ;

function_actions_common
    : (CALLED | RETURNS NULL) PG_ON NULL INPUT
    | TRANSFORM transform_for_type (PG_COMMA transform_for_type)*
    | STRICT
    | IMMUTABLE
    | VOLATILE
    | STABLE
    | PG_NOT? LEAKPROOF
    | EXTERNAL? SECURITY (INVOKER | DEFINER)
    | PG_PARALLEL (SAFE | UNSAFE | RESTRICTED)
    | COST execution_cost=unsigned_numeric_literal
    | ROWS result_rows=unsigned_numeric_literal
    | SUPPORT pg_schema_qualified_name
    | SET (config_scope=pg_identifier PG_DOT)? config_param=pg_identifier ((TO | EQUAL) set_statement_value | PG_FROM CURRENT)
    | LANGUAGE lang_name=pg_identifier
    | WINDOW
    | PG_AS function_def
    ;

function_def
    : definition=pg_character_string (PG_COMMA symbol=pg_character_string)?
    ;

pg_alter_index_statement
    : PG_INDEX if_exists? pg_schema_qualified_name index_def_action
    | PG_INDEX PG_ALL PG_IN TABLESPACE pg_identifier (OWNED BY identifier_list)? set_tablespace
    ;

index_def_action
    : rename_to
    | ATTACH PARTITION index=pg_schema_qualified_name
    | PG_NO? DEPENDS PG_ON EXTENSION pg_schema_qualified_name
    | PG_ALTER COLUMN? (PG_NUMBER_LITERAL | pg_identifier) set_statistics
    | PG_RESET PG_LEFT_PAREN identifier_list PG_RIGHT_PAREN
    | set_tablespace
    | SET storage_parameter
    ;

pg_alter_default_privileges_statement
    : DEFAULT PRIVILEGES
    (PG_FOR (ROLE | USER) identifier_list)?
    (PG_IN PG_SCHEMA identifier_list)?
    abbreviated_grant_or_revoke
    ;

abbreviated_grant_or_revoke
    : (GRANT | REVOKE grant_option_for?) (
        table_column_privilege (PG_COMMA table_column_privilege)* PG_ON TABLES
        | (usage_select_update (PG_COMMA usage_select_update)* | PG_ALL PRIVILEGES?) PG_ON PG_SEQUENCES
        | (PG_EXECUTE | PG_ALL PRIVILEGES?) PG_ON FUNCTIONS
        | (USAGE | PG_CREATE | PG_ALL PRIVILEGES?) PG_ON SCHEMAS
        | (USAGE | PG_ALL PRIVILEGES?) PG_ON TYPES)
    (grant_to_rule | revoke_from_cascade_restrict)
    ;

grant_option_for
    : GRANT OPTION PG_FOR
    ;

pg_alter_sequence_statement
    : SEQUENCE if_exists? name=pg_schema_qualified_name
     ( (sequence_body | RESTART (PG_WITH? pg_signed_number_literal)?)*
    | set_schema
    | rename_to)
    ;

pg_alter_view_statement
    : PG_VIEW if_exists? name=pg_schema_qualified_name alter_view_action
    ;

alter_view_action
    : PG_ALTER COLUMN? column_name=pg_identifier set_def_column
    | PG_ALTER COLUMN? column_name=pg_identifier drop_def
    | RENAME COLUMN? pg_identifier TO pg_identifier
    | rename_to
    | set_schema
    | SET storage_parameter
    | PG_RESET names_in_parens
    ;

pg_alter_materialized_view_statement
    : PG_MATERIALIZED PG_VIEW if_exists? pg_schema_qualified_name alter_materialized_view_action
    | PG_MATERIALIZED PG_VIEW PG_ALL PG_IN TABLESPACE pg_identifier (OWNED BY identifier_list)? set_tablespace
    ;

alter_materialized_view_action
    : rename_to
    | set_schema
    | RENAME COLUMN? pg_identifier TO pg_identifier
    | PG_NO? DEPENDS PG_ON EXTENSION pg_identifier
    | materialized_view_action (PG_COMMA materialized_view_action)*
    ;

materialized_view_action
    : PG_ALTER COLUMN? pg_identifier set_statistics
    | PG_ALTER COLUMN? pg_identifier SET storage_parameter
    | PG_ALTER COLUMN? pg_identifier PG_RESET names_in_parens
    | PG_ALTER COLUMN? pg_identifier SET STORAGE storage_option
    | PG_CLUSTER PG_ON index_name=pg_schema_qualified_name
    | SET PG_WITHOUT PG_CLUSTER
    | SET storage_parameter
    | PG_RESET names_in_parens
    ;

pg_alter_event_trigger_statement
    : EVENT TRIGGER name=pg_identifier alter_event_trigger_action
    ;

alter_event_trigger_action
    : DISABLE
    | ENABLE (REPLICA | ALWAYS)?
    | owner_to
    | rename_to
    ;

pg_alter_type_statement
    : TYPE name=pg_schema_qualified_name
      (set_schema
      | rename_to
      | ADD VALUE if_not_exists? new_enum_value=pg_character_string ((BEFORE | AFTER) existing_enum_value=pg_character_string)?
      | RENAME ATTRIBUTE attribute_name=pg_identifier TO new_attribute_name=pg_identifier cascade_restrict?
      | RENAME VALUE existing_enum_name=pg_character_string TO new_enum_name=pg_character_string
      | type_action (PG_COMMA type_action)*
      | SET PG_LEFT_PAREN type_property (PG_COMMA type_property)* PG_RIGHT_PAREN)
    ;

pg_alter_domain_statement
    : DOMAIN name=pg_schema_qualified_name
    (set_def_column
    | drop_def
    | (SET | DROP) PG_NOT NULL
    | ADD dom_constraint=domain_constraint (PG_NOT not_valid=VALID)?
    | drop_constraint
    | RENAME CONSTRAINT pg_schema_qualified_name TO pg_schema_qualified_name
    | validate_constraint
    | rename_to
    | set_schema)
    ;

pg_alter_server_statement
    : SERVER pg_identifier alter_server_action
    ;

alter_server_action
    : (VERSION pg_character_string)? define_foreign_options
    | VERSION pg_character_string
    | owner_to
    | rename_to
    ;

pg_alter_fts_statement
    : PG_TEXT SEARCH
      ((TEMPLATE | DICTIONARY | CONFIGURATION | PARSER) name=pg_schema_qualified_name (rename_to | set_schema)
      | DICTIONARY name=pg_schema_qualified_name storage_parameter
      | CONFIGURATION name=pg_schema_qualified_name alter_fts_configuration)
    ;

alter_fts_configuration
    : (ADD | PG_ALTER) MAPPING PG_FOR identifier_list PG_WITH pg_schema_qualified_name (PG_COMMA pg_schema_qualified_name)*
    | PG_ALTER MAPPING (PG_FOR identifier_list)? REPLACE pg_schema_qualified_name PG_WITH pg_schema_qualified_name
    | DROP MAPPING (IF EXISTS)? PG_FOR identifier_list
    ;

type_action
    : ADD ATTRIBUTE pg_identifier pg_data_type collate_identifier? cascade_restrict?
    | DROP ATTRIBUTE if_exists? pg_identifier cascade_restrict?
    | PG_ALTER ATTRIBUTE pg_identifier (SET PG_DATA)? TYPE pg_data_type collate_identifier? cascade_restrict?
    ;

type_property
    : (RECEIVE | SEND | TYPMOD_IN | TYPMOD_OUT | PG_ANALYZE) EQUAL pg_schema_qualified_name
    | STORAGE EQUAL storage=storage_option
    ;

set_def_column
    : SET DEFAULT pg_vex
    ;

drop_def
    : DROP DEFAULT
    ;

pg_create_index_statement
    : UNIQUE? PG_INDEX PG_CONCURRENTLY? if_not_exists? name=pg_identifier? PG_ON PG_ONLY? table_name=pg_schema_qualified_name index_rest
    ;

index_rest
    : (PG_USING method=pg_identifier)? index_sort including_index? with_storage_parameter? table_space? index_where?
    ;

index_sort
    : PG_LEFT_PAREN index_column (PG_COMMA index_column)* PG_RIGHT_PAREN
    ;

index_column
    : column=pg_vex operator_class=pg_schema_qualified_name?
    (PG_LEFT_PAREN option_with_value (PG_COMMA option_with_value)* PG_RIGHT_PAREN)?
    order_specification? null_ordering?
    ;

including_index
    : INCLUDE PG_LEFT_PAREN pg_identifier (PG_COMMA pg_identifier)* PG_RIGHT_PAREN
    ;

index_where
    : WHERE pg_vex
    ;

 pg_create_extension_statement
    : EXTENSION if_not_exists? name=pg_identifier
    PG_WITH?
    (PG_SCHEMA schema=pg_identifier)?
    (VERSION (pg_identifier | pg_character_string))?
    (PG_FROM (pg_identifier | pg_character_string))?
    CASCADE?
    ;

pg_create_language_statement
    : (OR REPLACE)? TRUSTED? PROCEDURAL? LANGUAGE name=pg_identifier
    (HANDLER pg_schema_qualified_name (INLINE pg_schema_qualified_name)? (VALIDATOR pg_schema_qualified_name)?)?
    ;

pg_create_event_trigger_statement
    : EVENT TRIGGER name=pg_identifier PG_ON pg_identifier
    (WHEN (pg_schema_qualified_name PG_IN PG_LEFT_PAREN pg_character_string (PG_COMMA pg_character_string)* PG_RIGHT_PAREN PG_AND?)+ )?
    PG_EXECUTE (PROCEDURE | FUNCTION) pg_vex
    ;

pg_create_type_statement
    : TYPE name=pg_schema_qualified_name (PG_AS(
        PG_LEFT_PAREN (attrs+=table_column_definition (PG_COMMA attrs+=table_column_definition)*)? PG_RIGHT_PAREN
        | ENUM PG_LEFT_PAREN ( enums+=pg_character_string (PG_COMMA enums+=pg_character_string)* )? PG_RIGHT_PAREN
        | RANGE PG_LEFT_PAREN
                (SUBTYPE EQUAL subtype_name=pg_data_type
                | SUBTYPE_OPCLASS EQUAL subtype_operator_class=pg_identifier
                | COLLATION EQUAL collation=pg_schema_qualified_name
                | CANONICAL EQUAL canonical_function=pg_schema_qualified_name
                | SUBTYPE_DIFF EQUAL subtype_diff_function=pg_schema_qualified_name)?
                (PG_COMMA (SUBTYPE EQUAL subtype_name=pg_data_type
                | SUBTYPE_OPCLASS EQUAL subtype_operator_class=pg_identifier
                | COLLATION EQUAL collation=pg_schema_qualified_name
                | CANONICAL EQUAL canonical_function=pg_schema_qualified_name
                | SUBTYPE_DIFF EQUAL subtype_diff_function=pg_schema_qualified_name))*
            PG_RIGHT_PAREN)
    | PG_LEFT_PAREN
            // pg_dump prints internallength first
            (INTERNALLENGTH EQUAL (internallength=signed_numerical_literal | VARIABLE) PG_COMMA)?
            INPUT EQUAL input_function=pg_schema_qualified_name PG_COMMA
            OUTPUT EQUAL output_function=pg_schema_qualified_name
            (PG_COMMA (RECEIVE EQUAL receive_function=pg_schema_qualified_name
            | SEND EQUAL send_function=pg_schema_qualified_name
            | TYPMOD_IN EQUAL type_modifier_input_function=pg_schema_qualified_name
            | TYPMOD_OUT EQUAL type_modifier_output_function=pg_schema_qualified_name
            | PG_ANALYZE EQUAL analyze_function=pg_schema_qualified_name
            | INTERNALLENGTH EQUAL (internallength=signed_numerical_literal | VARIABLE )
            | PASSEDBYVALUE
            | ALIGNMENT EQUAL alignment=pg_data_type
            | STORAGE EQUAL storage=storage_option
            | LIKE EQUAL like_type=pg_data_type
            | CATEGORY EQUAL category=pg_character_string
            | PREFERRED EQUAL preferred=truth_value
            | DEFAULT EQUAL default_value=pg_vex
            | ELEMENT EQUAL element=pg_data_type
            | DELIMITER EQUAL delimiter=pg_character_string
            | COLLATABLE EQUAL collatable=truth_value))*
        PG_RIGHT_PAREN)?
    ;

pg_create_domain_statement
    : DOMAIN name=pg_schema_qualified_name PG_AS? dat_type=pg_data_type
    (collate_identifier | DEFAULT def_value=pg_vex | dom_constraint+=domain_constraint)*
    ;

pg_create_server_statement
    : SERVER if_not_exists? pg_identifier (TYPE pg_character_string)? (VERSION pg_character_string)?
    FOREIGN PG_DATA WRAPPER pg_identifier
    define_foreign_options?
    ;

pg_create_fts_dictionary_statement
    : PG_TEXT SEARCH DICTIONARY name=pg_schema_qualified_name
    PG_LEFT_PAREN
        TEMPLATE EQUAL template=pg_schema_qualified_name (PG_COMMA option_with_value)*
    PG_RIGHT_PAREN
    ;

option_with_value
    : pg_identifier EQUAL pg_vex
    ;

pg_create_fts_configuration_statement
    : PG_TEXT SEARCH CONFIGURATION name=pg_schema_qualified_name
    PG_LEFT_PAREN
        (PARSER EQUAL parser_name=pg_schema_qualified_name
        | COPY EQUAL config_name=pg_schema_qualified_name)
    PG_RIGHT_PAREN
    ;

pg_create_fts_template_statement
    : PG_TEXT SEARCH TEMPLATE name=pg_schema_qualified_name
    PG_LEFT_PAREN
        (INIT EQUAL init_name=pg_schema_qualified_name PG_COMMA)?
        LEXIZE EQUAL lexize_name=pg_schema_qualified_name
        (PG_COMMA INIT EQUAL init_name=pg_schema_qualified_name)?
    PG_RIGHT_PAREN
    ;

pg_create_fts_parser_statement
    : PG_TEXT SEARCH PARSER name=pg_schema_qualified_name
    PG_LEFT_PAREN
        PG_START EQUAL start_func=pg_schema_qualified_name PG_COMMA
        GETTOKEN EQUAL gettoken_func=pg_schema_qualified_name PG_COMMA
        PG_END EQUAL end_func=pg_schema_qualified_name PG_COMMA
        (HEADLINE EQUAL headline_func=pg_schema_qualified_name PG_COMMA)?
        LEXTYPES EQUAL lextypes_func=pg_schema_qualified_name
        (PG_COMMA HEADLINE EQUAL headline_func=pg_schema_qualified_name)?
    PG_RIGHT_PAREN
    ;

pg_create_collation_statement
    : COLLATION if_not_exists? name=pg_schema_qualified_name
    (PG_FROM pg_schema_qualified_name | PG_LEFT_PAREN (collation_option (PG_COMMA collation_option)*)? PG_RIGHT_PAREN)
    ;

pg_alter_collation_statement
    : COLLATION name=pg_schema_qualified_name (PG_REFRESH VERSION | rename_to | owner_to | set_schema)
    ;

collation_option
    : (LOCALE | LC_COLLATE | LC_CTYPE | PROVIDER | VERSION) EQUAL (pg_character_string | pg_identifier)
    | DETERMINISTIC EQUAL pg_boolean_value
    ;

pg_create_user_mapping_statement
    : USER MAPPING if_not_exists? PG_FOR (pg_user_name | USER) SERVER pg_identifier define_foreign_options?
    ;

pg_alter_user_mapping_statement
    : USER MAPPING PG_FOR (pg_user_name | USER) SERVER pg_identifier define_foreign_options?
    ;

pg_alter_user_or_role_statement
    : (USER | ROLE) (alter_user_or_role_set_reset | pg_identifier rename_to | pg_user_name PG_WITH? user_or_role_option_for_alter+)
    ;

alter_user_or_role_set_reset
    : (pg_user_name | PG_ALL) (PG_IN PG_DATABASE pg_identifier)? set_reset_parameter
    ;

set_reset_parameter
    : SET (pg_identifier PG_DOT)? pg_identifier (TO | EQUAL) set_statement_value
    | SET (pg_identifier PG_DOT)? pg_identifier PG_FROM CURRENT
    | PG_RESET (pg_identifier PG_DOT)? pg_identifier
    | PG_RESET PG_ALL
    ;

pg_alter_group_statement
    : GROUP alter_group_action
    ;

alter_group_action
    : name=pg_identifier rename_to
    | pg_user_name (ADD | DROP) USER identifier_list
    ;

pg_alter_tablespace_statement
    : TABLESPACE name=pg_identifier alter_tablespace_action
    ;

pg_alter_owner_statement
    : (OPERATOR target_operator
        | LARGE OBJECT PG_NUMBER_LITERAL
        | (FUNCTION | PROCEDURE | AGGREGATE) name=pg_schema_qualified_name function_args
        | (PG_TEXT SEARCH DICTIONARY | PG_TEXT SEARCH CONFIGURATION | DOMAIN | PG_SCHEMA | SEQUENCE | TYPE | PG_MATERIALIZED? PG_VIEW)
        if_exists? name=pg_schema_qualified_name) owner_to
    ;

alter_tablespace_action
    : rename_to
    | owner_to
    | SET PG_LEFT_PAREN option_with_value (PG_COMMA option_with_value)* PG_RIGHT_PAREN
    | PG_RESET PG_LEFT_PAREN identifier_list PG_RIGHT_PAREN
    ;

pg_alter_statistics_statement
    : STATISTICS name=pg_schema_qualified_name (rename_to | set_schema | owner_to | set_statistics)
    ;

set_statistics
    : SET STATISTICS pg_signed_number_literal
    ;

pg_alter_foreign_data_wrapper
    : FOREIGN PG_DATA WRAPPER name=pg_identifier alter_foreign_data_wrapper_action
    ;

alter_foreign_data_wrapper_action
    : (HANDLER schema_qualified_name_nontype | PG_NO HANDLER )? (VALIDATOR schema_qualified_name_nontype | PG_NO VALIDATOR)? define_foreign_options?
    | owner_to
    | rename_to
    ;

pg_alter_operator_statement
    : OPERATOR target_operator alter_operator_action
    ;

alter_operator_action
    : set_schema
    | SET PG_LEFT_PAREN operator_set_restrict_join (PG_COMMA operator_set_restrict_join)* PG_RIGHT_PAREN
    ;

operator_set_restrict_join
    : (RESTRICT | JOIN) EQUAL pg_schema_qualified_name
    ;

drop_user_mapping_statement
    : USER MAPPING if_exists? PG_FOR (pg_user_name | USER) SERVER pg_identifier
    ;

drop_owned_statement
    : OWNED BY pg_user_name (PG_COMMA pg_user_name)* cascade_restrict?
    ;

drop_operator_statement
    : OPERATOR if_exists? target_operator (PG_COMMA target_operator)* cascade_restrict?
    ;

target_operator
    : name=operator_name PG_LEFT_PAREN (left_type=pg_data_type | NONE) PG_COMMA (right_type=pg_data_type | NONE) PG_RIGHT_PAREN
    ;

domain_constraint
    : (CONSTRAINT name=pg_identifier)? (CHECK PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN | PG_NOT? NULL)
    ;

pg_create_transform_statement
    : (OR REPLACE)? TRANSFORM PG_FOR pg_data_type LANGUAGE pg_identifier
    PG_LEFT_PAREN
        PG_FROM SQL PG_WITH FUNCTION function_parameters PG_COMMA
        TO SQL PG_WITH FUNCTION function_parameters
    PG_RIGHT_PAREN
    ;

pg_create_access_method_statement
    : PG_ACCESS METHOD pg_identifier TYPE (PG_TABLE | PG_INDEX) HANDLER pg_schema_qualified_name
    ;

pg_create_user_or_role_statement
    : (USER | ROLE) name=pg_identifier (PG_WITH? user_or_role_option user_or_role_option*)?
    ;

user_or_role_option
    : user_or_role_or_group_common_option
    | user_or_role_common_option
    | user_or_role_or_group_option_for_create
    ;

user_or_role_option_for_alter
    : user_or_role_or_group_common_option
    | user_or_role_common_option
    ;

user_or_role_or_group_common_option
    : SUPERUSER | NOSUPERUSER
    | CREATEDB | NOCREATEDB
    | CREATEROLE | NOCREATEROLE
    | INHERIT | NOINHERIT
    | LOGIN | NOLOGIN
    | ENCRYPTED? PASSWORD (password=PG_Character_String_Literal | NULL)
    | VALID UNTIL date_time=PG_Character_String_Literal
    ;

user_or_role_common_option
    : REPLICATION | NOREPLICATION
    | BYPASSRLS | NOBYPASSRLS
    | CONNECTION LIMIT pg_signed_number_literal
    ;

user_or_role_or_group_option_for_create
    : SYSID pg_vex
    | (PG_IN ROLE | PG_IN GROUP | ROLE | ADMIN | USER) identifier_list
    ;

pg_create_group_statement
    : GROUP name=pg_identifier (PG_WITH? group_option+)?
    ;

group_option
    : user_or_role_or_group_common_option
    | user_or_role_or_group_option_for_create
    ;

pg_create_tablespace_statement
    : TABLESPACE name=pg_identifier (OWNER pg_user_name)?
    LOCATION directory=PG_Character_String_Literal
    (PG_WITH PG_LEFT_PAREN option_with_value (PG_COMMA option_with_value)* PG_RIGHT_PAREN)?
    ;

pg_create_statistics_statement
    : STATISTICS if_not_exists? name=pg_schema_qualified_name
    (PG_LEFT_PAREN identifier_list PG_RIGHT_PAREN)?
    PG_ON pg_identifier PG_COMMA identifier_list
    PG_FROM pg_schema_qualified_name
    ;

pg_create_foreign_data_wrapper_statement
    : FOREIGN PG_DATA WRAPPER name=pg_identifier (HANDLER schema_qualified_name_nontype | PG_NO HANDLER )?
    (VALIDATOR schema_qualified_name_nontype | PG_NO VALIDATOR)?
    (OPTIONS PG_LEFT_PAREN option_without_equal (PG_COMMA option_without_equal)* PG_RIGHT_PAREN )?
    ;

option_without_equal
    : pg_identifier PG_Character_String_Literal
    ;

pg_create_operator_statement
    : OPERATOR name=operator_name PG_LEFT_PAREN operator_option (PG_COMMA operator_option)* PG_RIGHT_PAREN
    ;

operator_name
    : (schema_name=pg_identifier PG_DOT)? operator=all_simple_op
    ;

operator_option
    : (FUNCTION | PROCEDURE) EQUAL func_name=pg_schema_qualified_name
    | RESTRICT EQUAL restr_name=pg_schema_qualified_name
    | JOIN EQUAL join_name=pg_schema_qualified_name
    | (LEFTARG | RIGHTARG) EQUAL type=pg_data_type
    | (COMMUTATOR | NEGATOR) EQUAL addition_oper_name=all_op_ref
    | HASHES
    | MERGES
    ;

pg_create_aggregate_statement
    : (OR REPLACE)? AGGREGATE name=pg_schema_qualified_name function_args? PG_LEFT_PAREN
    (BASETYPE EQUAL base_type=pg_data_type PG_COMMA)?
    SFUNC EQUAL sfunc_name=pg_schema_qualified_name PG_COMMA
    STYPE EQUAL type=pg_data_type
    (PG_COMMA aggregate_param)*
    PG_RIGHT_PAREN
    ;

aggregate_param
    : SSPACE EQUAL s_space=PG_NUMBER_LITERAL
    | FINALFUNC EQUAL final_func=pg_schema_qualified_name
    | FINALFUNC_EXTRA
    | FINALFUNC_MODIFY EQUAL (READ_ONLY | SHAREABLE | READ_WRITE)
    | COMBINEFUNC EQUAL combine_func=pg_schema_qualified_name
    | SERIALFUNC EQUAL serial_func=pg_schema_qualified_name
    | DESERIALFUNC EQUAL deserial_func=pg_schema_qualified_name
    | INITCOND EQUAL init_cond=pg_vex
    | MSFUNC EQUAL ms_func=pg_schema_qualified_name
    | MINVFUNC EQUAL minv_func=pg_schema_qualified_name
    | MSTYPE EQUAL ms_type=pg_data_type
    | MSSPACE EQUAL ms_space=PG_NUMBER_LITERAL
    | MFINALFUNC EQUAL mfinal_func=pg_schema_qualified_name
    | MFINALFUNC_EXTRA
    | MFINALFUNC_MODIFY EQUAL (READ_ONLY | SHAREABLE | READ_WRITE)
    | MINITCOND EQUAL minit_cond=pg_vex
    | SORTOP EQUAL all_op_ref
    | PG_PARALLEL EQUAL (SAFE | RESTRICTED | UNSAFE)
    | HYPOTHETICAL
    ;

pg_set_statement
    : SET set_action
    ;

set_action
    : CONSTRAINTS (PG_ALL | names_references) (DEFERRED | IMMEDIATE)
    | PG_TRANSACTION pg_transaction_mode (PG_COMMA pg_transaction_mode)*
    | PG_TRANSACTION SNAPSHOT PG_Character_String_Literal
    | PG_SESSION CHARACTERISTICS PG_AS PG_TRANSACTION pg_transaction_mode (PG_COMMA pg_transaction_mode)*
    | (PG_SESSION | LOCAL)? session_local_option
    | PG_XML OPTION (DOCUMENT | CONTENT)
    ;

session_local_option
    : PG_SESSION PG_AUTHORIZATION (PG_Character_String_Literal | pg_identifier | DEFAULT)
    | PG_TIME PG_ZONE (PG_Character_String_Literal | signed_numerical_literal | LOCAL | DEFAULT)
    | (pg_identifier PG_DOT)? config_param=pg_identifier (TO | EQUAL) set_statement_value
    | ROLE (pg_identifier | NONE)
    ;

set_statement_value
    : pg_vex (PG_COMMA pg_vex)*
    | DEFAULT
    ;

pg_create_rewrite_statement
    : (OR REPLACE)? RULE name=pg_identifier PG_AS PG_ON event=(SELECT | INSERT | DELETE | PG_UPDATE)
     TO table_name=pg_schema_qualified_name (WHERE pg_vex)? DO (ALSO | INSTEAD)?
     (NOTHING
        | rewrite_command
        | (PG_LEFT_PAREN (rewrite_command SEMI_COLON)* rewrite_command SEMI_COLON? PG_RIGHT_PAREN)
     )
    ;

rewrite_command
    : pg_select_stmt
    | pg_insert_stmt_for_psql
    | pg_update_stmt_for_psql
    | pg_delete_stmt_for_psql
    | pg_notify_stmt
    ;

pg_create_trigger_statement
    : CONSTRAINT? TRIGGER name=pg_identifier (before_true=BEFORE | (INSTEAD OF) | AFTER)
    (((insert_true=INSERT | delete_true=DELETE | truncate_true=PG_TRUNCATE)
    | update_true=PG_UPDATE (OF identifier_list)?)OR?)+
    PG_ON table_name=pg_schema_qualified_name
    (PG_FROM referenced_table_name=pg_schema_qualified_name)?
    table_deferrable? table_initialy_immed?
    (REFERENCING trigger_referencing trigger_referencing?)?
    (for_each_true=PG_FOR EACH? (PG_ROW | STATEMENT))?
    when_trigger?
    PG_EXECUTE (FUNCTION | PROCEDURE) func_name=pg_function_call
    ;

trigger_referencing
    : (OLD | NEW) PG_TABLE PG_AS? pg_identifier
    ;

when_trigger
    : WHEN PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN
    ;

pg_rule_common
    : (GRANT | REVOKE grant_option_for?)
    (permissions | columns_permissions)
    PG_ON rule_member_object
    (TO | PG_FROM) roles_names (PG_WITH GRANT OPTION | cascade_restrict)?
    | other_rules
    ;

rule_member_object
    : PG_TABLE? table_names=names_references
    | SEQUENCE names_references
    | PG_DATABASE names_references
    | DOMAIN names_references
    | FOREIGN PG_DATA WRAPPER names_references
    | FOREIGN SERVER names_references
    | (FUNCTION | PROCEDURE | ROUTINE) func_name+=function_parameters (PG_COMMA func_name+=function_parameters)*
    | LARGE OBJECT PG_NUMBER_LITERAL (PG_COMMA PG_NUMBER_LITERAL)*
    | LANGUAGE names_references
    | PG_SCHEMA schema_names=names_references
    | TABLESPACE names_references
    | TYPE names_references
    | PG_ALL (TABLES | PG_SEQUENCES | FUNCTIONS | PROCEDURES | ROUTINES) PG_IN PG_SCHEMA names_references
    ;

columns_permissions
    : table_column_privileges (PG_COMMA table_column_privileges)*
    ;

table_column_privileges
    : table_column_privilege PG_LEFT_PAREN identifier_list PG_RIGHT_PAREN
    ;

permissions
    : permission (PG_COMMA permission)*
    ;

permission
    : PG_ALL PRIVILEGES?
    | CONNECT
    | PG_CREATE
    | DELETE
    | PG_EXECUTE
    | INSERT
    | PG_UPDATE
    | REFERENCES
    | SELECT
    | PG_TEMP
    | TRIGGER
    | PG_TRUNCATE
    | USAGE
    ;

other_rules
    : GRANT names_references TO names_references (PG_WITH ADMIN OPTION)?
    | REVOKE (ADMIN OPTION PG_FOR)? names_references PG_FROM names_references cascade_restrict?
    ;

grant_to_rule
    : TO roles_names (PG_WITH GRANT OPTION)?
    ;

revoke_from_cascade_restrict
    : PG_FROM roles_names cascade_restrict?
    ;

roles_names
    : role_name_with_group (PG_COMMA role_name_with_group)*
    ;

role_name_with_group
    : GROUP? pg_user_name
    ;

pg_comment_on_statement
    : COMMENT PG_ON comment_member_object IS (pg_character_string | NULL)
    ;

pg_security_label
    : SECURITY LABEL (PG_FOR (pg_identifier | pg_character_string))? PG_ON label_member_object IS (pg_character_string | NULL)
    ;

comment_member_object
    : PG_ACCESS METHOD pg_identifier
    | (AGGREGATE | PROCEDURE | FUNCTION | ROUTINE) name=pg_schema_qualified_name function_args
    | CAST PG_LEFT_PAREN source=pg_data_type PG_AS target=pg_data_type PG_RIGHT_PAREN
    | COLLATION pg_identifier
    | COLUMN name=pg_schema_qualified_name
    | CONSTRAINT pg_identifier PG_ON DOMAIN? table_name=pg_schema_qualified_name
    | CONVERSION name=pg_schema_qualified_name
    | PG_DATABASE pg_identifier
    | DOMAIN name=pg_schema_qualified_name
    | EXTENSION pg_identifier
    | EVENT TRIGGER pg_identifier
    | FOREIGN PG_DATA WRAPPER pg_identifier
    | FOREIGN? PG_TABLE name=pg_schema_qualified_name
    | PG_INDEX name=pg_schema_qualified_name
    | LARGE OBJECT PG_NUMBER_LITERAL
    | PG_MATERIALIZED? PG_VIEW name=pg_schema_qualified_name
    | OPERATOR target_operator
    | OPERATOR (FAMILY| CLASS) name=pg_schema_qualified_name PG_USING index_method=pg_identifier
    | POLICY pg_identifier PG_ON table_name=pg_schema_qualified_name
    | PROCEDURAL? LANGUAGE name=pg_schema_qualified_name
    | PUBLICATION pg_identifier
    | ROLE pg_identifier
    | RULE pg_identifier PG_ON table_name=pg_schema_qualified_name
    | PG_SCHEMA pg_identifier
    | SEQUENCE name=pg_schema_qualified_name
    | SERVER pg_identifier
    | STATISTICS name=pg_schema_qualified_name
    | SUBSCRIPTION pg_identifier
    | TABLESPACE pg_identifier
    | PG_TEXT SEARCH CONFIGURATION name=pg_schema_qualified_name
    | PG_TEXT SEARCH DICTIONARY name=pg_schema_qualified_name
    | PG_TEXT SEARCH PARSER name=pg_schema_qualified_name
    | PG_TEXT SEARCH TEMPLATE name=pg_schema_qualified_name
    | TRANSFORM PG_FOR name=pg_schema_qualified_name LANGUAGE pg_identifier
    | TRIGGER pg_identifier PG_ON table_name=pg_schema_qualified_name
    | TYPE name=pg_schema_qualified_name
    ;

label_member_object
    : (AGGREGATE | PROCEDURE | FUNCTION | ROUTINE) pg_schema_qualified_name function_args
    | COLUMN pg_schema_qualified_name
    | PG_DATABASE pg_identifier
    | DOMAIN pg_schema_qualified_name
    | EVENT TRIGGER pg_identifier
    | FOREIGN? PG_TABLE pg_schema_qualified_name
    | LARGE OBJECT PG_NUMBER_LITERAL
    | PG_MATERIALIZED? PG_VIEW pg_schema_qualified_name
    | PROCEDURAL? LANGUAGE pg_schema_qualified_name
    | PUBLICATION pg_identifier
    | ROLE pg_identifier
    | PG_SCHEMA pg_identifier
    | SEQUENCE pg_schema_qualified_name
    | SUBSCRIPTION pg_identifier
    | TABLESPACE pg_identifier
    | TYPE pg_schema_qualified_name
    ;

/*
===============================================================================
  Function and Procedure Definition
===============================================================================
*/
pg_create_function_statement
    : (OR REPLACE)? (FUNCTION | PROCEDURE) function_parameters
    (RETURNS (rettype_data=pg_data_type | ret_table=function_ret_table))?
    create_funct_params
    ;

create_funct_params
    : function_actions_common+ with_storage_parameter?
    ;

transform_for_type
    : PG_FOR TYPE pg_data_type
    ;

function_ret_table
    : PG_TABLE PG_LEFT_PAREN function_column_name_type (PG_COMMA function_column_name_type)* PG_RIGHT_PAREN
    ;

function_column_name_type
    : pg_identifier pg_data_type
    ;

function_parameters
    : pg_schema_qualified_name function_args
    ;

function_args
    : PG_LEFT_PAREN ((function_arguments (PG_COMMA function_arguments)*)? agg_order? | PG_MULTIPLY) PG_RIGHT_PAREN
    ;

agg_order
    : ORDER BY function_arguments (PG_COMMA function_arguments)*
    ;

pg_character_string
    : BeginDollarStringConstant Text_between_Dollar* EndDollarStringConstant
    | PG_Character_String_Literal
    ;

function_arguments
    : argmode? identifier_nontype? pg_data_type ((DEFAULT | EQUAL) pg_vex)?
    ;

argmode
    : PG_IN | OUT | INOUT | VARIADIC
    ;

pg_create_sequence_statement
    : (PG_TEMPORARY | PG_TEMP)? SEQUENCE if_not_exists? name=pg_schema_qualified_name (sequence_body)*
    ;

sequence_body
    : PG_AS type=(SMALLINT | INTEGER | BIGINT)
    | SEQUENCE NAME name=pg_schema_qualified_name
    | INCREMENT BY? incr=signed_numerical_literal
    | (MINVALUE minval=signed_numerical_literal | PG_NO MINVALUE)
    | (MAXVALUE maxval=signed_numerical_literal | PG_NO MAXVALUE)
    | PG_START PG_WITH? start_val=signed_numerical_literal
    | CACHE cache_val=signed_numerical_literal
    | cycle_true=PG_NO? cycle_val=CYCLE
    | OWNED BY col_name=pg_schema_qualified_name
    ;

pg_signed_number_literal
    : sign? PG_NUMBER_LITERAL
    ;

signed_numerical_literal
    : sign? unsigned_numeric_literal
    ;

sign
    : PLUS | MINUS
    ;

pg_create_schema_statement
    : PG_SCHEMA if_not_exists? name=pg_identifier? (PG_AUTHORIZATION pg_user_name)?
    ;

pg_create_policy_statement
    : POLICY pg_identifier PG_ON pg_schema_qualified_name
    (PG_AS (PERMISSIVE | RESTRICTIVE))?
    (PG_FOR event=(PG_ALL | SELECT | INSERT | PG_UPDATE | DELETE))?
    (TO pg_user_name (PG_COMMA pg_user_name)*)?
    (PG_USING using=pg_vex)? (PG_WITH CHECK check=pg_vex)?
    ;

pg_alter_policy_statement
    : POLICY pg_identifier PG_ON pg_schema_qualified_name rename_to
    | POLICY pg_identifier PG_ON pg_schema_qualified_name (TO pg_user_name (PG_COMMA pg_user_name)*)? (PG_USING pg_vex)? (PG_WITH CHECK pg_vex)?
    ;

drop_policy_statement
    : POLICY if_exists? pg_identifier PG_ON pg_schema_qualified_name cascade_restrict?
    ;

pg_create_subscription_statement
    : SUBSCRIPTION pg_identifier
    CONNECTION PG_Character_String_Literal
    PUBLICATION identifier_list
    with_storage_parameter?
    ;

pg_alter_subscription_statement
    : SUBSCRIPTION pg_identifier alter_subscription_action
    ;

alter_subscription_action
    : CONNECTION pg_character_string
    | SET PUBLICATION identifier_list with_storage_parameter?
    | PG_REFRESH PUBLICATION with_storage_parameter?
    | ENABLE
    | DISABLE
    | SET storage_parameter
    | owner_to
    | rename_to
    ;

pg_create_cast_statement
    : CAST PG_LEFT_PAREN source=pg_data_type PG_AS target=pg_data_type PG_RIGHT_PAREN
    (PG_WITH FUNCTION func_name=pg_schema_qualified_name function_args | PG_WITHOUT FUNCTION | PG_WITH INOUT)
    (PG_AS ASSIGNMENT | PG_AS IMPLICIT)?
    ;

drop_cast_statement
    : CAST if_exists? PG_LEFT_PAREN source=pg_data_type PG_AS target=pg_data_type PG_RIGHT_PAREN cascade_restrict?
    ;

pg_create_operator_family_statement
    : OPERATOR FAMILY pg_schema_qualified_name PG_USING pg_identifier
    ;

pg_alter_operator_family_statement
    : OPERATOR FAMILY pg_schema_qualified_name PG_USING pg_identifier operator_family_action
    ;

operator_family_action
    : rename_to
    | owner_to
    | set_schema
    | ADD add_operator_to_family (PG_COMMA add_operator_to_family)*
    | DROP drop_operator_from_family (PG_COMMA drop_operator_from_family)*
    ;

add_operator_to_family
    : OPERATOR unsigned_numeric_literal target_operator (PG_FOR SEARCH | PG_FOR ORDER BY pg_schema_qualified_name)?
    | FUNCTION unsigned_numeric_literal (PG_LEFT_PAREN (pg_data_type | NONE) (PG_COMMA (pg_data_type | NONE))? PG_RIGHT_PAREN)? pg_function_call
    ;

drop_operator_from_family
    : (OPERATOR | FUNCTION) unsigned_numeric_literal PG_LEFT_PAREN (pg_data_type | NONE) (PG_COMMA (pg_data_type | NONE))? PG_RIGHT_PAREN
    ;

drop_operator_family_statement
    : OPERATOR FAMILY if_exists? pg_schema_qualified_name PG_USING pg_identifier cascade_restrict?
    ;

pg_create_operator_class_statement
    : OPERATOR CLASS pg_schema_qualified_name DEFAULT? PG_FOR TYPE pg_data_type
    PG_USING pg_identifier (FAMILY pg_schema_qualified_name)? PG_AS
    create_operator_class_option (PG_COMMA create_operator_class_option)*
    ;

create_operator_class_option
    : OPERATOR unsigned_numeric_literal name=operator_name
        (PG_LEFT_PAREN (pg_data_type | NONE) PG_COMMA (pg_data_type | NONE) PG_RIGHT_PAREN)?
        (PG_FOR SEARCH | PG_FOR ORDER BY pg_schema_qualified_name)?
    | FUNCTION unsigned_numeric_literal
        (PG_LEFT_PAREN (pg_data_type | NONE) (PG_COMMA (pg_data_type | NONE))? PG_RIGHT_PAREN)?
        pg_function_call
    | STORAGE pg_data_type
    ;

pg_alter_operator_class_statement
    : OPERATOR CLASS pg_schema_qualified_name PG_USING pg_identifier (rename_to | owner_to | set_schema)
    ;

drop_operator_class_statement
    : OPERATOR CLASS if_exists? pg_schema_qualified_name PG_USING pg_identifier cascade_restrict?
    ;

pg_create_conversion_statement
    : DEFAULT? CONVERSION pg_schema_qualified_name PG_FOR PG_Character_String_Literal TO PG_Character_String_Literal PG_FROM pg_schema_qualified_name
    ;

pg_alter_conversion_statement
    : CONVERSION pg_schema_qualified_name (rename_to | owner_to | set_schema)
    ;

pg_create_publication_statement
    : PUBLICATION pg_identifier
    (PG_FOR PG_TABLE pg_only_table_multiply (PG_COMMA pg_only_table_multiply)* | PG_FOR PG_ALL TABLES)?
    with_storage_parameter?
    ;

pg_alter_publication_statement
    : PUBLICATION pg_identifier alter_publication_action
    ;

alter_publication_action
    : rename_to
    | owner_to
    | SET storage_parameter
    | (ADD | DROP | SET) PG_TABLE pg_only_table_multiply (PG_COMMA pg_only_table_multiply)*
    ;

pg_only_table_multiply
    : PG_ONLY? pg_schema_qualified_name PG_MULTIPLY?
    ;

pg_alter_trigger_statement
    : TRIGGER pg_identifier PG_ON pg_schema_qualified_name (rename_to | PG_NO? DEPENDS PG_ON EXTENSION pg_identifier)
    ;

pg_alter_rule_statement
    : RULE pg_identifier PG_ON pg_schema_qualified_name rename_to
    ;

pg_copy_statement
    : copy_to_statement
    | copy_from_statement
    ;

copy_from_statement
    : COPY pg_table_cols
    PG_FROM (PROGRAM? PG_Character_String_Literal | STDIN)
    (PG_WITH? (PG_LEFT_PAREN copy_option_list PG_RIGHT_PAREN | copy_option_list))?
    (WHERE pg_vex)?
    ;

copy_to_statement
    : COPY (pg_table_cols | PG_LEFT_PAREN pg_data_statement PG_RIGHT_PAREN)
    TO (PROGRAM? PG_Character_String_Literal | STDOUT)
    (PG_WITH? (PG_LEFT_PAREN copy_option_list PG_RIGHT_PAREN | copy_option_list))?
    ;

copy_option_list
    : copy_option (PG_COMMA? copy_option)*
    ;

copy_option
    : PG_FORMAT? (PG_TEXT | CSV | PG_BINARY)
    | OIDS truth_value?
    | PG_FREEZE truth_value?
    | DELIMITER PG_AS? PG_Character_String_Literal
    | NULL PG_AS? PG_Character_String_Literal
    | HEADER truth_value?
    | QUOTE PG_Character_String_Literal
    | ESCAPE PG_Character_String_Literal
    | FORCE QUOTE (PG_MULTIPLY | identifier_list)
    | FORCE_QUOTE (PG_MULTIPLY | PG_LEFT_PAREN identifier_list PG_RIGHT_PAREN)
    | FORCE PG_NOT NULL identifier_list
    | FORCE_NOT_NULL PG_LEFT_PAREN identifier_list PG_RIGHT_PAREN
    | FORCE_NULL PG_LEFT_PAREN identifier_list PG_RIGHT_PAREN
    | ENCODING PG_Character_String_Literal
    ;

pg_create_view_statement
    : (OR REPLACE)? (PG_TEMP | PG_TEMPORARY)? RECURSIVE? PG_MATERIALIZED? PG_VIEW
    if_not_exists? name=pg_schema_qualified_name column_names=view_columns?
    (PG_USING pg_identifier)?
    (PG_WITH storage_parameter)?
    table_space?
    PG_AS v_query=pg_select_stmt
    with_check_option?
    (PG_WITH PG_NO? PG_DATA)?
    ;

if_exists
    : IF EXISTS
    ;

if_not_exists
    : IF PG_NOT EXISTS
    ;

view_columns
    : PG_LEFT_PAREN pg_identifier (PG_COMMA pg_identifier)* PG_RIGHT_PAREN
    ;

with_check_option
    : PG_WITH (CASCADED|LOCAL)? CHECK OPTION
    ;

pg_create_database_statement
    : PG_DATABASE pg_identifier (PG_WITH? create_database_option+)?
    ;

create_database_option
    : (OWNER | TEMPLATE | ENCODING | LOCALE | LC_COLLATE | LC_CTYPE | TABLESPACE) EQUAL? (pg_character_string | pg_identifier | DEFAULT)
    | alter_database_option
    ;

pg_alter_database_statement
    : PG_DATABASE pg_identifier alter_database_action?
    ;

alter_database_action
    : PG_WITH? alter_database_option+
    | PG_WITH? TABLESPACE EQUAL? (pg_character_string | pg_identifier | DEFAULT)
    | rename_to
    | owner_to
    | set_tablespace
    | set_reset_parameter
    ;

alter_database_option
    : (ALLOW_CONNECTIONS | IS_TEMPLATE) EQUAL? (pg_boolean_value | DEFAULT)
    | CONNECTION LIMIT EQUAL? (pg_signed_number_literal | DEFAULT)
    ;

pg_create_table_statement
    : ((GLOBAL | LOCAL)? (PG_TEMPORARY | PG_TEMP) | UNLOGGED)? PG_TABLE if_not_exists? name=pg_schema_qualified_name
    define_table
    partition_by?
    (PG_USING pg_identifier)?
    storage_parameter_oid?
    on_commit?
    table_space?
    ;

pg_create_table_as_statement
    : ((GLOBAL | LOCAL)? (PG_TEMPORARY | PG_TEMP) | UNLOGGED)? PG_TABLE if_not_exists? name=pg_schema_qualified_name
    names_in_parens?
    (PG_USING pg_identifier)?
    storage_parameter_oid?
    on_commit?
    table_space?
    PG_AS (pg_select_stmt | PG_EXECUTE pg_function_call)
    (PG_WITH PG_NO? PG_DATA)?
    ;

pg_create_foreign_table_statement
    : FOREIGN PG_TABLE if_not_exists? name=pg_schema_qualified_name
    (define_columns | define_partition)
    define_server
    ;

define_table
    : define_columns
    | define_type
    | define_partition
    ;

define_partition
    : PARTITION OF parent_table=pg_schema_qualified_name
    list_of_type_column_def?
    for_values_bound
    ;

for_values_bound
    : PG_FOR VALUES partition_bound_spec
    | DEFAULT
    ;

partition_bound_spec
    : PG_IN PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN
    | PG_FROM partition_bound_part TO partition_bound_part
    | PG_WITH PG_LEFT_PAREN MODULUS PG_NUMBER_LITERAL PG_COMMA REMAINDER PG_NUMBER_LITERAL PG_RIGHT_PAREN
    ;

partition_bound_part
    : PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN
    ;

define_columns
    : PG_LEFT_PAREN (table_column_def (PG_COMMA table_column_def)*)? PG_RIGHT_PAREN (INHERITS names_in_parens)?
    ;

define_type
    : OF type_name=pg_data_type list_of_type_column_def?
    ;

partition_by
    : PARTITION BY partition_method
    ;

partition_method
    : (RANGE | LIST | HASH) PG_LEFT_PAREN partition_column (PG_COMMA partition_column)* PG_RIGHT_PAREN
    ;

partition_column
    : pg_vex pg_identifier?
    ;

define_server
    : SERVER pg_identifier define_foreign_options?
    ;

define_foreign_options
    : OPTIONS PG_LEFT_PAREN (foreign_option (PG_COMMA foreign_option)*) PG_RIGHT_PAREN
    ;

foreign_option
    : (ADD | SET | DROP)? foreign_option_name pg_character_string?
    ;

foreign_option_name
    : pg_identifier
    | USER
    ;

list_of_type_column_def
    : PG_LEFT_PAREN (table_of_type_column_def (PG_COMMA table_of_type_column_def)*) PG_RIGHT_PAREN
    ;

table_column_def
    : table_column_definition
    | tabl_constraint=constraint_common
    | LIKE pg_schema_qualified_name like_option*
    ;

table_of_type_column_def
    : pg_identifier (PG_WITH OPTIONS)? constraint_common*
    | tabl_constraint=constraint_common
    ;

table_column_definition
    : pg_identifier pg_data_type define_foreign_options? collate_identifier? constraint_common*
    ;

like_option
    : (INCLUDING | EXCLUDING) (COMMENTS | CONSTRAINTS | DEFAULTS | GENERATED | IDENTITY | INDEXES | STORAGE | PG_ALL)
    ;
/** NULL, DEFAULT - column constraint
* EXCLUDE, FOREIGN KEY - table_constraint
*/
constraint_common
    : (CONSTRAINT pg_identifier)? constr_body table_deferrable? table_initialy_immed?
    ;

constr_body
    : EXCLUDE (PG_USING index_method=pg_identifier)?
            PG_LEFT_PAREN index_column PG_WITH all_op (PG_COMMA index_column PG_WITH all_op)* PG_RIGHT_PAREN
            index_parameters (where=WHERE exp=pg_vex)?
    | (FOREIGN KEY names_in_parens)? REFERENCES pg_schema_qualified_name ref=names_in_parens?
        (MATCH (PG_FULL | PARTIAL | SIMPLE) | PG_ON (DELETE | PG_UPDATE) action)*
    | CHECK PG_LEFT_PAREN expression=pg_vex PG_RIGHT_PAREN (PG_NO INHERIT)?
    | PG_NOT? NULL
    | (UNIQUE | PRIMARY KEY) col=names_in_parens? index_parameters
    | DEFAULT default_expr=pg_vex
    | identity_body
    | GENERATED ALWAYS PG_AS PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN STORED
    ;

all_op
    : op
    | EQUAL | NOT_EQUAL | LTH | LEQ | GTH | GEQ
    | PLUS | MINUS | PG_MULTIPLY | DIVIDE | MODULAR | EXP
    ;

all_simple_op
    : op_chars
    | EQUAL | NOT_EQUAL | LTH | LEQ | GTH | GEQ
    | PLUS | MINUS | PG_MULTIPLY | DIVIDE | MODULAR | EXP
    ;

op_chars
    : OP_CHARS
    | LESS_LESS
    | GREATER_GREATER
    | HASH_SIGN
    ;

index_parameters
    : including_index? with_storage_parameter? (PG_USING PG_INDEX (table_space | pg_schema_qualified_name))?
    ;

names_in_parens
    : PG_LEFT_PAREN names_references PG_RIGHT_PAREN
    ;

names_references
    : pg_schema_qualified_name (PG_COMMA pg_schema_qualified_name)*
    ;

storage_parameter
    : PG_LEFT_PAREN storage_parameter_option (PG_COMMA storage_parameter_option)* PG_RIGHT_PAREN
    ;

storage_parameter_option
    : storage_parameter_name (EQUAL pg_vex)?
    ;

storage_parameter_name
    : col_label (PG_DOT col_label)?
    ;

with_storage_parameter
    : PG_WITH storage_parameter
    ;

storage_parameter_oid
    : with_storage_parameter | (PG_WITH OIDS) | (PG_WITHOUT OIDS)
    ;

on_commit
    : PG_ON PG_COMMIT (PRESERVE ROWS | DELETE ROWS | DROP)
    ;

table_space
    : TABLESPACE pg_identifier
    ;

set_tablespace
    : SET TABLESPACE pg_identifier PG_NOWAIT?
    ;

action
    : cascade_restrict
    | SET (NULL | DEFAULT)
    | PG_NO ACTION
    ;

owner_to
    : OWNER TO (name=pg_identifier | PG_CURRENT_USER | PG_SESSION_USER)
    ;

rename_to
    : RENAME TO name=pg_identifier
    ;

set_schema
    : SET PG_SCHEMA pg_identifier
    ;

table_column_privilege
    : SELECT | INSERT | PG_UPDATE | DELETE | PG_TRUNCATE | REFERENCES | TRIGGER | PG_ALL PRIVILEGES?
    ;

usage_select_update
    : USAGE | SELECT | PG_UPDATE
    ;

partition_by_columns
    : PARTITION BY pg_vex (PG_COMMA pg_vex)*
    ;

cascade_restrict
    : CASCADE | RESTRICT
    ;

collate_identifier
    : COLLATE collation=pg_schema_qualified_name
    ;

indirection_var
    : (pg_identifier | dollar_number) indirection_list?
    ;

dollar_number
    : DOLLAR_NUMBER
    ;

indirection_list
    : indirection+
    | indirection* PG_DOT PG_MULTIPLY
    ;

indirection
    : PG_DOT col_label
    | LEFT_BRACKET pg_vex RIGHT_BRACKET
    | LEFT_BRACKET pg_vex? COLON pg_vex? RIGHT_BRACKET
    ;

/*
===============================================================================
  11.21 <data types>
===============================================================================
*/

drop_database_statement
    : PG_DATABASE if_exists? pg_identifier (PG_WITH? PG_LEFT_PAREN FORCE PG_RIGHT_PAREN)?
    ;

drop_function_statement
    : (FUNCTION | PROCEDURE | AGGREGATE) if_exists? name=pg_schema_qualified_name function_args? cascade_restrict?
    ;

drop_trigger_statement
    : TRIGGER if_exists? name=pg_identifier PG_ON table_name=pg_schema_qualified_name cascade_restrict?
    ;

drop_rule_statement
    : RULE if_exists? name=pg_identifier PG_ON pg_schema_qualified_name cascade_restrict?
    ;

drop_statements
    : (PG_ACCESS METHOD
    | COLLATION
    | CONVERSION
    | DOMAIN
    | EVENT TRIGGER
    | EXTENSION
    | GROUP
    | FOREIGN? PG_TABLE
    | FOREIGN PG_DATA WRAPPER
    | PG_INDEX PG_CONCURRENTLY?
    | PG_MATERIALIZED? PG_VIEW
    | PROCEDURAL? LANGUAGE
    | PUBLICATION
    | ROLE
    | PG_SCHEMA
    | SEQUENCE
    | SERVER
    | STATISTICS
    | SUBSCRIPTION
    | TABLESPACE
    | TYPE
    | PG_TEXT SEARCH (CONFIGURATION | DICTIONARY | PARSER | TEMPLATE)
    | USER) if_exist_names_restrict_cascade
    ;

if_exist_names_restrict_cascade
    : if_exists? names_references cascade_restrict?
    ;
/*
===============================================================================
  5.2 <token and separator>

  Specifying lexical units (tokens and separators) that participate in SQL language
===============================================================================
*/

id_token
  : Identifier | QuotedIdentifier | tokens_nonkeyword;

/*
  old rule for default old identifier behavior
  includes types
*/
pg_identifier
    : id_token
    | tokens_nonreserved
    | tokens_nonreserved_except_function_type
    ;

identifier_nontype
    : id_token
    | tokens_nonreserved
    | tokens_reserved_except_function_type
    ;

col_label
    : id_token
    | tokens_reserved
    | tokens_nonreserved
    | tokens_reserved_except_function_type
    | tokens_nonreserved_except_function_type
    ;

/*
 * These rules should be generated using code in the Keyword class.
 * Word tokens that are not keywords should be added to nonreserved list.
 */
tokens_nonreserved
    : PG_ABORT
    | PG_ABSOLUTE
    | PG_ACCESS
    | ACTION
    | ADD
    | ADMIN
    | AFTER
    | AGGREGATE
    | ALSO
    | PG_ALTER
    | ALWAYS
    | ASSERTION
    | ASSIGNMENT
    | AT
    | ATTACH
    | ATTRIBUTE
    | PG_BACKWARD
    | BEFORE
    | PG_BEGIN
    | BY
    | CACHE
    | PG_CALL
    | CALLED
    | CASCADE
    | CASCADED
    | CATALOG
    | PG_CHAIN
    | CHARACTERISTICS
    | PG_CHECKPOINT
    | CLASS
    | PG_CLOSE
    | PG_CLUSTER
    | COLUMNS
    | COMMENT
    | COMMENTS
    | PG_COMMIT
    | PG_COMMITTED
    | CONFIGURATION
    | CONFLICT
    | CONNECTION
    | CONSTRAINTS
    | CONTENT
    | CONTINUE
    | CONVERSION
    | COPY
    | COST
    | CSV
    | CUBE
    | CURRENT
    | PG_CURSOR
    | CYCLE
    | PG_DATA
    | PG_DATABASE
    | DAY
    | PG_DEALLOCATE
    | PG_DECLARE
    | DEFAULTS
    | DEFERRED
    | DEFINER
    | DELETE
    | DELIMITER
    | DELIMITERS
    | DEPENDS
    | DETACH
    | DICTIONARY
    | DISABLE
    | PG_DISCARD
    | DOCUMENT
    | DOMAIN
    | DOUBLE
    | DROP
    | EACH
    | ENABLE
    | ENCODING
    | ENCRYPTED
    | ENUM
    | ESCAPE
    | EVENT
    | EXCLUDE
    | EXCLUDING
    | PG_EXCLUSIVE
    | PG_EXECUTE
    | PG_EXPLAIN
    | EXPRESSION
    | EXTENSION
    | EXTERNAL
    | FAMILY
    | FILTER
    | PG_FIRST
    | FOLLOWING
    | FORCE
    | PG_FORWARD
    | FUNCTION
    | FUNCTIONS
    | GENERATED
    | GLOBAL
    | GRANTED
    | GROUPS
    | HANDLER
    | HEADER
    | PG_HOLD
    | HOUR
    | IDENTITY
    | IF
    | IMMEDIATE
    | IMMUTABLE
    | IMPLICIT
    | IMPORT
    | INCLUDE
    | INCLUDING
    | INCREMENT
    | PG_INDEX
    | INDEXES
    | INHERIT
    | INHERITS
    | INLINE
    | INPUT
    | PG_INSENSITIVE
    | INSERT
    | INSTEAD
    | INVOKER
    | PG_ISOLATION
    | KEY
    | LABEL
    | LANGUAGE
    | LARGE
    | PG_LAST
    | LEAKPROOF
    | PG_LEVEL
    | PG_LISTEN
    | PG_LOAD
    | LOCAL
    | LOCATION
    | PG_LOCK
    | LOCKED
    | LOGGED
    | MAPPING
    | MATCH
    | PG_MATERIALIZED
    | MAXVALUE
    | METHOD
    | MINUTE
    | MINVALUE
    | PG_MODE
    | MONTH
    | PG_MOVE
    | NAME
    | NAMES
    | NEW
    | PG_NEXT
    | NFC
    | NFD
    | NFKC
    | NFKD
    | PG_NO
    | NORMALIZED
    | NOTHING
    | NOTIFY
    | PG_NOWAIT
    | NULLS
    | OBJECT
    | OF
    | PG_OFF
    | OIDS
    | OLD
    | OPERATOR
    | OPTION
    | OPTIONS
    | ORDINALITY
    | OTHERS
    | OVER
    | OVERRIDING
    | OWNED
    | OWNER
    | PG_PARALLEL
    | PARSER
    | PARTIAL
    | PARTITION
    | PASSING
    | PASSWORD
    | PG_PLANS
    | POLICY
    | PRECEDING
    | PG_PREPARE
    | PG_PREPARED
    | PRESERVE
    | PG_PRIOR
    | PRIVILEGES
    | PROCEDURAL
    | PROCEDURE
    | PROCEDURES
    | PROGRAM
    | PUBLICATION
    | QUOTE
    | RANGE
    | PG_READ
    | REASSIGN
    | RECHECK
    | RECURSIVE
    | REF
    | REFERENCING
    | PG_REFRESH
    | PG_REINDEX
    | PG_RELATIVE
    | PG_RELEASE
    | RENAME
    | PG_REPEATABLE
    | REPLACE
    | REPLICA
    | PG_RESET
    | RESTART
    | RESTRICT
    | RETURNS
    | REVOKE
    | ROLE
    | PG_ROLLBACK
    | ROLLUP
    | ROUTINE
    | ROUTINES
    | ROWS
    | RULE
    | PG_SAVEPOINT
    | PG_SCHEMA
    | SCHEMAS
    | PG_SCROLL
    | SEARCH
    | SECOND
    | SECURITY
    | SEQUENCE
    | PG_SEQUENCES
    | PG_SERIALIZABLE
    | SERVER
    | PG_SESSION
    | SET
    | SETS
    | PG_SHARE
    | PG_SHOW
    | SIMPLE
    | SKIP_
    | SNAPSHOT
    | SQL
    | STABLE
    | STANDALONE
    | PG_START
    | STATEMENT
    | STATISTICS
    | STDIN
    | STDOUT
    | STORAGE
    | STORED
    | STRICT
    | STRIP
    | SUBSCRIPTION
    | SUPPORT
    | SYSID
    | PG_SYSTEM
    | TABLES
    | TABLESPACE
    | PG_TEMP
    | TEMPLATE
    | PG_TEMPORARY
    | PG_TEXT
    | TIES
    | PG_TRANSACTION
    | TRANSFORM
    | TRIGGER
    | PG_TRUNCATE
    | TRUSTED
    | TYPE
    | TYPES
    | UESCAPE
    | UNBOUNDED
    | PG_UNCOMMITTED
    | UNENCRYPTED
    | UNKNOWN
    | PG_UNLISTEN
    | UNLOGGED
    | UNTIL
    | PG_UPDATE
    | PG_VACUUM
    | VALID
    | VALIDATE
    | VALIDATOR
    | VALUE
    | VARYING
    | VERSION
    | PG_VIEW
    | VIEWS
    | VOLATILE
    | WHITESPACE
    | WITHIN
    | PG_WITHOUT
    | PG_WORK
    | WRAPPER
    | PG_WRITE
    | PG_XML
    | YEAR
    | YES
    | PG_ZONE
    ;

tokens_nonreserved_except_function_type
    : BETWEEN
    | BIGINT
    | BIT
    | BOOLEAN
    | CHAR
    | CHARACTER
    | COALESCE
    | DEC
    | DECIMAL
    | EXISTS
    | EXTRACT
    | FLOAT
    | GREATEST
    | GROUPING
    | INOUT
    | INT
    | INTEGER
    | INTERVAL
    | LEAST
    | NATIONAL
    | NCHAR
    | NONE
    | NORMALIZE
    | NULLIF
    | NUMERIC
    | OUT
    | OVERLAY
    | POSITION
    | PRECISION
    | REAL
    | PG_ROW
    | SETOF
    | SMALLINT
    | SUBSTRING
    | PG_TIME
    | TIMESTAMP
    | TREAT
    | TRIM
    | VALUES
    | VARCHAR
    | XMLATTRIBUTES
    | XMLCONCAT
    | XMLELEMENT
    | XMLEXISTS
    | XMLFOREST
    | XMLNAMESPACES
    | XMLPARSE
    | XMLPI
    | XMLROOT
    | XMLSERIALIZE
    | XMLTABLE
    ;

tokens_reserved_except_function_type
    : PG_AUTHORIZATION
    | PG_BINARY
    | COLLATION
    | PG_CONCURRENTLY
    | CROSS
    | CURRENT_SCHEMA
    | PG_FREEZE
    | PG_FULL
    | ILIKE
    | INNER
    | IS
    | ISNULL
    | JOIN
    | LEFT
    | LIKE
    | NATURAL
    | NOTNULL
    | OUTER
    | OVERLAPS
    | RIGHT
    | SIMILAR
    | TABLESAMPLE
    | PG_VERBOSE
    ;

tokens_reserved
    : PG_ALL
    | PG_ANALYZE
    | PG_AND
    | ANY
    | ARRAY
    | PG_AS
    | ASC
    | ASYMMETRIC
    | BOTH
    | CASE
    | CAST
    | CHECK
    | COLLATE
    | COLUMN
    | CONSTRAINT
    | PG_CREATE
    | CURRENT_CATALOG
    | CURRENT_DATE
    | CURRENT_ROLE
    | CURRENT_TIME
    | CURRENT_TIMESTAMP
    | PG_CURRENT_USER
    | DEFAULT
    | PG_DEFERRABLE
    | DESC
    | DISTINCT
    | DO
    | ELSE
    | PG_END
    | EXCEPT
    | PG_FALSE
    | PG_FETCH
    | PG_FOR
    | FOREIGN
    | PG_FROM
    | GRANT
    | GROUP
    | HAVING
    | PG_IN
    | INITIALLY
    | INTERSECT
    | INTO
    | LATERAL
    | LEADING
    | LIMIT
    | LOCALTIME
    | LOCALTIMESTAMP
    | PG_NOT
    | NULL
    | OFFSET
    | PG_ON
    | PG_ONLY
    | OR
    | ORDER
    | PLACING
    | PRIMARY
    | REFERENCES
    | RETURNING
    | SELECT
    | PG_SESSION_USER
    | SOME
    | SYMMETRIC
    | PG_TABLE
    | THEN
    | TO
    | TRAILING
    | PG_TRUE
    | UNION
    | UNIQUE
    | USER
    | PG_USING
    | VARIADIC
    | WHEN
    | WHERE
    | WINDOW
    | PG_WITH
    ;

tokens_nonkeyword
    : ALIGNMENT
    | ALLOW_CONNECTIONS
    | BASETYPE
    | PG_BUFFERS
    | BYPASSRLS
    | CANONICAL
    | CATEGORY
    | COLLATABLE
    | COMBINEFUNC
    | COMMUTATOR
    | CONNECT
    | PG_COSTS
    | CREATEDB
    | CREATEROLE
    | DESERIALFUNC
    | DETERMINISTIC
    | PG_DISABLE_PAGE_SKIPPING
    | ELEMENT
    | EXTENDED
    | FINALFUNC
    | FINALFUNC_EXTRA
    | FINALFUNC_MODIFY
    | FORCE_NOT_NULL
    | FORCE_NULL
    | FORCE_QUOTE
    | PG_FORMAT
    | GETTOKEN
    | HASH
    | HASHES
    | HEADLINE
    | HYPOTHETICAL
    | PG_INDEX_CLEANUP
    | INIT
    | INITCOND
    | INTERNALLENGTH
    | IS_TEMPLATE
    | PG_JSON
    | LC_COLLATE
    | LC_CTYPE
    | LEFTARG
    | LEXIZE
    | LEXTYPES
    | LIST
    | LOCALE
    | LOGIN
    | MAIN
    | MERGES
    | MFINALFUNC
    | MFINALFUNC_EXTRA
    | MFINALFUNC_MODIFY
    | MINITCOND
    | MINVFUNC
    | MODULUS
    | MSFUNC
    | MSSPACE
    | MSTYPE
    | NEGATOR
    | NOBYPASSRLS
    | NOCREATEDB
    | NOCREATEROLE
    | NOINHERIT
    | NOLOGIN
    | NOREPLICATION
    | NOSUPERUSER
    | OUTPUT
    | PASSEDBYVALUE
    | PATH
    | PERMISSIVE
    | PLAIN
    | PREFERRED
    | PROVIDER
    | READ_ONLY
    | READ_WRITE
    | RECEIVE
    | REMAINDER
    | REPLICATION
    | RESTRICTED
    | RESTRICTIVE
    | RIGHTARG
    | SAFE
    | SEND
    | SERIALFUNC
    | PG_SETTINGS
    | SFUNC
    | SHAREABLE
    | PG_SKIP_LOCKED
    | SORTOP
    | SSPACE
    | STYPE
    | SUBTYPE_DIFF
    | SUBTYPE_OPCLASS
    | SUBTYPE
    | PG_SUMMARY
    | SUPERUSER
    | PG_TIMING
    | TYPMOD_IN
    | TYPMOD_OUT
    | UNSAFE
    | USAGE
    | VARIABLE
    | PG_WAL
    | PG_YAML

    // plpgsql tokens
    | ALIAS
    | ASSERT
    | CONSTANT
    | DATATYPE
    | DEBUG
    | DETAIL
    | DIAGNOSTICS
    | ELSEIF
    | ELSIF
    | ERRCODE
    | EXIT
    | EXCEPTION
    | FOREACH
    | GET
    | HINT
    | INFO
    | LOG
    | LOOP
    | MESSAGE
    | NOTICE
    | OPEN
    | PERFORM
    | QUERY
    | RAISE
    | RECORD
    | RETURN
    | REVERSE
    | ROWTYPE
    | SLICE
    | SQLSTATE
    | STACKED
    | WARNING
    | WHILE
    ;

/*
===============================================================================
  6.1 <data types>
===============================================================================
*/

schema_qualified_name_nontype
    : identifier_nontype
    | schema=pg_identifier PG_DOT identifier_nontype
    ;

type_list
    : pg_data_type (PG_COMMA pg_data_type)*
    ;

pg_data_type
    : SETOF? predefined_type (ARRAY array_type? | array_type+)?
    ;

array_type
    : LEFT_BRACKET PG_NUMBER_LITERAL? RIGHT_BRACKET
    ;

predefined_type
    : BIGINT
    | BIT VARYING? type_length?
    | BOOLEAN
    | DEC precision_param?
    | DECIMAL precision_param?
    | DOUBLE PRECISION
    | FLOAT precision_param?
    | INT
    | INTEGER
    | INTERVAL interval_field? type_length?
    | NATIONAL? (CHARACTER | CHAR) VARYING? type_length?
    | NCHAR VARYING? type_length?
    | NUMERIC precision_param?
    | REAL
    | SMALLINT
    | PG_TIME type_length? ((PG_WITH | PG_WITHOUT) PG_TIME PG_ZONE)?
    | TIMESTAMP type_length? ((PG_WITH | PG_WITHOUT) PG_TIME PG_ZONE)?
    | VARCHAR type_length?
    | schema_qualified_name_nontype (PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN)?
    ;

interval_field
    : YEAR
    | MONTH
    | DAY
    | HOUR
    | MINUTE
    | SECOND
    | YEAR TO MONTH
    | DAY TO HOUR
    | DAY TO MINUTE
    | DAY TO SECOND
    | HOUR TO MINUTE
    | HOUR TO SECOND
    | MINUTE TO SECOND
    ;

type_length
    : PG_LEFT_PAREN PG_NUMBER_LITERAL PG_RIGHT_PAREN
    ;

precision_param
    : PG_LEFT_PAREN precision=PG_NUMBER_LITERAL (PG_COMMA scale=PG_NUMBER_LITERAL)? PG_RIGHT_PAREN
    ;

/*
===============================================================================
  6.25 <value expression>
===============================================================================
*/

pg_vex
  : pg_vex CAST_EXPRESSION pg_data_type
  | PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN indirection_list?
  | PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)+ PG_RIGHT_PAREN
  | pg_vex collate_identifier
  | <assoc=right> (PLUS | MINUS) pg_vex
  | pg_vex AT PG_TIME PG_ZONE pg_vex
  | pg_vex EXP pg_vex
  | pg_vex (PG_MULTIPLY | DIVIDE | MODULAR) pg_vex
  | pg_vex (PLUS | MINUS) pg_vex
  // TODO a lot of ambiguities between 3 next alternatives
  | pg_vex op pg_vex
  | op pg_vex
  | pg_vex op
  | pg_vex PG_NOT? PG_IN PG_LEFT_PAREN (select_stmt_no_parens | pg_vex (PG_COMMA pg_vex)*) PG_RIGHT_PAREN
  | pg_vex PG_NOT? BETWEEN (ASYMMETRIC | SYMMETRIC)? vex_b PG_AND pg_vex
  | pg_vex PG_NOT? (LIKE | ILIKE | SIMILAR TO) pg_vex
  | pg_vex PG_NOT? (LIKE | ILIKE | SIMILAR TO) pg_vex ESCAPE pg_vex
  | pg_vex (LTH | GTH | LEQ | GEQ | EQUAL | NOT_EQUAL) pg_vex
  | pg_vex IS PG_NOT? (truth_value | NULL)
  | pg_vex IS PG_NOT? DISTINCT PG_FROM pg_vex
  | pg_vex IS PG_NOT? DOCUMENT
  | pg_vex IS PG_NOT? UNKNOWN
  | pg_vex IS PG_NOT? OF PG_LEFT_PAREN type_list PG_RIGHT_PAREN
  | pg_vex ISNULL
  | pg_vex NOTNULL
  | <assoc=right> PG_NOT pg_vex
  | pg_vex PG_AND pg_vex
  | pg_vex OR pg_vex
  | value_expression_primary
  ;

// partial copy of vex
// resolves (vex BETWEEN vex AND vex) vs. (vex AND vex) ambiguity
// vex references that are not at alternative edge are referencing the full rule
// see postgres' b_expr (src/backend/parser/gram.y)
vex_b
  : vex_b CAST_EXPRESSION pg_data_type
  | PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN indirection_list?
  | PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)+ PG_RIGHT_PAREN
  | <assoc=right> (PLUS | MINUS) vex_b
  | vex_b EXP vex_b
  | vex_b (PG_MULTIPLY | DIVIDE | MODULAR) vex_b
  | vex_b (PLUS | MINUS) vex_b
  | vex_b op vex_b
  | op vex_b
  | vex_b op
  | vex_b (LTH | GTH | LEQ | GEQ | EQUAL | NOT_EQUAL) vex_b
  | vex_b IS PG_NOT? DISTINCT PG_FROM vex_b
  | vex_b IS PG_NOT? DOCUMENT
  | vex_b IS PG_NOT? UNKNOWN
  | vex_b IS PG_NOT? OF PG_LEFT_PAREN type_list PG_RIGHT_PAREN
  | value_expression_primary
  ;

op
  : op_chars
  | OPERATOR PG_LEFT_PAREN pg_identifier PG_DOT all_simple_op PG_RIGHT_PAREN
  ;

all_op_ref
  : all_simple_op
  | OPERATOR PG_LEFT_PAREN pg_identifier PG_DOT all_simple_op PG_RIGHT_PAREN
  ;

datetime_overlaps
  : PG_LEFT_PAREN pg_vex PG_COMMA pg_vex PG_RIGHT_PAREN OVERLAPS PG_LEFT_PAREN pg_vex PG_COMMA pg_vex PG_RIGHT_PAREN
  ;

value_expression_primary
  : unsigned_value_specification
  | PG_LEFT_PAREN select_stmt_no_parens PG_RIGHT_PAREN indirection_list?
  | case_expression
  | NULL
  | PG_MULTIPLY
  // technically incorrect since ANY cannot be value expression
  // but fixing this would require to write a vex rule duplicating all operators
  // like vex (op|op|op|...) comparison_mod
  | comparison_mod
  | EXISTS table_subquery
  | pg_function_call
  | indirection_var
  | array_expression
  | type_coercion
  | datetime_overlaps
  ;

unsigned_value_specification
  : unsigned_numeric_literal
  | pg_character_string
  | truth_value
  ;

unsigned_numeric_literal
  : PG_NUMBER_LITERAL
  | REAL_NUMBER
  ;

truth_value
  : PG_TRUE | PG_FALSE | PG_ON // on is reserved but is required by SET statements
  ;

case_expression
  : CASE pg_vex? (WHEN pg_vex THEN r+=pg_vex)+ (ELSE r+=pg_vex)? PG_END
  ;

cast_specification
  : (CAST | TREAT) PG_LEFT_PAREN pg_vex PG_AS pg_data_type PG_RIGHT_PAREN
  ;

// using data_type for function name because keyword-named functions
// use the same category of keywords as keyword-named types
pg_function_call
    : schema_qualified_name_nontype PG_LEFT_PAREN (set_qualifier? vex_or_named_notation (PG_COMMA vex_or_named_notation)* orderby_clause?)? PG_RIGHT_PAREN
        (WITHIN GROUP PG_LEFT_PAREN orderby_clause PG_RIGHT_PAREN)?
        filter_clause? (OVER (pg_identifier | window_definition))?
    | function_construct
    | extract_function
    | system_function
    | date_time_function
    | string_value_function
    | xml_function
    ;

vex_or_named_notation
    : VARIADIC? (argname=pg_identifier pointer)? pg_vex
    ;

pointer
    : EQUAL_GTH | COLON_EQUAL
    ;

function_construct
    : (COALESCE | GREATEST | GROUPING | LEAST | NULLIF | XMLCONCAT) PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN
    | PG_ROW PG_LEFT_PAREN (pg_vex (PG_COMMA pg_vex)*)? PG_RIGHT_PAREN
    ;

extract_function
    : EXTRACT PG_LEFT_PAREN (pg_identifier | pg_character_string) PG_FROM pg_vex PG_RIGHT_PAREN
    ;

system_function
    : CURRENT_CATALOG
    // parens are handled by generic function call
    // since current_schema is defined as reserved(can be function) keyword
    | CURRENT_SCHEMA /*(LEFT_PAREN RIGHT_PAREN)?*/
    | PG_CURRENT_USER
    | PG_SESSION_USER
    | USER
    | cast_specification
    ;

date_time_function
    : CURRENT_DATE
    | CURRENT_TIME type_length?
    | CURRENT_TIMESTAMP type_length?
    | LOCALTIME type_length?
    | LOCALTIMESTAMP type_length?
    ;

string_value_function
    : TRIM PG_LEFT_PAREN (LEADING | TRAILING | BOTH)? (chars=pg_vex PG_FROM str=pg_vex | PG_FROM? str=pg_vex (PG_COMMA chars=pg_vex)?) PG_RIGHT_PAREN
    | SUBSTRING PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* (PG_FROM pg_vex)? (PG_FOR pg_vex)? PG_RIGHT_PAREN
    | POSITION PG_LEFT_PAREN vex_b PG_IN pg_vex PG_RIGHT_PAREN
    | OVERLAY PG_LEFT_PAREN pg_vex PLACING pg_vex PG_FROM pg_vex (PG_FOR pg_vex)? PG_RIGHT_PAREN
    | COLLATION PG_FOR PG_LEFT_PAREN pg_vex PG_RIGHT_PAREN
    ;

xml_function
    : XMLELEMENT PG_LEFT_PAREN NAME name=pg_identifier
        (PG_COMMA XMLATTRIBUTES PG_LEFT_PAREN pg_vex (PG_AS attname=pg_identifier)? (PG_COMMA pg_vex (PG_AS attname=pg_identifier)?)* PG_RIGHT_PAREN)?
        (PG_COMMA pg_vex)* PG_RIGHT_PAREN
    | XMLFOREST PG_LEFT_PAREN pg_vex (PG_AS name=pg_identifier)? (PG_COMMA pg_vex (PG_AS name=pg_identifier)?)* PG_RIGHT_PAREN
    | XMLPI PG_LEFT_PAREN NAME name=pg_identifier (PG_COMMA pg_vex)? PG_RIGHT_PAREN
    | XMLROOT PG_LEFT_PAREN pg_vex PG_COMMA VERSION (pg_vex | PG_NO VALUE) (PG_COMMA STANDALONE (YES | PG_NO | PG_NO VALUE))? PG_RIGHT_PAREN
    | XMLEXISTS PG_LEFT_PAREN pg_vex PASSING (BY REF)? pg_vex (BY REF)? PG_RIGHT_PAREN
    | XMLPARSE PG_LEFT_PAREN (DOCUMENT | CONTENT) pg_vex PG_RIGHT_PAREN
    | XMLSERIALIZE PG_LEFT_PAREN (DOCUMENT | CONTENT) pg_vex PG_AS pg_data_type PG_RIGHT_PAREN
    | XMLTABLE PG_LEFT_PAREN
        (XMLNAMESPACES PG_LEFT_PAREN pg_vex PG_AS name=pg_identifier (PG_COMMA pg_vex PG_AS name=pg_identifier)* PG_RIGHT_PAREN PG_COMMA)?
        pg_vex PASSING (BY REF)? pg_vex (BY REF)?
        COLUMNS xml_table_column (PG_COMMA xml_table_column)*
        PG_RIGHT_PAREN
    ;

xml_table_column
    : name=pg_identifier (pg_data_type (PATH pg_vex)? (DEFAULT pg_vex)? (PG_NOT? NULL)? | PG_FOR ORDINALITY)
    ;

comparison_mod
    : (PG_ALL | ANY | SOME) PG_LEFT_PAREN (pg_vex | select_stmt_no_parens) PG_RIGHT_PAREN
    ;

filter_clause
    : FILTER PG_LEFT_PAREN WHERE pg_vex PG_RIGHT_PAREN
    ;

window_definition
    : PG_LEFT_PAREN pg_identifier? partition_by_columns? orderby_clause? frame_clause? PG_RIGHT_PAREN
    ;

frame_clause
    : (RANGE | ROWS | GROUPS) (frame_bound | BETWEEN frame_bound PG_AND frame_bound)
    (EXCLUDE (CURRENT PG_ROW | GROUP | TIES | PG_NO OTHERS))?
    ;

frame_bound
    : pg_vex (PRECEDING | FOLLOWING)
    | CURRENT PG_ROW
    ;

array_expression
    : ARRAY (array_elements | table_subquery)
    ;

array_elements
    : LEFT_BRACKET ((pg_vex | array_elements) (PG_COMMA (pg_vex | array_elements))*)? RIGHT_BRACKET
    ;

type_coercion
    : pg_data_type pg_character_string
    | INTERVAL pg_character_string interval_field type_length?
    ;

/*
===============================================================================
  7.13 <query expression>
===============================================================================
*/
pg_schema_qualified_name
    : pg_identifier ( PG_DOT pg_identifier ( PG_DOT pg_identifier )? )?
    ;

set_qualifier
    : DISTINCT | PG_ALL
    ;

table_subquery
    : PG_LEFT_PAREN pg_select_stmt PG_RIGHT_PAREN
    ;

pg_select_stmt
    : with_clause? select_ops after_ops*
    ;

after_ops
    : orderby_clause
    | LIMIT (pg_vex | PG_ALL)
    | OFFSET pg_vex (PG_ROW | ROWS)?
    | PG_FETCH (PG_FIRST | PG_NEXT) pg_vex? (PG_ROW | ROWS) (PG_ONLY | PG_WITH TIES)?
    | PG_FOR (PG_UPDATE | PG_NO KEY PG_UPDATE | PG_SHARE | KEY PG_SHARE) (OF pg_schema_qualified_name (PG_COMMA pg_schema_qualified_name)*)? (PG_NOWAIT | SKIP_ LOCKED)?
    ;

// select_stmt copy that doesn't consume external parens
// for use in vex
// we let the vex rule to consume as many parens as it can
select_stmt_no_parens
    : with_clause? select_ops_no_parens after_ops*
    ;

with_clause
    : PG_WITH RECURSIVE? with_query (PG_COMMA with_query)*
    ;

with_query
    : query_name=pg_identifier (PG_LEFT_PAREN column_name+=pg_identifier (PG_COMMA column_name+=pg_identifier)* PG_RIGHT_PAREN)?
    PG_AS (PG_NOT? PG_MATERIALIZED)? PG_LEFT_PAREN pg_data_statement PG_RIGHT_PAREN
    ;

select_ops
    : PG_LEFT_PAREN pg_select_stmt PG_RIGHT_PAREN // parens can be used to apply "global" clauses (WITH etc) to a particular select in UNION expr
    | select_ops (INTERSECT | UNION | EXCEPT) set_qualifier? select_ops
    | select_primary
    ;

// version of select_ops for use in select_stmt_no_parens
select_ops_no_parens
    : select_ops (INTERSECT | UNION | EXCEPT) set_qualifier? (select_primary | PG_LEFT_PAREN pg_select_stmt PG_RIGHT_PAREN)
    | select_primary
    ;

select_primary
    : SELECT
        (set_qualifier (PG_ON PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN)?)?
        select_list? into_table?
        (PG_FROM from_item (PG_COMMA from_item)*)?
        (WHERE pg_vex)?
        groupby_clause?
        (HAVING pg_vex)?
        (WINDOW pg_identifier PG_AS window_definition (PG_COMMA pg_identifier PG_AS window_definition)*)?
    | PG_TABLE PG_ONLY? pg_schema_qualified_name PG_MULTIPLY?
    | values_stmt
    ;

select_list
  : select_sublist (PG_COMMA select_sublist)*
  ;

select_sublist
  : pg_vex (PG_AS col_label | id_token)?
  ;

into_table
    : INTO (PG_TEMPORARY | PG_TEMP | UNLOGGED)? PG_TABLE? pg_schema_qualified_name
    ;

from_item
    : PG_LEFT_PAREN from_item PG_RIGHT_PAREN alias_clause?
    | from_item CROSS JOIN from_item
    | from_item (INNER | (LEFT | RIGHT | PG_FULL) OUTER?)? JOIN from_item PG_ON pg_vex
    | from_item (INNER | (LEFT | RIGHT | PG_FULL) OUTER?)? JOIN from_item PG_USING names_in_parens
    | from_item NATURAL (INNER | (LEFT | RIGHT | PG_FULL) OUTER?)? JOIN from_item
    | from_primary
    ;

from_primary
    : PG_ONLY? pg_schema_qualified_name PG_MULTIPLY? alias_clause? (TABLESAMPLE method=pg_identifier PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN (PG_REPEATABLE pg_vex)?)?
    | LATERAL? table_subquery alias_clause
    | LATERAL? pg_function_call (PG_WITH ORDINALITY)?
        (PG_AS from_function_column_def
        | PG_AS? alias=pg_identifier (PG_LEFT_PAREN column_alias+=pg_identifier (PG_COMMA column_alias+=pg_identifier)* PG_RIGHT_PAREN | from_function_column_def)?
        )?
    | LATERAL? ROWS PG_FROM PG_LEFT_PAREN pg_function_call (PG_AS from_function_column_def)? (PG_COMMA pg_function_call (PG_AS from_function_column_def)?)* PG_RIGHT_PAREN
    (PG_WITH ORDINALITY)? (PG_AS? pg_identifier (PG_LEFT_PAREN pg_identifier (PG_COMMA pg_identifier)* PG_RIGHT_PAREN)?)?
    ;

alias_clause
    : PG_AS? alias=pg_identifier (PG_LEFT_PAREN column_alias+=pg_identifier (PG_COMMA column_alias+=pg_identifier)* PG_RIGHT_PAREN)?
    ;

from_function_column_def
    : PG_LEFT_PAREN column_alias+=pg_identifier pg_data_type (PG_COMMA column_alias+=pg_identifier pg_data_type)* PG_RIGHT_PAREN
    ;

groupby_clause
  : GROUP BY grouping_element_list
  ;

grouping_element_list
  : grouping_element (PG_COMMA grouping_element)*
  ;

grouping_element
  : pg_vex
  | PG_LEFT_PAREN PG_RIGHT_PAREN
  | (ROLLUP | CUBE | GROUPING SETS) PG_LEFT_PAREN grouping_element_list PG_RIGHT_PAREN
  ;

values_stmt
    : VALUES values_values (PG_COMMA values_values)*
    ;

values_values
    : PG_LEFT_PAREN (pg_vex | DEFAULT) (PG_COMMA (pg_vex | DEFAULT))* PG_RIGHT_PAREN
    ;

orderby_clause
    : ORDER BY sort_specifier (PG_COMMA sort_specifier)*
    ;

sort_specifier
    : pg_vex order_specification? null_ordering?
    ;

order_specification
    : ASC | DESC | PG_USING all_op_ref
    ;

null_ordering
    : NULLS (PG_FIRST | PG_LAST)
    ;

pg_insert_stmt_for_psql
    : with_clause? INSERT INTO insert_table_name=pg_schema_qualified_name (PG_AS alias=pg_identifier)?
    (OVERRIDING (PG_SYSTEM | USER) VALUE)? insert_columns?
    (pg_select_stmt | DEFAULT VALUES)
    (PG_ON CONFLICT conflict_object? conflict_action)?
    (RETURNING select_list)?
    ;

insert_columns
    : PG_LEFT_PAREN indirection_identifier (PG_COMMA indirection_identifier)* PG_RIGHT_PAREN
    ;

indirection_identifier
    : pg_identifier indirection_list?
    ;

conflict_object
    : index_sort index_where?
    | PG_ON CONSTRAINT pg_identifier
    ;

conflict_action
    : DO NOTHING
    | DO PG_UPDATE SET update_set (PG_COMMA update_set)* (WHERE pg_vex)?
    ;

pg_delete_stmt_for_psql
    : with_clause? DELETE PG_FROM PG_ONLY? delete_table_name=pg_schema_qualified_name PG_MULTIPLY? (PG_AS? alias=pg_identifier)?
    (PG_USING from_item (PG_COMMA from_item)*)?
    (WHERE (pg_vex | CURRENT OF cursor=pg_identifier))?
    (RETURNING select_list)?
    ;

pg_update_stmt_for_psql
    : with_clause? PG_UPDATE PG_ONLY? update_table_name=pg_schema_qualified_name PG_MULTIPLY? (PG_AS? alias=pg_identifier)?
    SET update_set (PG_COMMA update_set)*
    (PG_FROM from_item (PG_COMMA from_item)*)?
    (WHERE (pg_vex | CURRENT OF cursor=pg_identifier))?
    (RETURNING select_list)?
    ;

update_set
    : column+=indirection_identifier EQUAL (value+=pg_vex | DEFAULT)
    | PG_LEFT_PAREN column+=indirection_identifier (PG_COMMA column+=indirection_identifier)* PG_RIGHT_PAREN EQUAL PG_ROW?
    (PG_LEFT_PAREN (value+=pg_vex | DEFAULT) (PG_COMMA (value+=pg_vex | DEFAULT))* PG_RIGHT_PAREN | table_subquery)
    ;

pg_notify_stmt
    : NOTIFY channel=pg_identifier (PG_COMMA payload=pg_character_string)?
    ;

pg_truncate_stmt
    : PG_TRUNCATE PG_TABLE? pg_only_table_multiply (PG_COMMA pg_only_table_multiply)*
    ((RESTART | CONTINUE) IDENTITY)? cascade_restrict?
    ;

identifier_list
    : pg_identifier (PG_COMMA pg_identifier)*
    ;

pg_anonymous_block
    : DO (LANGUAGE (pg_identifier | pg_character_string))? pg_character_string
    | DO pg_character_string LANGUAGE (pg_identifier | pg_character_string)
    ;

// plpgsql rules

comp_options
    : HASH_SIGN pg_identifier (pg_identifier | truth_value)
    ;

function_block
    : start_label? declarations?
    PG_BEGIN function_statements exception_statement?
    PG_END end_label=pg_identifier?
    ;

start_label
    : LESS_LESS col_label GREATER_GREATER
    ;

declarations
    : PG_DECLARE declaration*
    ;

declaration
    : PG_DECLARE* pg_identifier type_declaration SEMI_COLON
    ;

type_declaration
    : CONSTANT? data_type_dec collate_identifier? (PG_NOT NULL)? ((DEFAULT | COLON_EQUAL | EQUAL) pg_vex)?
    | ALIAS PG_FOR (pg_identifier | DOLLAR_NUMBER)
    | (PG_NO? PG_SCROLL)? PG_CURSOR (PG_LEFT_PAREN arguments_list PG_RIGHT_PAREN)? (PG_FOR | IS) pg_select_stmt
    ;

arguments_list
    : pg_identifier pg_data_type (PG_COMMA pg_identifier pg_data_type)*
    ;

data_type_dec
    : pg_data_type
    | pg_schema_qualified_name MODULAR TYPE
    | schema_qualified_name_nontype MODULAR ROWTYPE
    ;

exception_statement
    : EXCEPTION (WHEN pg_vex THEN function_statements)+
    ;

function_statements
    : (function_statement SEMI_COLON)*
    ;

function_statement
    : function_block
    | base_statement
    | control_statement
    | transaction_statement
    | cursor_statement
    | message_statement
    | pg_schema_statement
    | plpgsql_query
    | pg_additional_statement
    ;

base_statement
    : assign_stmt
    | PERFORM perform_stmt
    | GET (CURRENT | STACKED)? DIAGNOSTICS diagnostic_option (PG_COMMA diagnostic_option)*
    | NULL
    ;

pg_var
    : (pg_schema_qualified_name | DOLLAR_NUMBER) (LEFT_BRACKET pg_vex RIGHT_BRACKET)*
    ;

diagnostic_option
    : pg_var (COLON_EQUAL | EQUAL) pg_identifier
    ;

// keep this in sync with select_primary (except intended differences)
perform_stmt
    : (set_qualifier (PG_ON PG_LEFT_PAREN pg_vex (PG_COMMA pg_vex)* PG_RIGHT_PAREN)?)?
    select_list
    (PG_FROM from_item (PG_COMMA from_item)*)?
    (WHERE pg_vex)?
    groupby_clause?
    (HAVING pg_vex)?
    (WINDOW pg_identifier PG_AS window_definition (PG_COMMA pg_identifier PG_AS window_definition)*)?
    ((INTERSECT | UNION | EXCEPT) set_qualifier? select_ops)?
    after_ops*
    ;

assign_stmt
    : pg_var (COLON_EQUAL | EQUAL) (select_stmt_no_parens | perform_stmt)
    ;

execute_stmt
    : PG_EXECUTE pg_vex using_vex?
    ;

control_statement
    : return_stmt
    | PG_CALL pg_function_call
    | if_statement
    | case_statement
    | loop_statement
    ;

cursor_statement
    : OPEN pg_var (PG_NO? PG_SCROLL)? PG_FOR plpgsql_query
    | OPEN pg_var (PG_LEFT_PAREN option (PG_COMMA option)* PG_RIGHT_PAREN)?
    | PG_FETCH pg_fetch_move_direction? (PG_FROM | PG_IN)? pg_var
    | PG_MOVE pg_fetch_move_direction? (PG_FROM | PG_IN)? pg_var
    | PG_CLOSE pg_var
    ;

option
    : (pg_identifier COLON_EQUAL)? pg_vex
    ;

transaction_statement
    : (PG_COMMIT | PG_ROLLBACK) (PG_AND PG_NO? PG_CHAIN)?
    | pg_lock_table
    ;

message_statement
    : RAISE log_level? (pg_character_string (PG_COMMA pg_vex)*)? raise_using?
    | RAISE log_level? pg_identifier raise_using?
    | RAISE log_level? SQLSTATE pg_character_string raise_using?
    | ASSERT pg_vex (PG_COMMA pg_vex)?
    ;

log_level
    : DEBUG
    | LOG
    | INFO
    | NOTICE
    | WARNING
    | EXCEPTION
    ;

raise_using
    : PG_USING raise_param EQUAL pg_vex (PG_COMMA raise_param EQUAL pg_vex)*
    ;

raise_param
    : MESSAGE
    | DETAIL
    | HINT
    | ERRCODE
    | COLUMN
    | CONSTRAINT
    | DATATYPE
    | PG_TABLE
    | PG_SCHEMA
    ;

return_stmt
    : RETURN perform_stmt?
    | RETURN PG_NEXT pg_vex
    | RETURN QUERY plpgsql_query
    ;

loop_statement
    : start_label? loop_start? LOOP function_statements PG_END LOOP pg_identifier?
    | (EXIT | CONTINUE) col_label? (WHEN pg_vex)?
    ;

loop_start
    : WHILE pg_vex
    | PG_FOR alias=pg_identifier PG_IN REVERSE? pg_vex DOUBLE_DOT pg_vex (BY pg_vex)?
    | PG_FOR identifier_list PG_IN plpgsql_query
    | PG_FOR cursor=pg_identifier PG_IN pg_identifier (PG_LEFT_PAREN option (PG_COMMA option)* PG_RIGHT_PAREN)? // cursor loop
    | FOREACH identifier_list (SLICE PG_NUMBER_LITERAL)? PG_IN ARRAY pg_vex
    ;

using_vex
    : PG_USING pg_vex (PG_COMMA pg_vex)*
    ;

if_statement
    : IF pg_vex THEN function_statements ((ELSIF | ELSEIF) pg_vex THEN function_statements)* (ELSE function_statements)? PG_END IF
    ;

// plpgsql case
case_statement
    : CASE pg_vex? (WHEN pg_vex (PG_COMMA pg_vex)* THEN function_statements)+ (ELSE function_statements)? PG_END CASE
    ;

plpgsql_query
    : pg_data_statement
    | execute_stmt
    | pg_show_statement
    | pg_explain_statement
    ;
