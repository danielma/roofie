#~# ORIGINAL single assignment

x = 1

#~# EXPECTED

x = 1

#~# ORIGINAL multiple assignment

x = 1
y = 2

#~# EXPECTED

x = 1
y = 2

#~# ORIGINAL ugly single assignment

x=     1

#~# EXPECTED

x = 1

#~# ORIGINAL ugly multiple assignment

x=1
y             =3

#~# EXPECTED

x = 1
y = 3

#~# ORIGINAL line length
#~# print_width: 1

very_long_variable = 123456789

#~# EXPECTED

very_long_variable =
  123456789
