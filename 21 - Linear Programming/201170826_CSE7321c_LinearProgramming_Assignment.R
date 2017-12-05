# 1. A manufacturer of printed circuit boards has 200 resistors, 
# 120 transistors and 150 capacitors and he is required to produce two 
# different circuit boards that requires:
# Type A board: 20 resistors, 10 transistors and 5 capacitors 
# Type B board: 10 resistors, 12 transistors and 30 capacitors
# If the profit on type A board is Rs. 5 and type B board is 12. 
# How many of each should he manufacture to maximize the profits?
library(lpSolve)
f.obj = c(5, 12)
f.con = matrix (c(20, 10, 5, 10, 12, 30), nrow=3, byrow=TRUE)
f.dir = c("<=", "<=", "<=")
f.rhs = c(200,120,150)
lp ("max", f.obj, f.con, f.dir, f.rhs)
lp ("max", f.obj, f.con, f.dir, f.rhs)$solution
lp ("max", f.obj, f.con, f.dir, f.rhs, int.vec=1:2)
lp ("max", f.obj, f.con, f.dir, f.rhs, int.vec=1:2)$solution
# 2.	A painter has exactly 32 units of yellow dye and 54 units of 
# green dye. He plans to mix as many gallons as possible of color A 
# and color B. Each gallon of color A requires 4 units of yellow dye
# and 1 unit of green dye. Each gallon of color B requires 1 unit of
# yellow dye and 6 units of green dye. Find the maximum number of 
# gallons he can mix.
library(lpSolve)
f.obj = c(1, 1)
f.con = matrix (c(4, 1, 1, 6), nrow=2, byrow=TRUE)
f.dir = c("<=", "<=")
f.rhs = c(32,54)
lp ("max", f.obj, f.con, f.dir, f.rhs)
lp ("max", f.obj, f.con, f.dir, f.rhs)$solution
lp ("max", f.obj, f.con, f.dir, f.rhs, int.vec=1:2)
lp ("max", f.obj, f.con, f.dir, f.rhs, int.vec=1:2)$solution
# 3.	A construction company has four large bulldozers located at four different garages. The bulldozers are to be moved to four different construction sites. The distances in miles between the bulldozers and the construction sites are given below.
# 
# Bulldozer\Site	A	  B	  C	   D
# 1	              90	75	75	80
# 2	              35	85	55	65
# 3	              125	95	90	105
# 4	              45	110	95	115

# How should the bulldozers be moved to the construction sites in order to minimize the total distance traveled?
library(lpSolve)
f.obj <- c(90,75,75,80,35,85,55,65,125,95,90,105,45,110,95,115)
bullMtrx <- matrix(f.obj,nrow=4,byrow=TRUE)
a=lp.assign (bullMtrx, direction="min")
a
a$solution
# 4.	Howie earns a profit of $350 on each Aqua-Spa (X1) he sells and $300
# on each Hydro-Lux (X2) he sells. Only 200 pumps are available and each
# hot tub requires one pump. He has only 1,566 labor hours available during
# the next production cycle. Each Aqua-Spa he builds (each unit of X1) 
# requires 9 labor hours and each Hydro-Lux (each unit of X2) requires 6 
# labor hours. Each Aqua-Spa requires 12 feet of tubing, and each Hydro-Lux
# produced requires 16 feet of tubing. Total tubing available is 2,880 feet.
# 
# Howie’s objective is to maximize the profit. How many Aqua-Spas and 
# Hydro-Luxes should be produced? Hidden constraints:  There are simple
# lower bounds of zero on the variables X1 and X2 because it is impossible
# to produce a negative number of hot tubs.
library(lpSolve)
f.obj = c(350, 300)
f.con = matrix (c(9, 6, 12, 16, 1, 1, 1, 0, 0, 1), nrow=5, byrow=TRUE)
f.dir = c("<=", "<=", "=", ">=", ">=")
f.rhs = c(1566, 2880, 200, 0, 0)
lp ("max", f.obj, f.con, f.dir, f.rhs)
lp ("max", f.obj, f.con, f.dir, f.rhs)$solution
lp ("max", f.obj, f.con, f.dir, f.rhs, int.vec=1:2)
lp ("max", f.obj, f.con, f.dir, f.rhs, int.vec=1:2)$solution