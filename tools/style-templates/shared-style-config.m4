m4_divert(-1)
m4_changecom(`@@##')

@@## Colors are in hex
m4_define(__COLOR_BREAK, d0d0d0)
m4_define(__COLOR_BODY, 030303)
m4_define(__COLOR_HEADER, 020202)
m4_define(__COLOR_LINK, m4_defn(`__COLOR_BODY'))
m4_define(__COLOR_LINK_HOVER, e0e0e0)

@@## Header sizes. Needs rework because CSS now uses different ratios for better responsive layout.
m4_define(__H1_SIZE, 3)
m4_define(__H2_SIZE, 2)
m4_define(__H3_SIZE, 1.5)
m4_define(__H4_SIZE, 1.167)
m4_define(__H5_SIZE, 1)
m4_define(__H6_SIZE, .88)
m4_divert(0)m4_dnl
