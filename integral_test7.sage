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
# 14.144-14.162
 
# Original Inspiration for this from:
# http://axiom-developer.org/axiom-website/CATS/
#
# Thanks to Tim Daly.

# Define the necessary variables
var('x,a,b,n,m,p,q')

# Define the table of integral tests. Format is test #, [integrand,desired result]
int_table = { 'Schaum 14.144' : [1/(x^2-a^2),1/(2*a)*log((x-a)/(x+a))],
			  'Schaum 14.145' : [x/(x^2-a^2),1/2*log(x^2-a^2)],
			  'Schaum 14.146' : [x^2/(x^2-a^2),x+a/2*log((x-a)/(x+a))],
			  'Schaum 14.147' : [x^3/(x^2-a^2),x^2/2+a^2/2*log(x^2-a^2)],
			  'Schaum 14.148' : [1/(x*(x^2-a^2)),1/(2*a^2)*log((x^2-a^2)/x^2)],
			  'Schaum 14.149' : [1/(x^2*(x^2-a^2)),1/(a^2*x)+1/(2*a^3)*log((x-a)/(x+a))],
			  'Schaum 14.150' : [1/(x^3*(x^2-a^2)),1/(2*a^2*x^2)-1/(2*a^4)*log(x^2/(x^2-a^2))],
			  'Schaum 14.151' : [1/((x^2-a^2)^2),-x/(2*a^2*(x^2-a^2))-1/(4*a^3)*log((x-a)/(x+a))],
			  'Schaum 14.152' : [x/((x^2-a^2)^2),-1/(2*(x^2-a^2))],
			  'Schaum 14.153' : [x^2/((x^2-a^2)^2),-x/(2*(x^2-a^2))+1/(4*a)*log((x-a)/(x+a))],
			  'Schaum 14.154' : [x^3/((x^2-a^2)^2),-a^2/(2*(x^2-a^2))+1/2*log(x^2-a^2)],
			  'Schaum 14.155' : [1/(x*(x^2-a^2)^2),-1/(2*a^2*(x^2-a^2))+1/(2*a^4)*log(x^2/(x^2-a^2))],
			  'Schaum 14.156' : [1/(x^2*(x^2-a^2)^2),-1/(a^4*x)-x/(2*a^4*(x^2-a^2))-3/(4*a^5)*log((x-a)/(x+a))],
			  'Schaum 14.157' : [1/(x^3*(x^2-a^2)^2),-1/(2*a^4*x^2)-1/(2*a^4*(x^2-a^2))+1/a^6*log(x^2/(x^2-a^2))],
			  'Schaum 14.158' : [1/((x^2-a^2)^n),0],
			  'Schaum 14.159' : [x/((x^2-a^2)^n),-1/(2*(n-1)*(x^2-a^2)^(n-1))],
			  'Schaum 14.160' : [1/(x*(x^2-a^2)^n),0],
			  'Schaum 14.161' : [x^m/((x^2-a^2)^n),0],
			  'Schaum 14.162' : [1/(x^m*(x^2-a^2)^n),0]
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
