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
# 14.182-14.209
 
# Original Inspiration for this from:
# http://axiom-developer.org/axiom-website/CATS/
#
# Thanks to Tim Daly.

# Define the necessary variables
var('x,a,b,n,m,p,q')

# Define the table of integral tests. Format is test #, [integrand,desired result]
int_table = { 'Schaum 14.182' : [1/(sqrt(x^2+a^2)),log(x+sqrt(x^2+a^2))],
			  'Schaum 14.183' : [x/(sqrt(x^2+a^2)),sqrt(x^2+a^2)],
			  'Schaum 14.184' : [x^2/sqrt(x^2+a^2),(x*sqrt(x^2+a^2))/2-a^2/2*log(x+sqrt(x^2+a^2))],
			  'Schaum 14.185' : [x^3/sqrt(x^2+a^2),(x^2+a^2)^(3/2)/3-a^2*sqrt(x^2+a^2)],
			  'Schaum 14.186' : [1/(x*sqrt(x^2+a^2)),-1/a*log((a+sqrt(x^2+a^2))/x)],
			  'Schaum 14.187' : [1/(x^2*sqrt(x^2+a^2)),-sqrt(x^2+a^2)/(a^2*x)],
			  'Schaum 14.188' : [1/(x^3*sqrt(x^2+a^2)),-sqrt(x^2+a^2)/(2*a^2*x^2)+1/(2*a^3)*log((a+sqrt(x^2+a^2))/x)],
			  'Schaum 14.189' : [sqrt(x^2+a^2),(x*sqrt(x^2+a^2))/2+a^2/2*log(x+sqrt(x^2+a^2))],
			  'Schaum 14.190' : [x*sqrt(x^2+a^2),(x^2+a^2)^(3/2)/3],
			  'Schaum 14.191' : [x^2*sqrt(x^2+a^2),(x*(x^2+a^2)^(3/2))/4-(a^2*x*sqrt(x^2+a^2))/8-a^4/8*log(x+sqrt(x^2+a^2))],
			  'Schaum 14.192' : [x^3*sqrt(x^2+a^2),(x^2+a^2)^(5/2)/5-(a^2*(x^2+a^2)^(3/2))/3],
			  'Schaum 14.193' : [sqrt(x^2+a^2)/x,sqrt(x^2+a^2)-a*log((a+sqrt(x^2+a^2))/x)],
			  'Schaum 14.194' : [sqrt(x^2+a^2)/x^2,-sqrt(x^2+a^2)/x+log(x+sqrt(x^2+a^2))],
			  'Schaum 14.195' : [sqrt(x^2+a^2)/x^3,-sqrt(x^2+a^2)/(2*x^2)-1/(2*a)*log((a+sqrt(x^2+a^2))/x)],
			  'Schaum 14.196' : [1/(x^2+a^2)^(3/2),x/(a^2*sqrt(x^2+a^2))],
			  'Schaum 14.197' : [x/(x^2+a^2)^(3/2),-1/sqrt(x^2+a^2)],
			  'Schaum 14.198' : [x^2/(x^2+a^2)^(3/2),-x/sqrt(x^2+a^2)+log(x+sqrt(x^2+a^2))],
			  'Schaum 14.199' : [x^3/(x^2+a^2)^(3/2),sqrt(x^2+a^2)+a^2/sqrt(x^2+a^2)],
			  'Schaum 14.200' : [1/(x*(x^2+a^2)^(3/2)),1/(a^2*sqrt(x^2+a^2))-1/a^3*log((a+sqrt(x^2+a^2))/x)],
			  'Schaum 14.201' : [1/(x^2*(x^2+a^2)^(3/2)),-sqrt(x^2+a^2)/(a^4*x)-x/(a^4*sqrt(x^2+a^2))],
			  'Schaum 14.202' : [1/(x^3*(x^2+a^2)^(3/2)),-1/(2*a^2*x^2*sqrt(x^2+a^2))-3/(2*a^4*sqrt(x^2+a^2))+3/(2*a^5)*log((a+sqrt(x^2+a^2))/x)],
			  'Schaum 14.203' : [(x^2+a^2)^(3/2),(x*(x^2+a^2)^(3/2))/4+(3*a^2*x*sqrt(x^2+a^2))/8+3/8*a^4*log(x+sqrt(x^2+a^2))],
			  'Schaum 14.204' : [x*(x^2+a^2)^(3/2),(x^2+a^2)^(5/2)/5],
			  'Schaum 14.205' : [x^2*(x^2+a^2)^(3/2),(x*(x^2+a^2)^(5/2))/6-(a^2*x*(x^2+a^2)^(3/2))/24-(a^4*x*sqrt(x^2+a^2))/16-a^6/16*log(x+sqrt(x^2+a^2))],
			  'Schaum 14.206' : [x^3*(x^2+a^2)^(3/2),(x^2+a^2)^(7/2)/7-(a^2*(x^2+a^2)^(5/2))/5],
			  'Schaum 14.207' : [(x^2+a^2)^(3/2)/x,(x^2+a^2)^(3/2)/3+a^2*sqrt(x^2+a^2)-a^3*log((a+sqrt(x^2+a^2))/x)],
			  'Schaum 14.208' : [(x^2+a^2)^(3/2)/x^2,-(x^2+a^2)^(3/2)/x+(3*x*sqrt(x^2+a^2))/2+3/2*a^2*log(x+sqrt(x^2+a^2))],
			  'Schaum 14.209' : [(x^2+a^2)^(3/2)/x^3,-(x^2+a^2)^(3/2)/(2*x^2)+3/2*sqrt(x^2+a^2)-3/2*a*log((a+sqrt(x^2+a^2))/x)]
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
