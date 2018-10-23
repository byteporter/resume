TODO
====

1) Make resume use OpenSans-Light for normal font when made with Docker container

Output comparing locally build pdf (above) and docker build (below)

[james@james-ultra jameslind_info]$ pdffonts resume/web/static-root/resume.pdf 
name                                 type              encoding         emb sub uni object ID
------------------------------------ ----------------- ---------------- --- --- --- ---------
WDZGUV+OpenSans-Light                CID TrueType      Identity-H       yes yes yes     14  0
OXGQBD+OpenSans-Semibold             CID TrueType      Identity-H       yes yes yes     16  0
[james@james-ultra jameslind_info]$ pdffonts resume/output/usr/share/resume/static-root/resume.pdf 
name                                 type              encoding         emb sub uni object ID
------------------------------------ ----------------- ---------------- --- --- --- ---------
SAAMHT+LMSans10-Regular              CID Type 0C       Identity-H       yes yes yes     14  0
BZACML+LMSans10-Bold                 CID Type 0C       Identity-H       yes yes yes     16  0
