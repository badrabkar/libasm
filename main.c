#include <stdio.h>
#include <string.h>

extern	size_t	ft_strlen(const char *s);
extern	char	*ft_strcpy(char *dest, const char *src);

//	test for ft_strlen
//int main(int argc, char** argv) {
//	printf("the size of the string is: %lu\n", ft_strlen(argv[1]));
//	printf("the size of the string is: %lu\n", strlen(argv[1]));
//}


//	test for ft
int main(int argc, char** argv) {
	char dest[50];
	char src[6]= "badro";

	ft_strcpy(dest, src);
	printf("the destination: %s", dest);
}
