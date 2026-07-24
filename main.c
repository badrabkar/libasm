#include <stdio.h>
#include <string.h>
#include <assert.h>

extern	size_t	ft_strlen(const char *s);
extern	char	*ft_strcpy(char *dest, const char *src);
extern	int	ft_strcmp(const char *s1, const char *s2);

void	ft_strcmp_tests() {// 1. Identical strings should return 0
	assert(ft_strcmp("hello", "hello") == 0);

	// 2. First string lexicographically less than second should return < 0
	assert(ft_strcmp("abc", "abd") < 0);
	assert(ft_strcmp("a", "b") < 0);

	// 3. First string lexicographically greater than second should return > 0
	assert(ft_strcmp("xyz", "xyw") > 0);
	assert(ft_strcmp("b", "a") > 0);

	// 4. Prefix string compared to longer string
	assert(ft_strcmp("cat", "caterpillar") < 0);
	assert(ft_strcmp("caterpillar", "cat") > 0);

	// 5. Empty strings
	assert(ft_strcmp("", "") == 0);
	assert(ft_strcmp("", "a") < 0);
}
//	test for ft_strlen
int main(int argc, char** argv) {
//	printf("the size of the string is: %lu\n", ft_strlen(argv[1]));
//	printf("the size of the string is: %lu\n", strlen(argv[1]));
//}


//	test for ft_strcpy
//int main(int argc, char** argv) {
//	char dest[50];
//	char src[6]= "badro";
//
//	ft_strcpy(dest, src);
//	printf("the destination: %s", dest);


// tests for strcmp
	//
	

	//ft_strcmp_tests();
	char dest[3] = "aaa";
	char src[5] = "bbbb";
	char s2[4] = "bbb";
	printf("the destination: %s\n", strcpy(dest, src));
	printf("the destination: %s\n", src);
	printf("%d\n", strcmp(src,s2));
	//printf("%d\n", ft_strcmp("abc", "abd"));
	//printf("%d\n", strcmp("abc", "abd"));
    
	
}
