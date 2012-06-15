#define _LIBC_LIMITS_H_	1
#define MB_LEN_MAX	16
#  define _LIMITS_H	1
#  define CHAR_BIT	8
#  define SCHAR_MIN	(-128)
#  define SCHAR_MAX	127
#  define UCHAR_MAX	255
#   define CHAR_MIN	0
#  define SHRT_MIN	(-32768)
#  define SHRT_MAX	32767
#  define USHRT_MAX	65535
#  define INT_MIN	(-INT_MAX - 1)
#  define INT_MAX	2147483647
#  define UINT_MAX	4294967295U
#   define LONG_MAX	2147483647L
#  define LONG_MIN	(-LONG_MAX - 1L)
#   define ULONG_MAX	4294967295UL
#  define LLONG_MIN	(-LLONG_MAX-1)
#  define LLONG_MAX	__LONG_LONG_MAX__
#  define ULLONG_MAX	(LLONG_MAX * 2ULL + 1)
#define FT_UINT_MAX  UINT_MAX
#define FT_ULONG_MAX ULONG_MAX

