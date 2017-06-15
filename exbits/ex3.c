#include<stdio.h>

// unsigned bit field extract
void ubfx(unsigned int* dest, unsigned int src, const int sbit, const int nbits){
	*dest = src << (32 - (nbits + sbit - 1));
	*dest = *dest >> (32 - nbits);
}

// signed bit field extract
void sbfx(int* dest, int src, const int sbit, const int nbits){
	*dest = src << (32 - (nbits + sbit - 1));
	*dest = *dest >> (32 - nbits);
}

// bit field clear
void bfc(unsigned int *dest, const int sbit, const int nbits){
	unsigned int mask = -1;

	mask = mask << (32 - (nbits + sbit - 1));
	mask = mask >> (32 - nbits);
	mask = mask << sbit;

	printf("\nMascara: %08x\n",mask);

	*dest = *dest & (~mask);
}

int main(){
	unsigned int *numero;
	int sbit, nbits;

	printf("Digite um numero: ");
	scanf("%d",numero);

	printf("Bit de inicio: ");
	scanf("%d",&sbit);

	printf("Numero de bits: ");
	scanf("%d",&nbits);

	printf("\nAntes: %08x\n",*numero);

	//ubfx
	ubfx(numero, *numero, sbit, nbits);
	printf("\nPos ubfx: %08x\n",*numero);

	//sbfx
	ubfx(numero, *numero, sbit, nbits);
	printf("\nPos sbfx: %08x\n",*numero);
	
	//bfc
	bfc(numero, sbit, nbits);

	printf("Pos bfc: %08x\n",*numero);

	return 0;
}

