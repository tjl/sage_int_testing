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
# 14.105-14.112
 
# Original Inspiration for this from:
# http://axiom-developer.org/axiom-website/CATS/
#
# Thanks to Tim Daly.

# Define the necessary variables
var('x,a,b,n,m,p,q')

# Define the table of integral tests. Format is test #, [integrand,desired result]
int_table = { 1 : [1/((a*x+b)*(p*x+q)),1/(b*p-a*q)*log((p*x+q)/(a*x+b))],
			  2 : [x/((a*x+b)*(p*x+q)),1/(b*p-a*q)*(b/a*log(a*x+b)-q/p*log(p*x+q))],
			  3 : [1/((a*x+b)^2*(p*x+q)),1/(b*p-a*q)*(1/(a*x+b)+p/(b*p-a*q)*log((p*x+q)/(a*x+b)))],
			  4 : [x/((a*x+b)^2*(p*x+q)),1/(b*p-a*q)*(q/(b*p-a*q)*log((a*x+b)/(p*x+q))-b/(a*(a*x+b)))],
			  5 : [x^2/((a*x+b)^2*(p*x+q)),b^2/((b*p-a*q)*a^2*(a*x+b))+1/(b*p-a*q)^2*(q^2/p*log(p*x+q)+((b*(b*p-2*a*q))/a^2)*log(a*x+b))],
			  6 : [1/((a*x+b)^m*(p*x+q)^n),0],
			  7 : [(a*x+b)/(p*x+q),(a*x)/p+(b*p-a*q)/p^2*log(p*x+q)],
			  8 : [(a*x+b)^m/(p*x+q)^n,0]
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
