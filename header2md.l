/* @BAKE
    flex -o $*.yy.c $@
    gcc -o $*.out $*.yy.c
   @STOP
*/
%{
    #include <stdio.h>
    // XXX: as of now, flex does not compile under C23
    #include <stdbool.h>

    #define ECHOS(s) do {                            \
        const char * const  ss = s;                  \
        fwrite(ss, strlen(ss), sizeof(char), yyout); \
    } while (0)
    #define ECHOC(c) fputc(c, yyout)

    // We would like to prevent ``` being added to the top of our file.
    bool is_start_of_file = true;
    #define START_CODE_BLOCK do { ECHOS("\n```C\n"); }  while (0)
    #define END_CODE_BLOCK   do {\
            if (!is_start_of_file) {\
                ECHOS("\n```\n\n");\
            } else {\
                is_start_of_file = false;\
            }\
        } while (0)
%}

ws      [ \t\r\v\f]
margin  ^{ws}*\*{ws}*/[^\/]
%x IN_COMMENT IN_MULTILINE_COMMENT IN_OMIT
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
\\\n                { // K&R multiline comment
                        ECHOC('\n');
                    }
\@OMIT              {
                        BEGIN IN_OMIT;
                    }
\n+                 {
                        START_CODE_BLOCK;
                        BEGIN INITIAL;
                    }
}

<IN_MULTILINE_COMMENT>{
^{ws}*              { ; }
{margin}            { ; }
\*\/\n*             {
                        START_CODE_BLOCK;
                        BEGIN INITIAL;
                    }
\@OMIT              {
                        BEGIN IN_OMIT;
                    }
.|\n                {
                        ECHO;
                    }
}

<IN_OMIT>{
.|\n    { ; }
\/\/    {
            BEGIN IN_COMMENT;
        }
\/\*    {
            BEGIN IN_MULTILINE_COMMENT;
        }
}

%%

void usage(void) {
    puts(
        "header2md <file>\n"
        "    Convert C source file to markdown and print to stdout."
    );
}

signed main(int argc, char * argv[]) {
    if (argc < 2) {
        usage();
        return 1;
    }

    if (!strcmp(argv[1], "-h")
    ||  !strcmp(argv[1], "--help")) {
        usage();
        return 0;
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
