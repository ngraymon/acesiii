      SUBROUTINE JPRI(J,NCOORD,NUCIND,MULT,NAMEX,NAMES,PRINT)
C
C THIS ROUTINE PRINTS THE TENSOR FOR INDIRECT SPIN SPIN
C COUPLINGS IN NMR THEORY
C
C NOTE THAT THIS ROUTINE MULTIPLIES THE GIVEN TENSOR (IN J)
C WITH THE G-FACTORS FOR THE TWO INVOLVED NUCLEI
C
CEND
C
C 4/93 JG
C
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      INTEGER BEGIN
      DOUBLE PRECISION J
      LOGICAL PRINT
C
      DIMENSION NAMEX(3*NCOORD),MULT(1)
      DIMENSION NAMES(3*NCOORD)
      DIMENSION J(NCOORD,NCOORD)
      DIMENSION GTAB(36),LABELS(36)
      CHARACTER*6 NAMEX
      CHARACTER*6 NAMES
      CHARACTER*2 LABELS
      CHARACTER*2 LAB1,LAB2
C 
      DATA AZERO/0.D0/
C
C GTAB CONTAINS THE G-VALUES FOR THE MOST COMMON ISOTOPES USED IN NMR
C 1H,11B,13C,15C,17O,31P,29SI,27AL,19F 
C
C AND SHOULD BE UPDATED WHENEVER POSSIBLE
C
C  update and check ! No guarantee for correct results
C
C NOTE g(D) IS 0.8574376
C NOTE g(6LI) IS 0.8220514
C NOTE g(10B) IS 0.600216
C NOTE g(14N) IS 0.4037607
C NOTE g(37CL) IS 0.4560820
C NOTE g(49TI) IS -0.315477
C NOTE g(65CU) IS 1.588
C NOTE g(71GA) IS 1.70818
C NOTE g(81BR) IS 1.513706
C
C               1H         3HE          7LI         9BE    
      DATA GTAB/5.5856912D0,-4.255248D0,2.170961D0,-0.7850D0,
C               11B
     &          1.792424D0,
C               13C        15N        17O          19F       
     &          1.40482D0,-0.5663784D0,-0.757516D0,5.257732D0,
C               21NE
     &          -0.441197D0,
C               23NA       25MG       27AL       29SI      31P      
     &          1.478391D0,-0.34218D0,1.456601D0,-1.1106D0,2.26320D0,
C               33S       35CL         39AR   39K
     &          0.42911D0,0.5479157D0,-.37D0,0.2609909D0,
C               43CA       45SC      47TI       51V
     &          -0.376414D0,1.35906D0,-0.31539D0,1.46836D0,
C               53CR      55MN     57FE    59CO     61NI
     &          -.3147D0,1.3819D0,0.1806D0,1.318D0,-0.50001D0,
C               63CU    67ZN       69GA     73GE
     &          1.484D0,0.350312D0,1.34439D0,-0.1954371D0,
C               75AS       77SE     79BR       83KR
     &          0.959647D0,1.0693D0,1.404266D0,-0.215704D0/

C
      DATA LABELS/'H ','HE','LI','BE','B ','C ','N ','O ','F ',
     &            'NE','NA','MG','AL','SI','P ','S ','CL','AR',
     &            'K ','CA','SC','TI','V ','CR','MN','FE','CO',
     &            'NI','CU','ZN','GA','GE','AS','SE','BR','KR'/
      KCOL=6
C
C GET LABELS FOR THE NUCLEI, A LITTLE BIT TRICKY DUE TO SYMMETRY
C
      I=0
      DO 10 IATOM=1,NUCIND
       MULTI=MULT(IATOM)
       ISTR=3*IATOM-3
       IF(MULTI.EQ.1) THEN
        DO 30 ICOOR=1,3
         I=I+1
         NAMES(I)=NAMEX(ISTR+ICOOR)(1:4)//' '//NAMEX(ISTR+ICOOR)(6:6)
30      CONTINUE
       ELSE
        DO 40 JJ=1,MULTI
         DO 50 ICOOR=1,3
          I=I+1
          NAMES(I)=NAMEX(ISTR+ICOOR)(1:4)//' '//NAMEX(ISTR+ICOOR)(6:6)
50       CONTINUE
40      CONTINUE
       ENDIF
10    CONTINUE  
C
C DETERMINE THE G-FACTORS FOR THE TWO NUCLEI 
C
      DO 11 IATOM=1,NCOORD
       LAB1=NAMES(IATOM)(1:2)
       DO 12 ILAB=1,18
        JLAB=ILAB
        IF(LAB1.EQ.LABELS(ILAB)) GO TO 13
12     CONTINUE
       write(*,*) ' no g-factor found for ',lab1
13     FACT=gtab(jlab)
       DO 11 JATOM=1,NCOORD
        LAB2=NAMES(jATOM)(1:2)
        DO 14 ILAB=1,18
         JLAB=ILAB
         IF(LAB2.EQ.LABELS(ILAB)) GO TO 15
14     CONTINUE
       write(*,*) ' no g-factor found for ',lab2
       IF((IATOM-1)/3.EQ.(JATOM-1)/3) FACT=AZERO 
15     FACT2=FACT*gtab(jlab)
C
       J(IATOM,JATOM)=FACT2*J(IATOM,JATOM)
11    CONTINUE
C
      IF(PRINT) THEN
C
       NROW = NCOORD
       LAST = MIN(NROW,KCOL)
       BEGIN= 1 
51     CONTINUE
        WRITE (6,1000) (NAMES(I),I = BEGIN,LAST)
        WRITE (6,'()')
        NCOL = 1
        DO 101 K = BEGIN,NROW
         DO 201 I = 1,NCOL
          IF (J(K,(BEGIN-1)+I) .NE. AZERO) GO TO 401
201      CONTINUE
         GO TO 301
401      WRITE (6,2000)' ',NAMES(K),
     &         (J(K,(BEGIN-1)+JJ),JJ=1,NCOL)
         IF (MOD(K,3) .EQ. 0) WRITE (6,'()')
301      IF (K .LT. (BEGIN+KCOL-1)) NCOL = NCOL + 1
101     CONTINUE
        WRITE (6,'()')
        LAST = MIN(LAST+KCOL,NROW)
        BEGIN= BEGIN+NCOL
       IF (BEGIN.LE.NROW) GO TO 51
C
      ENDIF
C
1000  FORMAT (8X,6(3X,A6,3X),(3X,A6,3X))
2000  FORMAT (A1,A6,6F12.6)
C
      RETURN
C
      END
