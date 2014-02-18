dnl
dnl $Id$
dnl

PHP_ARG_ENABLE(phpdbg, for phpdbg support,
[  --enable-phpdbg         Build phpdbg], no, no)

PHP_ARG_ENABLE(phpdbg-debug, for phpdbg debug build,
[  --enable-phpdbg-debug   Build phpdbg in debug mode], no, no)

if test "$PHP_PHPDBG" != "no"; then
  AC_DEFINE(HAVE_PHPDBG, 1, [ ])

  if test "$PHP_PHPDBG_DEBUG" != "no"; then
    AC_DEFINE(PHPDBG_DEBUG, 1, [ ])
  else
    AC_DEFINE(PHPDBG_DEBUG, 0, [ ])
  fi

  PHP_PHPDBG_CFLAGS="-D_GNU_SOURCE"
  PHP_PHPDBG_FILES="phpdbg.c phpdbg_prompt.c phpdbg_help.c phpdbg_break.c phpdbg_print.c phpdbg_bp.c phpdbg_opcode.c phpdbg_list.c phpdbg_utils.c phpdbg_info.c phpdbg_cmd.c phpdbg_set.c phpdbg_frame.c"

  if test "$PHP_READLINE" != "no"; then
  	PHPDBG_EXTRA_LIBS="-lreadline"
  fi
  
  PHP_SUBST(PHP_PHPDBG_CFLAGS)
  PHP_SUBST(PHP_PHPDBG_FILES)
  PHP_SUBST(PHPDBG_EXTRA_LIBS)
  
  PHP_ADD_MAKEFILE_FRAGMENT([$abs_srcdir/sapi/phpdbg/Makefile.frag])
  PHP_SELECT_SAPI(phpdbg, program, $PHP_PHPDBG_FILES, $PHP_PHPDBG_CFLAGS, [$(SAPI_PHPDBG_PATH)])

  BUILD_BINARY="sapi/phpdbg/phpdbg"
  BUILD_SHARED="sapi/phpdbg/libphpdbg.la"

  BUILD_PHPDBG="\$(LIBTOOL) --mode=link \
        \$(CC) -export-dynamic \$(CFLAGS_CLEAN) \$(EXTRA_CFLAGS) \$(EXTRA_LDFLAGS_PROGRAM) \$(LDFLAGS) \$(PHP_RPATHS) \
                \$(PHP_GLOBAL_OBJS) \
                \$(PHP_BINARY_OBJS) \
                \$(PHP_PHPDBG_OBJS) \
                \$(EXTRA_LIBS) \
                \$(PHPDBG_EXTRA_LIBS) \
                \$(ZEND_EXTRA_LIBS) \
         -o \$(BUILD_BINARY)"

  BUILD_PHPDBG_SHARED="\$(LIBTOOL) --mode=link \
        \$(CC) -shared -Wl,-soname,libphpdbg.so -export-dynamic \$(CFLAGS_CLEAN) \$(EXTRA_CFLAGS) \$(EXTRA_LDFLAGS_PROGRAM) \$(LDFLAGS) \$(PHP_RPATHS) \
                \$(PHP_GLOBAL_OBJS) \
                \$(PHP_BINARY_OBJS) \
                \$(PHP_PHPDBG_OBJS) \
                \$(EXTRA_LIBS) \
                \$(PHPDBG_EXTRA_LIBS) \
                \$(ZEND_EXTRA_LIBS) \
                \-DPHPDBG_SHARED \
         -o \$(BUILD_SHARED)"

  PHP_SUBST(BUILD_BINARY)
  PHP_SUBST(BUILD_SHARED)
  PHP_SUBST(BUILD_PHPDBG)
  PHP_SUBST(BUILD_PHPDBG_SHARED)
fi

dnl ## Local Variables:
dnl ## tab-width: 4
dnl ## End:
