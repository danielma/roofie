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

#~# ORIGINAL assignment to symbol

d=:yolo

#~# EXPECTED

d = :yolo

#~# ORIGINAL print width assignment to symbol
#~# print_width: 4

d=:yolo

#~# EXPECTED

d =
  :yolo

#~# ORIGINAL assignment to string literal

l =
  "hi"

#~# EXPECTED

l = "hi"

#~# ORIGINAL line length
#~# print_width: 1

very_long_variable = 123456789

#~# EXPECTED

very_long_variable =
  123456789
