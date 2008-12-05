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
# 14.325-14.338
 
# Original Inspiration for this from:
# http://axiom-developer.org/axiom-website/CATS/
#
# Thanks to Tim Daly.

# Define the necessary variables
var('x,a,b,n,m,c,r,p')

#
# Define the table of integral tests. Format is test #, [integrand,desired result]
int_table = { 'Schaum 14.325' : [1/(x*(x^n+a^n)),1/(n*a^n)*log(x^n/(x^n+a^n))],
			  'Schaum 14.326' : [x^(n-1)/(x^n+a^n),1/n*log(x^n+a^n)],
			  'Schaum 14.327' : [x^m/(x^n+a^n)^r,0],
			  'Schaum 14.328' : [1/(x^m*(x^n+a^n)^r),0],
			  'Schaum 14.329' : [1/(x*sqrt(x^n+a^n)),1/(n*sqrt(a^n))*log((sqrt(x^n+a^n)-sqrt(a^n))/(sqrt(x^n+a^n)+sqrt(a^n)))],
			  'Schaum 14.330' : [1/(x*(x^n-a^n)),1/(n*a^n)*log((x^n-a^n)/x^n)],
			  'Schaum 14.331' : [x^(n-1)/(x^n-a^n),1/n*log(x^n-a^n)],
			  'Schaum 14.332' : [x^m/(x^n-a^n)^r,0],
			  'Schaum 14.333' : [1/(x^m*(x^n-a^n)^r),0],
			  'Schaum 14.334' : [1/(x*sqrt(x^n-a^n)),2/(n*sqrt(a^n))*acos(sqrt(a^n/x^n))],
			  'Schaum 14.335' : [x^(p-1)/(x^(2*m)+a^(2*m)),0],
			  'Schaum 14.336' : [x^(p-1)/(x^(2*m)-a^(2*m)),0],
			  'Schaum 14.337' : [x^(p-1)/(x^(2*m+1)+a^(2*m+1)),0],
			  'Schaum 14.338' : [x^(p-1)/(x^(2*m+1)-a^(2*m+1)),0]
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
