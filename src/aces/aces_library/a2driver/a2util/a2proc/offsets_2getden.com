#ifndef _OFFSETS_2GETDEN_
#define _OFFSETS_2GETDEN_

      COMMON /OFF_4INTGRT/IMEMBC,INUC,NUFCT,NUMOM,NFCT,NANGMOM,
     &                    IATMNAM,NAOUATM,NAOATM,IANGMOMSHL,
     &                    ICONFUNSHL,IPRMFUNSHL,INPRIMSHL,
     &                    IANGMOMTSHL,ICONFUNTSHL,IOFFSETPRM,
     &                    IOFFSETCON,IOFFSETSHL,IMAP_SHL2CNT,
     &                    IPRMFUNTSHL,NMOMAO,IALPHA,ICOEFFA,
     &                    ICOEFFB,IDENSA,IDENSB,IPCOEFFA,
     &                    IPCOEFFB, IPCOEFF,ISCR1,ISCR2,IREORD 


#endif /* _OFFSETS_2GETDEN_ */


