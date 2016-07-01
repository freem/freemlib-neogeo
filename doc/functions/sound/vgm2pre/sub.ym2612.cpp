/* excerpted */

// .vgi format
bool SubYM2612::saveVGI(const ins_t &ins, const string &fn) {
	uint8_t dataVGI[43] = {0};
	unsigned aa = 0, pp = 0;
	dataVGI[pp++] = ins.ch.algo;
	dataVGI[pp++] = ins.ch.fback;
	dataVGI[pp++] = ins.ch.pms|(ins.ch.ams<<4);
    for (aa = 0; aa<4; ++aa) {
		dataVGI[pp++] = ins.ch.op[aa].mul;
		dataVGI[pp++] = ins.ch.op[aa].detune+3;
		dataVGI[pp++] = ins.ch.op[aa].tl;
		dataVGI[pp++] = ins.ch.op[aa].rs;
		dataVGI[pp++] = ins.ch.op[aa].ar;
		dataVGI[pp++] = ins.ch.op[aa].dr|(ins.ch.op[aa].am<<7);
		dataVGI[pp++] = ins.ch.op[aa].sr;
		dataVGI[pp++] = ins.ch.op[aa].rr;
		dataVGI[pp++] = ins.ch.op[aa].sl;
		dataVGI[pp++] = ins.ch.op[aa].ssg;
	}
	return file::write({fn,".vgi"}, dataVGI, sizeof(dataVGI));
}

// .tfi format
bool SubYM2612::saveTFI(const ins_t &ins, const string &fn) {
	uint8_t dataTFI[42] = {0};
	unsigned aa = 0, pp = 0;
	dataTFI[pp++] = ins.ch.algo;
	dataTFI[pp++] = ins.ch.fback;
    for (aa = 0; aa<4; ++aa) {
		dataTFI[pp++] = ins.ch.op[aa].mul;
		dataTFI[pp++] = ins.ch.op[aa].detune+3;
		dataTFI[pp++] = ins.ch.op[aa].tl;
		dataTFI[pp++] = ins.ch.op[aa].rs;
		dataTFI[pp++] = ins.ch.op[aa].ar;
		dataTFI[pp++] = ins.ch.op[aa].dr;
		dataTFI[pp++] = ins.ch.op[aa].sr;
		dataTFI[pp++] = ins.ch.op[aa].rr;
		dataTFI[pp++] = ins.ch.op[aa].sl;
		dataTFI[pp++] = ins.ch.op[aa].ssg;
	}
	return file::write({fn,".tfi"}, dataTFI, sizeof(dataTFI));
}

// .tyi format
bool SubYM2612::saveTYI(const ins_t &ins, const string &fn) {
	//_log({" ",fn,".tyi"});
	uint8_t dataTYI[32] = {0};
	unsigned aa = 0, pp = 0;
	/*for (aa = 0; aa<4; ++aa) {dataTYI[pp++] = ins.ch.op[aa].mul|(ins.ch.op[aa].dt<<4);}
	for (aa = 0; aa<4; ++aa) {dataTYI[pp++] = ins.ch.op[aa].tl;}
	for (aa = 0; aa<4; ++aa) {dataTYI[pp++] = ins.ch.op[aa].ar|(ins.ch.op[aa].rs<<6);}
	for (aa = 0; aa<4; ++aa) {dataTYI[pp++] = ins.ch.op[aa].dr|(ins.ch.op[aa].am<<7);}
	for (aa = 0; aa<4; ++aa) {dataTYI[pp++] = ins.ch.op[aa].sr;}
	for (aa = 0; aa<4; ++aa) {dataTYI[pp++] = ins.ch.op[aa].rr|(ins.ch.op[aa].sl<<4);}
	for (aa = 0; aa<4; ++aa) {dataTYI[pp++] = ins.ch.op[aa].ssg;}*/
//
	for (aa = 0; aa<4; ++aa) {
		dataTYI[aa] = ins.ch.op[aa].mul|(ins.ch.op[aa].dt<<4);
		dataTYI[aa+4] = ins.ch.op[aa].tl;
		dataTYI[aa+8] = ins.ch.op[aa].ar|(ins.ch.op[aa].rs<<6);
		dataTYI[aa+12] = ins.ch.op[aa].dr|(ins.ch.op[aa].am<<7);
		dataTYI[aa+16] = ins.ch.op[aa].sr;
		dataTYI[aa+20] = ins.ch.op[aa].rr|(ins.ch.op[aa].sl<<4);
		dataTYI[aa+24] = ins.ch.op[aa].ssg;
		//++pp;
	}
//
	dataTYI[28] = ins.ch.algo|(ins.ch.fback<<3);
	dataTYI[29] = ins.ch.pms|(ins.ch.ams<<4);
	dataTYI[30] = 'Y';
	dataTYI[31] = 'I';
	return file::write({fn,".tyi"}, dataTYI, sizeof(dataTYI));
}

// .y12 format
bool SubYM2612::saveY12(const ins_t &ins, const string &fn) {
	//_log({" ",fn,".y12"});
	uint8_t dataY12[128] = {0};
	//return file::write({fn,".y12"}, dataY12, sizeof(dataY12));
	unsigned aa = 0, pp = 0;
	for (aa = 0; aa<4; ++aa) {
		dataY12[pp++] = ins.ch.op[aa].mul|(ins.ch.op[aa].dt<<4);
		dataY12[pp++] = ins.ch.op[aa].tl;
		dataY12[pp++] = ins.ch.op[aa].ar|(ins.ch.op[aa].rs<<6);
		dataY12[pp++] = ins.ch.op[aa].dr|(ins.ch.op[aa].am<<7);	// AM IS UNUSED
		dataY12[pp++] = ins.ch.op[aa].sr;
		dataY12[pp++] = ins.ch.op[aa].rr|(ins.ch.op[aa].sl<<4);
		dataY12[pp++] = ins.ch.op[aa].ssg;	// UNUSED
		// 9 UNUSED BYTES FOLLOW
		++pp;
		++pp;++pp;++pp;++pp;++pp;++pp;++pp;++pp;
	}
	dataY12[pp++] = ins.ch.algo;
	dataY12[pp++] = ins.ch.fback;
	// 14 UNUSED BYTES FOLLOW
	++pp;++pp;++pp;++pp;++pp;++pp;++pp;++pp; ++pp;++pp;++pp;++pp;++pp;++pp;
	// TODO: 16 BYTES FOR NAME
	++pp;++pp;++pp;++pp;++pp;++pp;++pp;++pp; ++pp;++pp;++pp;++pp;++pp;++pp;++pp;++pp;
	// TODO: 16 BYTES FOR DUMPER
	memcpy(&dataY12[pp],"VGM2Pre",7);
	// TODO 16 BYTES FOR GAME
	return file::write({fn,".y12"}, dataY12, sizeof(dataY12));
}

// .eif format
bool SubYM2612::saveEIF(const ins_t &ins, const string &fn) {
	//_log({" ",fn,".eif"});
	uint8_t dataEIF[29] = {0};
	unsigned aa = 0, pp = 0;
	dataEIF[pp++] = ins.ch.algo|(ins.ch.fback<<3);
	for (aa = 0; aa<4; ++aa) {dataEIF[pp++] = ins.ch.op[aa].mul|(ins.ch.op[aa].dt<<4);}
	for (aa = 0; aa<4; ++aa) {dataEIF[pp++] = ins.ch.op[aa].tl;}
	for (aa = 0; aa<4; ++aa) {dataEIF[pp++] = ins.ch.op[aa].ar|(ins.ch.op[aa].rs<<6);}
	for (aa = 0; aa<4; ++aa) {dataEIF[pp++] = ins.ch.op[aa].dr|(ins.ch.op[aa].am<<7);}
	for (aa = 0; aa<4; ++aa) {dataEIF[pp++] = ins.ch.op[aa].sr;}
	for (aa = 0; aa<4; ++aa) {dataEIF[pp++] = ins.ch.op[aa].rr|(ins.ch.op[aa].sl<<4);}
	for (aa = 0; aa<4; ++aa) {dataEIF[pp++] = ins.ch.op[aa].ssg;}
	return file::write({fn,".eif"}, dataEIF, sizeof(dataEIF));
	//return false;
}

// .dmp format (DefleMask)
bool SubYM2612::saveDMP(const ins_t &ins, const string &fn) {
	//_log({" ",fn,".dmp"});
	unsigned aa, pp = 0;
	uint8_t dv = 7, ds = dv==7?2+4+1+4*11:2+8+4*19;
	uint8_t dataDMP[ds];
	if (dv==7) {	// DMP v7
		dataDMP[pp++] = 7;	// older DefleMask instrument
		dataDMP[pp++] = 1;	// type = FM
		dataDMP[pp++] = 1;	// 0 = 2-op, 1 = 4-op
		dataDMP[pp++] = ins.ch.pms;
		dataDMP[pp++] = ins.ch.fback;
		dataDMP[pp++] = ins.ch.algo;
		dataDMP[pp++] = ins.ch.ams;
		for (aa = 0; aa<4; ++aa) {
			dataDMP[pp++] = ins.ch.op[aa].mul;
			dataDMP[pp++] = ins.ch.op[aa].tl;
			dataDMP[pp++] = ins.ch.op[aa].ar;
			dataDMP[pp++] = ins.ch.op[aa].dr;
			dataDMP[pp++] = ins.ch.op[aa].sl;
			dataDMP[pp++] = ins.ch.op[aa].rr;
			dataDMP[pp++] = ins.ch.op[aa].am;
			// YM2612-specific
			dataDMP[pp++] = ins.ch.op[aa].rs;
			dataDMP[pp++] = ins.ch.op[aa].detune+3;
			dataDMP[pp++] = ins.ch.op[aa].sr;
			dataDMP[pp++] = ins.ch.op[aa].ssg;
		}
	}
	else {	// DMP v16
		dataDMP[pp++] = 16;	// DefleMask 9
		dataDMP[pp++] = 1;	// type = FM
		dataDMP[pp++] = ins.ch.algo; dataDMP[pp++] = 0;
		dataDMP[pp++] = ins.ch.fback; dataDMP[pp++] = 0;
		dataDMP[pp++] = ins.ch.pms; dataDMP[pp++] = 0;
		dataDMP[pp++] = 1; dataDMP[pp++] = ins.ch.ams;
		for (aa = 0; aa<4; ++aa) {
			dataDMP[pp++] = ins.ch.op[aa].am;
			dataDMP[pp++] = ins.ch.op[aa].ar;
			dataDMP[pp++] = 0;
			dataDMP[pp++] = ins.ch.op[aa].dr;
			dataDMP[pp++] = 0;
			dataDMP[pp++] = 0;
			dataDMP[pp++] = 0;
			dataDMP[pp++] = 0;
			dataDMP[pp++] = ins.ch.op[aa].mul;
			dataDMP[pp++] = ins.ch.op[aa].rr;
			dataDMP[pp++] = ins.ch.op[aa].sl;
			dataDMP[pp++] = 0;
			dataDMP[pp++] = ins.ch.op[aa].tl;
			dataDMP[pp++] = 0;
			dataDMP[pp++] = 0;
			dataDMP[pp++] = ins.ch.op[aa].rs;
			dataDMP[pp++] = ins.ch.op[aa].detune;
			dataDMP[pp++] = ins.ch.op[aa].sr;
			dataDMP[pp++] = ins.ch.op[aa].ssg;
		}
	}
	return file::write({fn,".dmp"}, dataDMP, sizeof(dataDMP));
	//return false;
}
