
#import "HeMaCeasar.h"

//static int heSoA = 143;
//static int heSoB = 158;
//static int heSoC = 111;
//static int heSoD = 158;

static int heSoA = 143;
static int heSoB = 173;
static int heSoC = 111;
static int heSoD = 173;

@implementation HeMaCeasar

+ (NSData *)maHoa:(NSData *)dauVao {
    
	NSUInteger nLength = [dauVao length];
    unsigned char *bDauRa = malloc( nLength * sizeof(unsigned char) );
    unsigned char *bDauVao = malloc( nLength * sizeof(unsigned char) );
    
    [dauVao getBytes:bDauVao length:nLength];
    int nTemp = 0;
    
	for (NSUInteger i = 0; i < nLength; i++) {
        
		nTemp = ((NSUInteger)bDauVao[i] * heSoA + heSoB + 512) % 256;
		bDauRa[i] = (Byte)nTemp;
	}
	NSData *output = [NSData dataWithBytes:bDauRa length:nLength];
	return output;
}


+ (NSData *)giaiMa:(NSData *)dauVao {
	
	NSUInteger nLength = [dauVao length];
    unsigned char *bDauRa = malloc( nLength * sizeof(unsigned char) );
    unsigned char *bDauVao = malloc( nLength * sizeof(unsigned char) );
    
	[dauVao getBytes:bDauVao length:nLength];
	NSUInteger nTemp = 0;
    
	for (NSUInteger i = 0; i < nLength; i++) {
        
		nTemp = (((int)bDauVao[i] - heSoD) * heSoC + 512) % 256;
		bDauRa[i] = (Byte)nTemp;
	}
	NSData *output = [NSData dataWithBytes:bDauRa length:nLength];
	return output;
}

@end
