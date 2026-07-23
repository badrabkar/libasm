/*
 * Unit tests for ft_strlen (NASM, System V AMD64 ABI)
 *
 * Build & run:
 *   nasm -f elf64 ft_strlen.s -o ft_strlen.o
 *   gcc -o test_ft_strlen test_ft_strlen.c ft_strlen.o
 *   ./test_ft_strlen
 *
 * No external test framework required (plain C, exits non-zero on failure
 * so it also works well in CI / a Makefile "test" target).
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/* Prototype for the external NASM function */
size_t ft_strlen(const char *s);

static int g_failed = 0;
static int g_total  = 0;

/* Compare ft_strlen(s) against the libc strlen(s) (ground truth) */
static void check(const char *label, const char *s)
{
	size_t expected = strlen(s);
	size_t got = ft_strlen(s);

	g_total++;
	if (got != expected) {
		g_failed++;
		printf("[FAIL] %-30s expected=%zu got=%zu\n", label, expected, got);
	} else {
		printf("[ OK ] %-30s len=%zu\n", label, got);
	}
}

int main(void)
{
	/* --- Basic cases --- */
	check("empty string",              "");
	check("single char",                "a");
	check("short word",                 "hello");
	check("sentence with spaces",       "the quick brown fox");
	check("digits",                     "0123456789");

	/* --- Length edge cases around common boundaries
	 *     (word/qword/SIMD-register widths, page granularity, etc.) --- */
	{
		char buf[4097];
		size_t sizes[] = {1, 2, 3, 4, 5, 7, 8, 9,
		                  15, 16, 17, 31, 32, 33,
		                  63, 64, 65, 127, 128, 129,
		                  255, 256, 257,
		                  511, 512, 513,
		                  1023, 1024, 1025,
		                  4095, 4096};
		size_t i;
		char label[64];

		for (i = 0; i < sizeof(sizes) / sizeof(sizes[0]); i++) {
			size_t n = sizes[i];
			memset(buf, 'x', n);
			buf[n] = '\0';
			snprintf(label, sizeof(label), "length %zu boundary", n);
			check(label, buf);
		}
	}

	/* --- Special / tricky byte content --- */
	check("all spaces",                 "                    ");
	check("newline-terminated content", "line1\nline2");
	check("string with tab",            "col1\tcol2");
	check("single space",               " ");
	check("string of NUL-adjacent 0x01","\x01\x02\x03\x04");
	check("high-bit bytes (non-ASCII)", "\xC3\xA9\xC3\xA0"); /* UTF-8 'éà' */

	/* --- Repeated identical characters (checks no early/late exit bugs) --- */
	{
		char buf[65];
		memset(buf, 'A', 64);
		buf[64] = '\0';
		check("64 identical chars", buf);
	}
	{
		char buf[65];
		memset(buf, 0x7F, 64); /* DEL byte, still non-zero */
		buf[64] = '\0';
		check("64 x 0x7F bytes", buf);
	}

	/* --- Strings not starting at buffer offset 0 (alignment stress) ---
	 * Ensures the routine works when rdi isn't 8/16-byte aligned, in case
	 * the implementation is later optimized with word/SIMD reads. */
	{
		char raw[64 + 16];
		size_t off;

		memset(raw, 'z', sizeof(raw));
		for (off = 0; off < 16; off++) {
			char label[64];
			size_t len = 20;

			memset(raw + off, 'm', len);
			raw[off + len] = '\0';
			snprintf(label, sizeof(label), "unaligned start offset %zu", off);
			check(label, raw + off);
		}
	}

	/* --- Long string (stress test) --- */
	{
		char *big = malloc(100000 + 1);
		if (big) {
			memset(big, 'q', 100000);
			big[100000] = '\0';
			check("100,000 char string", big);
			free(big);
		}
	}

	/* --- String literal already known at compile time --- */
	check("classic literal",            "The quick brown fox jumps over the lazy dog");

	printf("\n%d / %d tests passed\n", g_total - g_failed, g_total);
	if (g_failed) {
		printf("%d test(s) FAILED\n", g_failed);
		return 1;
	}
	printf("All tests passed.\n");
	return 0;
}
