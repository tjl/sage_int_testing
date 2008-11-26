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
# 14.210-14.236
 
# Original Inspiration for this from:
# http://axiom-developer.org/axiom-website/CATS/
#
# Thanks to Tim Daly.

# Define the necessary variables
var('x,a,b,n,m,p,q')

# Define the table of integral tests. Format is test #, [integrand,desired result]
int_table = { 'Schaum 14.210' : [1/(sqrt(x^2-a^2)),log(x+sqrt(x^2-a^2))],
			  'Schaum 14.xxx' : [x/(sqrt(x^2-a^2)),sqrt(x^2-a^2)],
			  'Schaum 14.211' : [x^2/sqrt(x^2-a^2),(x*sqrt(x^2-a^2))/2+a^2/2*log(x+sqrt(x^2-a^2))],
			  'Schaum 14.212' : [x^3/sqrt(x^2-a^2),(x^2-a^2)^(3/2)/3+a^2*sqrt(x^2-a^2)],
			  'Schaum 14.213' : [1/(x*sqrt(x^2-a^2)),1/a*asec(x/a)],
			  'Schaum 14.214' : [1/(x^2*sqrt(x^2-a^2)),sqrt(x^2-a^2)/(a^2*x)],
			  'Schaum 14.215' : [1/(x^3*sqrt(x^2-a^2)),sqrt(x^2-a^2)/(2*a^2*x^2)+1/(2*a^3)*asec(x/a)],
			  'Schaum 14.216' : [sqrt(x^2-a^2),(x*sqrt(x^2-a^2))/2-a^2/2*log(x+sqrt(x^2-a^2))],
			  'Schaum 14.217' : [x*sqrt(x^2-a^2),(x^2-a^2)^(3/2)/3],
			  'Schaum 14.218' : [x^2*sqrt(x^2-a^2),(x*(x^2-a^2)^(3/2))/4+(a^2*x*sqrt(x^2-a^2))/8-a^4/8*log(x+sqrt(x^2-a^2))],
			  'Schaum 14.219' : [x^3*sqrt(x^2-a^2),(x^2-a^2)^(5/2)/5+(a^2*(x^2-a^2)^(3/2))/3],
			  'Schaum 14.220' : [sqrt(x^2-a^2)/x,sqrt(x^2-a^2)-a*asec(x/a)],
			  'Schaum 14.221' : [sqrt(x^2-a^2)/x^2,-sqrt(x^2-a^2)/x+log(x+sqrt(x^2-a^2))],
			  'Schaum 14.222' : [sqrt(x^2-a^2)/x^3,-sqrt(x^2-a^2)/(2*x^2)+1/(2*a)*asec(x/a)],
			  'Schaum 14.223' : [1/(x^2-a^2)^(3/2),-x/(a^2*sqrt(x^2-a^2))],
			  'Schaum 14.224' : [x/(x^2-a^2)^(3/2),-1/sqrt(x^2-a^2)],
			  'Schaum 14.225' : [x^2/(x^2-a^2)^(3/2),-x/sqrt(x^2-a^2)+log(x+sqrt(x^2-a^2))],
			  'Schaum 14.226' : [x^3/(x^2-a^2)^(3/2),sqrt(x^2-a^2)-a^2/sqrt(x^2-a^2)],
			  'Schaum 14.227' : [1/(x*(x^2-a^2)^(3/2)),-1/(a^2*sqrt(x^2-a^2))-1/a^3*asec(x/a)],
			  'Schaum 14.228' : [1/(x^2*(x^2-a^2)^(3/2)),-sqrt(x^2-a^2)/(a^4*x)-x/(a^4*sqrt(x^2-a^2))],
			  'Schaum 14.229' : [1/(x^3*(x^2-a^2)^(3/2)),1/(2*a^2*x^2*sqrt(x^2-a^2))-3/(2*a^4*sqrt(x^2-a^2))-3/(2*a^5)*asec(x/a)],
			  'Schaum 14.230' : [(x^2-a^2)^(3/2),(x*(x^2-a^2)^(3/2))/4-(3*a^2*x*sqrt(x^2-a^2))/8+3/8*a^4*log(x+sqrt(x^2-a^2))],
			  'Schaum 14.231' : [x*(x^2-a^2)^(3/2),(x^2-a^2)^(5/2)/5],
			  'Schaum 14.232' : [x^2*(x^2-a^2)^(3/2),(x*(x^2-a^2)^(5/2))/6+(a^2*x*(x^2-a^2)^(3/2))/24-(a^4*x*sqrt(x^2-a^2))/16+a^6/16*log(x+sqrt(x^2-a^2))],
			  'Schaum 14.233' : [x^3*(x^2-a^2)^(3/2),(x^2-a^2)^(7/2)/7+(a^2*(x^2-a^2)^(5/2))/5],
			  'Schaum 14.234' : [(x^2-a^2)^(3/2)/x,(x^2-a^2)^(3/2)/3-a^2*sqrt(x^2-a^2)+a^3*asec(x/a)],
			  'Schaum 14.235' : [(x^2-a^2)^(3/2)/x^2,-(x^2-a^2)^(3/2)/x+3*x*sqrt(x^2-a^2)/2-3/2*a^2*log(x+sqrt(x^2-a^2))],
			  'Schaum 14.236' : [(x^2-a^2)^(3/2)/x^3,-(x^2-a^2)^(3/2)/(2*x^2)+(3*sqrt(x^2-a^2))/2-3/2*a*asec(x/a)]			
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
