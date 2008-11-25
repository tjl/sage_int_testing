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
# 14.84-14.104 (excluding 14.88,14.92 since it is difficult to compare results)
# 14.98 same as 14.97.

# Original Inspiration for this from:
# http://axiom-developer.org/axiom-website/CATS/
#
# Thanks to Tim Daly.

# Define the necessary variables
var('x,a,b,n,m')

# Define the table of integral tests. Format is test #, [integrand,desired result]
# Note that: 
# Test 7 fails on both Axiom and Maxima. May be a typo in Schaum's. This is the belief
# of Tim Daly (Axiom Developer).
# Tests 8 and 9 results are problematic to present in this table.
# Tests 10, 11, 12, 16, 17, and 18 are returned unevaluated.
int_table = { 1 : [1/sqrt(a*x+b),(2*sqrt(a*x+b))/a],
			  2 : [x/sqrt(a*x+b),(2*(a*x-2*b))/(3*a^2)*sqrt(a*x+b)],
			  3 : [x^2/sqrt(a*x+b),(2*(3*a^2*x^2-4*a*b*x+8*b^2))/(15*a^3)*sqrt(a*x+b)],
			  4 : [1/(x*sqrt(a*x+b)),1/sqrt(b)*log((sqrt(a*x+b)-sqrt(b))/(sqrt(a*x+b)+sqrt(b)))],
			  5 : [sqrt(a*x+b),(2*sqrt((a*x+b)^3))/(3*a)],
			  6 : [x*sqrt(a*x+b),(2*(3*a*x-2*b))/(15*a^2)*sqrt((a*x+b)^3)],
			  7 : [x^2*sqrt(a*x+b),(2*(15*a^2*x^2-12*a*b*x+8*b^2))/(105*a^3)*sqrt((a+b*x)^3)],
			  8 : [sqrt(a*x+b)/x,0],
			  9 : [sqrt(a*x+b)/x^2,0],
			 10 : [x^m/sqrt(a*x+b),0],
			 11 : [1/(x^m*sqrt(a*x+b)),0],
			 12 : [sqrt(a*x+b)/x^m,0],
			 13 : [(a*x+b)^(m/2),(2*(a*x+b)^((m+2)/2))/(a*(m+2))],
			 14 : [x*(a*x+b)^(m/2),(2*(a*x+b)^((m+4)/2))/(a^2*(m+4))-(2*b*(a*x+b)^((m+2)/2))/(a^2*(m+2))],
			 15 : [x^2*(a*x+b)^(m/2),(2*(a*x+b)^((m+6)/2))/(a^3*(m+6))-(4*b*(a*x+b)^((m+4)/2))/(a^3*(m+4))+(2*b^2*(a*x+b)^((m+2)/2))/(a^3*(m+2))],
			 16 : [(a*x+b)^(m/2)/x,0],
			 17 : [(a*x+b)^(m/2)/x^2,0],
			 18 : [1/(x*(a*x+b)^(m/2)),0]
			}

# Check to see if test passed and print result.
def test_eval(test, test_int, desired_result):
	try:
		test_cmp = (desired_result.simplify_full()-test_int.simplify_full()).simplify_full()
	except:
		print "Test", test,": Test failed. Unable to compare results."
		print "Calculated Integral: ", test_int
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
				print "Calculated Integral: ", test_int
				print "Comparison Integral: ", desired_result

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
