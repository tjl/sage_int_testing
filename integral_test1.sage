#!/usr/bin/env sage

##########################################################################
#  Copyright (C) 2008 Tim Lahey <tim.lahey@gmail.com>
#
#  Distributed under the terms of the BSD License:
#
#           http://www.opensource.org/licenses/bsd-license.php
##########################################################################

# The source of the integrals for comparison are from:
# Spiegel, Murray R. 
# Mathematical Handbook of Formulas and Tables
# Schaum's Outline Series McGraw-Hill 1968
# 14.59-14.83

# Define the necessary variables
var('x,a,b,n,m')

# Define the table of integral tests. Format is test #, [integrand,desired result]
# Note that test 25 fails. The result is not given in this suite.
int_table = { 1 : [1/(a*x+b),1/a*log(a*x+b)],
			  2 : [x/(a*x+b),x/a-b/a^2*log(a*x+b)],
			  3 : [x^2/(a*x+b),(a*x+b)^2/(2*a^3)-(2*b*(a*x+b))/a^3+b^2/a^3*log(a*x+b)],
			  4 : [x^3/(a*x+b),(a*x+b)^3/(3*a^4)-(3*b*(a*x+b)^2)/(2*a^4)+(3*b^2*(a*x+b))/a^4-(b^3/a^4)*log(a*x+b)],
			  5 : [1/(x*(a*x+b)),1/b*log(x/(a*x+b))],
			  6 : [1/(x^2*(a*x+b)),-1/(b*x)+a/b^2*log((a*x+b)/x)],
			  7 : [1/(x^3*(a*x+b)),(2*a*x-b)/(2*b^2*x^2)+a^2/b^3*log(x/(a*x+b))],
			  8 : [1/(a*x+b)^2,-1/(a*(a*x+b))],
			  9 : [x/(a*x+b)^2, b/(a^2*(a*x+b))+1/a^2*log(a*x+b)],
			 10 : [x^2/(a*x+b)^2,(a*x+b)/a^3-b^2/(a^3*(a*x+b))-((2*b)/a^3)*log(a*x+b)],
			 11 : [x^3/(a*x+b)^2,(a*x+b)^2/(2*a^4)-(3*b*(a*x+b))/a^4+b^3/(a^4*(a*x+b))+(3*b^2/a^4)*log(a*x+b)],
			 12 : [1/(x*(a*x+b)^2),(1/(b*(a*x+b))+(1/b^2)*log(x/(a*x+b)))],
			 13 : [1/(x^2*(a*x+b)^2),(-a/(b^2*(a*x+b)))-(1/(b^2*x))+((2*a)/b^3)*log((a*x+b)/x)],
			 14 : [1/(x^3*(a*x+b)^2),-(a*x+b)^2/(2*b^4*x^2)+(3*a*(a*x+b))/(b^4*x)-(a^3*x)/(b^4*(a*x+b))-((3*a^2)/b^4)*log((a*x+b)/x)],
			 15 : [1/(a*x+b)^3,-1/(2*(a*x+b)^2)],
			 16 : [x/(a*x+b)^3,-1/(a^2*(a*x+b))+b/(2*a^2*(a*x+b)^2)],
			 17 : [x^2/(a*x+b)^3,(2*b)/(a^3*(a*x+b))-(b^2)/(2*a^3*(a*x+b)^2)+1/a^3*log(a*x+b)],
			 18 : [x^3/(a*x+b)^3,(x/a^3)-(3*b^2)/(a^4*(a*x+b))+b^3/(2*a^4*(a*x+b)^2)-(3*b)/a^4*log(a*x+b)],
			 19 : [1/(x*(a*x+b)^3),(a^2*x^2)/(2*b^3*(a*x+b)^2)-(2*a*x)/(b^3*(a*x+b))-(1/b^3)*log((a*x+b)/x)],
			 20 : [1/(x^2*(a*x+b)^3),-a/(2*b^2*(a*x+b)^2)-(2*a)/(b^3*(a*x+b))-1/(b^3*x)+((3*a)/b^4)*log((a*x+b)/x)],
			 21 : [1/(x^3*(a*x+b)^3),-1/(2*b*x^2*(a*x+b)^2)+(2*a)/(b^2*x*(a*x+b)^2)+(9*a^2)/(b^3*(a*x+b)^2)+(6*a^3*x)/(b^4*(a*x+b)^2)+(-6*a^2)/b^5*log((a*x+b)/x)],
			 22 : [(a*x+b)^n,(a*x+b)^(n+1)/((n+1)*a)],
			 23 : [x*(a*x+b)^n,((a*x+b)^(n+2))/((n+2)*a^2)-(b*(a*x+b)^(n+1))/((n+1)*a^2)],
			 24 : [x^2*(a*x+b)^n,(a*x+b)^(n+3)/((n+3)*a^3)-(2*b*(a*x+b)^(n+2))/((n+2)*a^3)+(b^2*(a*x+b)^(n+1))/((n+1)*a^3)],
			 25 : [x^m*(a*x+b)^n,0]
			}

# Check to see if test passed and print result.
def test_eval(test, test_int, desired_result):
	try:
		test_cmp = (desired_result.simplify_full()-test_int.simplify_full()).simplify_full()
	except:
		print "Test", test,": Test failed. Unable to compare results."
		return
	if (test_cmp == 0):
		print "Test", test,": Test Passed."
	else: 
		print "Test", test," Difference in Results:", test_cmp
		# If the difference is constant, the result is valid within a constant of integration.
		if (test_cmp.diff(x) == 0):
			print "Correct within a constant of integration."
			print "Test Passed."
		else:
			div_cmp = (desired_result.simplify_full()/test_int.simplify_full()).simplify_full()
			if (div_cmp.diff(x) == 0):
				print "Division of Results:", div_cmp
				print "Correct within a constant multiple."
			else:
				print "Test Failed."

# Time integration of Maxima and FriCAS for integral.
def time_Maxima_friCAS(integrand):
	mx_time = timeit.eval('integrand.integrate(x)')
	fCAS_time= timeit.eval('axiom.integrate(integrand,x)')
	print "Maxima Time:", mx_time.stats[3], mx_time.stats[4]
	print "FriCAS Time:", fCAS_time.stats[3], fCAS_time.stats[4]


# Loop over tests
for test in int_table.keys():
	test_set = int_table[test]
	integrand = test_set[0]
	desired_result = test_set[1]
	try:
		test_int = integrand.integrate(x)
	except:
 		print "Test", test,": Test failed due to exception."
	else:
		test_eval(test,test_int,desired_result)
		time_Maxima_friCAS(integrand)
