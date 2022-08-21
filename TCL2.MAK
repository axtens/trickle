IO.DEF :

IO.M2O :         IO.MOD          \
                IO.DEF

XStr.DEF :

XStr.M2O :       XStr.MOD        \
                XStr.DEF

Commands.DEF :

Commands.M2O :   Commands.MOD    \
                IO.DEF          \
                Commands.DEF

BigFile.DEF :

BigFile.M2O :    BigFile.MOD     \
                BigFile.DEF

VARs.DEF :

LABELs.DEF :

XAnsi.DEF :

XAnsi.M2O :      XAnsi.MOD       \
                IO.DEF          \
                XAnsi.DEF

LINEs.DEF :

ERRORs.DEF :

ERRORs.M2O :     ERRORs.MOD      \
                IO.DEF          \
                ERRORs.DEF

TCL2.M2O :       TCL2.MOD        \
                ERRORs.DEF      \
                LINEs.DEF       \
                XAnsi.DEF       \
                LABELs.DEF      \
                VARs.DEF        \
                BigFile.DEF     \
                Commands.DEF    \
                XStr.DEF        \
                IO.DEF

VARs.M2O :       VARs.MOD        \
                ERRORs.DEF      \
                XStr.DEF        \
                VARs.DEF

LABELs.M2O :     LABELs.MOD      \
                ERRORs.DEF      \
                XStr.DEF        \
                LABELs.DEF

LINEs.M2O :      LINEs.MOD       \
                ERRORs.DEF      \
                XStr.DEF        \
                LINEs.DEF

