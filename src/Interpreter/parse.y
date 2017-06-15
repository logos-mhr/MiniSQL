%require "3.0.4"

%{ /* -*- C++ -*- */

/*
 *
 */

#include <iostream>
#include <string>
#include <cstdlib>
#include <memory>

#include "parser_public.h"
#include "y.tab.h"

%}

%token
    RW_CREATE
    RW_DROP
    RW_TABLE
    RW_INDEX
    RW_SELECT
    RW_FROM
    RW_WHERE
    RW_INSERT
    RW_DELETE
    RW_UPDATE
    RW_AND
    RW_INTO
    RW_VALUES

    RW_SET
    RW_EXIT

    RW_TEST

    T_LT
    T_GT
    T_GE
    T_LE
    T_EQ
    T_NE

    T_EOF

    NO_TOKEN

%token <i> T_INT
%token <r> T_REAL
%token <str> T_STRING
%token <str> T_QSTRING

%type <str> T_ASTRING

%type <op> operator

%type <val> value

%type <cond> condition

%type <dummy> top_stmt
    test
    exit
    dml
    insert

%token
    ddl
    query
    delete_op
    update
    create_table
    create_index
    drop_table
    drop_index

%%

top_input: top_stmt ';' { YYACCEPT; };

top_stmt: exit
    | test
    | dml
    ;

dml:
     insert
    ;

insert: RW_INSERT RW_INTO T_STRING RW_VALUES '(' T_ASTRING ')'
    {
        std::cout << $6 << std::endl;
    }
    ;

condition: T_STRING operator value
    {
        $$.name = $1;
        $$.op = $2;
        $$.val = $3;
    }
    ;

value:
    T_INT { $$.type = SqlValueType.Integer; $$.i = $1; }
    | T_REAL { $$.type = SqlValueType.Float; $$.r = $1; }
    | T_INT { $$.type = SqlValueType.String; $$.str = $1; }
    ;

operator:
    T_LT { $$ = Operator.LT_OP; }
    | T_LE { $$ = Operator.LE_OP; }
    | T_GT { $$ = Operator.GT_OP; }
    | T_GE { $$ = Operator.GE_OP; }
    | T_EQ { $$ = Operator.EQ_OP; }
    | T_NE { $$ = Operator.NE_OP; }
    ;

T_ASTRING: T_QSTRING | T_STRING;

exit: RW_EXIT { isExit = true; };

test: RW_TEST { std::cerr << "RW_TEST is input\n"; };

%%

bool bFlag; /* no meanings. */

