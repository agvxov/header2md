/* @BAKE
    flex -o $*.yy.c $@
    gcc -o $*.out $*.yy.c
    ./$*.out test.h
   @STOP
*/
%{
    #include <stdio.h>
    #include <stdbool.h>

    #define ECHOS(s) do {                            \
        const char * const  ss = s;                  \
        fwrite(ss, strlen(ss), sizeof(char), yyout); \
    } while (0)
    #define ECHOC(c) fputc(c, yyout)

    #define START_CODE_BLOCK do { ECHOS("\n```C\n"); }  while (0)
    #define END_CODE_BLOCK   do {\
            if (!is_start_of_file) {\
                ECHOS("\n```\n\n");\
            } else {\
                is_start_of_file = false;\
            }\
        } while (0)

    bool is_start_of_file = true;
%}

ws    [ \t\r\v\f]
%x IN_COMMENT IN_MULTILINE_COMMENT OMMIT
%option noyywrap nodefault

%%

<INITIAL>{
^{ws}*              { ; }
\n*\/\/{ws}*        {
                        END_CODE_BLOCK;
                        BEGIN IN_COMMENT;
                        
                    }
\n*\/\*{ws}*        {
                        END_CODE_BLOCK;
                        BEGIN IN_MULTILINE_COMMENT;
                    }
\n\n+               {
                        ECHOS("\n\n");
                    }
.|\n                {
                        ECHO;
                    }
<<EOF>>             {
                        END_CODE_BLOCK;
                        return 0;
                    }
}

<IN_COMMENT>{
^{ws}*              { ; }
.                   {
                        ECHO;
                    }
\\\n                {
                        ECHOC('\n');
                    }
\@OMMIT             {
                        BEGIN OMMIT;
                    }
\n+                 {
                        START_CODE_BLOCK;
                        BEGIN INITIAL;
                    }
}

<IN_MULTILINE_COMMENT>{
^{ws}*              { ; }
^{ws}*\*{ws}*[^\/]  { ; }
\*\/\n*             {
                        START_CODE_BLOCK;
                        BEGIN INITIAL;
                    }
\@OMMIT             {
                        BEGIN OMMIT;
                    }
.|\n                {
                        ECHO;
                    }
}

<OMMIT>{
.|\n    { ; }
\/\/    {
            BEGIN IN_COMMENT;
        }
\/\*    {
            BEGIN IN_MULTILINE_COMMENT;
        }
}

%%

signed main(int argc, char * argv[]) {
    if (argc < 2) {
        puts("header2md <file>");
        return 1;
    }
    yyin = fopen(argv[1], "r");
    if (!yyin) {
        printf("Failed to open '%s'.", argv[1]);
        return 1;
    }

    yylex();

    fclose(yyin);
    yylex_destroy();

    return 0;
}
