/* YY-CHR.NET plugin for Neo-Geo Fix (S1) format tiles */
using System;
using System.Drawing;
using CharactorLib.Common;
using CharactorLib.Format;

namespace NeoFixPlugin{
	public class NeoFixFormat : FormatBase{
		byte[] ColDataOffsets = { 0x10,0x18,0x00,0x08 };

		public NeoFixFormat(){
			base.FormatText = "[8][8]";
			base.Name = "Neo Geo FIX/S1";
			base.Extension = "s1,fix,sfix";
			base.Author = "freem";
			base.Url = "http://www.ajworld.net/";
			// Flags
			base.Readonly = false;
			// some fix tiles are part of compressed C ROMs (late-era SNK games).
			// you're on your own (a.k.a. decompress them before you get here)
			base.IsCompressed = false;
			base.EnableAdf = true;
			base.IsSupportMirror = true;
			base.IsSupportRotate = true;
			// Settings
			base.ColorBit = 4;
			base.ColorNum = 16;
			base.CharWidth = 8;
			base.CharHeight = 8;
			// Settings for Image Convert
			base.Width = 128;
			base.Height = 128;
		}

		/// <param name="data">Data</param>
		/// <param name="addr">Data address</param>
		/// <param name="bytemap">Bytemap</param>
		/// <param name="px">Bytemap position X</param>
		/// <param name="py">Bytemap position Y</param>
		public override void ConvertMemToChr(Byte[] data, int addr, Bytemap bytemap, int px, int py){
			// Convert the 4bpp linear, mixed columns data:
			/* ----------------------- LR LR LR LR LR LR LR LR
			 * data 1 x8 (columns 5,4) 54 54 54 54 54 54 54 54
			 * data 2 x8 (columns 7,6) 76 76 76 76 76 76 76 76
			 * data 3 x8 (columns 1,0) 10 10 10 10 10 10 10 10
			 * data 4 x8 (columns 3,2) 32 32 32 32 32 32 32 32
			 */

			// one row of fix data consists of reading the bytes of:
			// data 3, data 4, data 1, and data 2, in that order.

			// dat1 dat2 dat3 dat4
			// 0x00,0x08,0x10,0x18 <- tile 1/8 (y=0)
			// 0x01,0x09,0x11,0x19 <- tile 2/8 (y=1)
			// 0x02,0x0A,0x12,0x1A <- tile 3/8 (y=2)
			// 0x03,0x0B,0x13,0x1B <- tile 4/8 (y=3)
			// 0x04,0x0C,0x14,0x1C <- tile 5/8 (y=4)
			// 0x05,0x0D,0x15,0x1D <- tile 6/8 (y=5)
			// 0x06,0x0E,0x16,0x1E <- tile 7/8 (y=6)
			// 0x07,0x0F,0x17,0x1F <- tile 8/8 (y=7)

			for(int x = 0; x < CharWidth; x++){
				// each group of bytes defines a column.
				for(int y = 0; y < CharHeight; y++){
					// decode this tile.
					int tileAddr = addr;	// set base address
					byte pixByte = 0x00;

					// the base address for this pixel depends on the X and Y values.
					switch(x){
						case 0:		// column 0: ColDataOffsets[0], data 3, mask 0x0F
							tileAddr = addr+ColDataOffsets[0]+y;
							pixByte = (byte)(data[tileAddr] & 0x0F);
							break;
						case 1:		// column 1: ColDataOffsets[0], data 3, mask 0xF0
							tileAddr = addr+ColDataOffsets[0]+y;
							pixByte = (byte)((data[tileAddr] & 0xF0)>>4);
							break;
						case 2:		// column 2: ColDataOffsets[1], data 4, mask 0x0F
							tileAddr = addr+ColDataOffsets[1]+y;
							pixByte = (byte)(data[tileAddr] & 0x0F);
							break;
						case 3:		// column 3: ColDataOffsets[1], data 4, mask 0xF0
							tileAddr = addr+ColDataOffsets[1]+y;
							pixByte = (byte)((data[tileAddr] & 0xF0)>>4);
							break;
						case 4:		// column 4: ColDataOffsets[2], data 1, mask 0x0F
							tileAddr = addr+ColDataOffsets[2]+y;
							pixByte = (byte)(data[tileAddr] & 0x0F);
							break;
						case 5:		// column 5: ColDataOffsets[2], data 1, mask 0xF0
							tileAddr = addr+ColDataOffsets[2]+y;
							pixByte = (byte)((data[tileAddr] & 0xF0)>>4);
							break;
						case 6:		// column 6: ColDataOffsets[3], data 2, mask 0x0F
							tileAddr = addr+ColDataOffsets[3]+y;
							pixByte = (byte)(data[tileAddr] & 0x0F);
							break;
						case 7:		// column 7: ColDataOffsets[3], data 2, mask 0xF0
							tileAddr = addr+ColDataOffsets[3]+y;
							pixByte = (byte)((data[tileAddr] & 0xF0)>>4);
							break;
					}

					Point p = base.GetAdvancePixelPoint(px+x, py+y);
					int bytemapAddr = bytemap.GetPointAddress(p.X, p.Y);
					bytemap.Data[bytemapAddr] = pixByte;
				}
			}
		}

		/// <param name="data">Data</param>
		/// <param name="addr">Data address</param>
		/// <param name="bytemap">Bytemap</param>
		/// <param name="px">Bytemap position X</param>
		/// <param name="py">Bytemap position Y</param>
		public override void ConvertChrToMem(Byte[] data, int addr, Bytemap bytemap, int px, int py){
			// Convert back to the Neo Geo's 4bpp linear mixed columns format.

			for(int x = 0; x < CharWidth; x++){
				int tileAddr = addr;		// set base address

				for(int y = 0; y < CharHeight; y++){
					// encode this tile.

					// fallthrough is intentional.
					switch(x){
						case 0:
						case 1:
							tileAddr = addr+ColDataOffsets[0]+y;
							break;
						case 2:
						case 3:
							tileAddr = addr+ColDataOffsets[1]+y;
							break;
						case 4:
						case 5:
							tileAddr = addr+ColDataOffsets[2]+y;
							break;
						case 6:
						case 7:
							tileAddr = addr+ColDataOffsets[3]+y;
							break;
					}

					// bmValue for current pixel.
					Point p = base.GetAdvancePixelPoint(px+x, py+y);
					int bmAddr = bytemap.GetPointAddress(p.X, p.Y);
					byte bmValue = bytemap.Data[bmAddr];

					// combine the data
					int c0,outVal;
					int curData = data[tileAddr];
					if(x%2==0){
						// even column (0x0F)
						c0 = (byte)(bmValue & 0x0F);
						outVal = (byte)((curData&0xF0)|c0);
					}
					else{
						// odd column (0xF0)
						c0 = (byte)(bmValue & 0x0F);
						outVal = (byte)((c0<<4)|(curData&0x0F));
					}
					data[tileAddr] = (byte)outVal;
				}
			}
		}
	}
}