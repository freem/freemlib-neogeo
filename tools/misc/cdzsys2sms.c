/*
 * cdzsys2sms - A tool to convert "TITLE_*.SYS" files to 4bpp SMS/GG/WSC format
 * written by freem.
 * does nothing about the palettes, sorry.
 * the constants are only there for skipping bytes.
 * export to multiple .ngpal files might be added in the future.
 */
#include <stdio.h>
#include <stdlib.h>

/* number of colors in a palette set */
#define COLORS_IN_PALSET 16

/* (45 entries, 16 colors per entry) */
#define PALETTE_SIZE 45*COLORS_IN_PALSET

/* 18x10 8x8px tiles; sprite data size = 5760 bytes */
#define SPRDATA_SIZE ((8*8)*18*10)/2

/* size of output buffer */
#define OUTBUF_SIZE 128

/* used for sprite data conversion */
unsigned char NybbleReverse[16] = {
	0x0, 0x8, 0x4, 0xC, 0x2, 0xA, 0x6, 0xE,
	0x1, 0x9, 0x5, 0xD, 0x3, 0xB, 0x7, 0xF
};

/* Print usage */
void Usage(){
	puts("Usage: cdzsys2sms (infile) [outfile]");
}

int main(int argc, char *argv[]){
	FILE *inFile;						/* TITLE_*.SYS file */
	FILE *outFile;						/* output .SMS file */
	char *outFilename = "out.sms";		/* output filename */
	unsigned char sprData[SPRDATA_SIZE];
	unsigned char outBuf[OUTBUF_SIZE];	/* 128 bytes; one 16x16 tile at a time */
	unsigned char halfBuf[OUTBUF_SIZE/2]; /* 64 bytes; used for swapping */
	unsigned char tempByte;
	long sprBufPos = 0;
	size_t result = 0;
	int i,j;

	puts("cdzsys2sms - Convert Neo-Geo CDZ TITLE_*.SYS files to 4bpp SMS/GG/WSC format");
	if(argc < 2){
		Usage();
		exit(EXIT_SUCCESS);
	}

	/* argv[2] may or may not have output filename */
	if(argv[2]){
		outFilename = argv[2];
	}

	/* argv[1] will have the input filename */
	inFile = fopen(argv[1],"rb");
	if(inFile == NULL){
		printf("Error attempting to open '%s': ",argv[1]);
		perror("");
		exit(EXIT_FAILURE);
	}

	printf("Opened '%s'\n",argv[1]);
	/* file has been opened; read sprite data */
	fseek(inFile,PALETTE_SIZE*sizeof(unsigned short),SEEK_SET);
	result = fread(sprData,sizeof(unsigned char),SPRDATA_SIZE,inFile);
	fclose(inFile);

	outFile = fopen(outFilename,"wb");
	if(outFile == NULL){
		printf("Error attempting to create output file '%s': ",outFilename);
		perror("");
		exit(EXIT_FAILURE);
	}

	/* byteswap sprite data */
	for(i = 0; i < SPRDATA_SIZE-1; i+=2){
		tempByte = sprData[i];
		sprData[i] = sprData[i+1];
		sprData[i+1] = tempByte;
	}

	/* swap 64 bytes for every 128 byte chunk of sprite data */
	for(i = 0; i < SPRDATA_SIZE/OUTBUF_SIZE; i++){
		/* get 128 bytes */
		memmove(outBuf,sprData+sprBufPos,OUTBUF_SIZE);

		/* perform the 64 byte swap */
		/* step 1: get the bottom 64 bytes. */
		memcpy(halfBuf,outBuf+(OUTBUF_SIZE/2),(OUTBUF_SIZE/2));
		/* step 2: move the top 64 bytes. */
		memmove(outBuf+(OUTBUF_SIZE/2),outBuf,(OUTBUF_SIZE/2));
		/* step 3: write the top 64 bytes. */
		memmove(outBuf,halfBuf,(OUTBUF_SIZE/2));

		/* un-reverse sprite data bits */
		for(j = 0; j < OUTBUF_SIZE; j++){
			unsigned char upper = (outBuf[j]&0xF0)>>4;
			unsigned char lower = (outBuf[j]&0x0F);
			outBuf[j] = NybbleReverse[lower] << 4 | NybbleReverse[upper];
		}

		/* write output buffer to file */
		result = fwrite(outBuf,sizeof(unsigned char),OUTBUF_SIZE,outFile);
		if(result != OUTBUF_SIZE){
			/* error */
			perror("Error writing to output file");
			exit(EXIT_FAILURE);
		}

		/* end of loop logic */
		sprBufPos += OUTBUF_SIZE;
	}

	printf("Successfully wrote output to '%s'\n",outFilename);
	close(outFile);
	exit(EXIT_SUCCESS);
}
