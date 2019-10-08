#include <stdio.h>
#include <stdlib.h>


#include "s7.h"
#include "repl-s7.h"

static char *progname = NULL;
static const char *version = "v0.0.1";
static const char *base_scm_lib[] = {
    "repl.scm",
    "cload.scm",
    NULL
};
static bool is_quiet = false;
static bool is_batch = false;

static void dohelp(const int exit_code) {
    fprintf(stdout, "%s [-h|-v|-q]\n", progname);
    fprintf(stdout, "  -h: show this text and exits\n");
    fprintf(stdout, "  -v: show version and exits\n");
    fprintf(stdout, "  -q: quiet, suppress some messages\n");
    fprintf(stdout, "  -b: batch, executes files and quit, implies -q\n");
    exit (exit_code);
}

static void doversion(const int exit_code) {
    fprintf(stdout, "%s version %s (%s)\n", progname, version, __DATE__);
    exit (exit_code);
}

static void load_base_lib(s7_scheme *sc) {
    for (int k=0; base_scm_lib[k] != NULL; k++) {
        if (!is_quiet) {
            fprintf(stdout, "loading %s\n", base_scm_lib[k]);
        }
        s7_load(sc, base_scm_lib[k]);
    }
}


int main(int argc, char **argv) {
    int ret_value = SUCCESS;
    s7_scheme *sc;
    sc = s7_init();


    progname = argv[0];
    if (argc > 1) {
        int i;
        for (i=1; i<argc && *(argv[i]) == '-' && ret_value==SUCCESS; i++) {
            char *current_arg = argv[i] + 1;
            while (*current_arg != 0) {
                switch (*current_arg) {
                    case 'h':
                        dohelp(SUCCESS);
                        break;
                    case 'v':
                        doversion(SUCCESS);
                        break;
                    case 'b':
                        is_batch = true;
                        is_quiet = true;
                        break;
                    case 'q':
                        is_quiet = true;
                        break;
                    default:
                        fprintf(stderr, "unknown flag (%c)\n", *current_arg);
                        dohelp(FAILURE);
                        break;
                }
                current_arg++;
            }
        }
        load_base_lib(sc);
        for (; i<argc && ret_value==SUCCESS; i++) {
            if (!is_quiet) {
                fprintf(stderr, "load %s\n", argv[i]);
            }
            if (!s7_load(sc, argv[i])) {
                fprintf(stderr, "can't load %s\n", argv[i]);  /* it could also be a directory */
                ret_value = FAILURE;
            }
        }
    }
    if (ret_value != FAILURE && !is_batch) {
        s7_eval_c_string(sc, "((*repl* 'run))");
    }
    return ret_value;
}

/* gcc -o repl repl.c s7.o -Wl,-export-dynamic -lm -I. -ldl
*/
