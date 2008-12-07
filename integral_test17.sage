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
# 14.339-14.368
 
# Original Inspiration for this from:
# http://axiom-developer.org/axiom-website/CATS/
#
# Thanks to Tim Daly.

# Define the necessary variables
var('x,a,b,n,m,c,r,p,q')

# Need to include 14.346 answer
# Define the table of integral tests. Format is test #, [integrand,desired result]
int_table = { 'Schaum 14.339' : [sin(a*x),-cos(a*x)/a],
			  'Schaum 14.340' : [x*sin(a*x),sin(a*x)/a^2-(x*cos(a*x))/a],
			  'Schaum 14.341' : [x^2*sin(a*x),(2*x)/a^2*sin(a*x)+(2/a^3-x^2/a)*cos(a*x)],
			  'Schaum 14.342' : [x^3*sin(a*x),((3*x^2)/a^2-6/a^4)*sin(a*x)+(6*x/a^3-x^3/a)*cos(a*x)],
			  'Schaum 14.343' : [sin(x)/x,0],
			  'Schaum 14.344' : [sin(a*x)/x^2,0],
			  'Schaum 14.345' : [1/sin(a*x),1/a*log(tan((a*x)/2))],
			  'Schaum 14.346' : [x/sin(a*x),0],
			  'Schaum 14.347' : [sin(a*x)^2,x/2-sin(2*a*x)/(4*a)],
			  'Schaum 14.348' : [x*sin(a*x)^2,x^2/4-(x*sin(2*a*x))/(4*a)-cos(2*a*x)/(8*a^2)],
			  'Schaum 14.349' : [sin(a*x)^3,-cos(a*x)/a+cos(a*x)^3/(3*a)],
			  'Schaum 14.350' : [sin(a*x)^4,(3*x)/8-sin(2*a*x)/(4*a)+sin(4*a*x)/(32*a)],
			  'Schaum 14.351' : [1/sin(a*x)^2,-1/a*cot(a*x)],
			  'Schaum 14.352' : [1/sin(a*x)^3,-cos(a*x)/(2*a*sin(a*x)^2)+1/(2*a)*log(tan((a*x)/2))],
			  'Schaum 14.353' : [sin(p*x)*sin(q*x),sin((p-q)*x)/(2*(p-q))-sin((p+q)*x)/(2*(p+q))],
			  'Schaum 14.354' : [1/(1-sin(a*x)),1/a*tan(pi/4+(a*x)/2)],
			  'Schaum 14.355' : [x/(1-sin(a*x)),x/a*tan(pi/4+(a*x)/2)+2/a^2*log(sin(pi/4-(a*x)/2))],
			  'Schaum 14.356' : [1/(1+sin(a*x)),-1/a*tan(pi/4-(a*x)/2)],
			  'Schaum 14.357' : [x/(1+sin(a*x)),-x/a*tan(pi/4-(a*x)/2)+2/a^2*log(sin(pi/4+(a*x)/2))],
			  'Schaum 14.358' : [1/(1-sin(a*x))^2,1/(2*a)*tan(pi/4+(a*x)/2)+1/(6*a)*tan(pi/4+(a*x)/2)^3],
			  'Schaum 14.359' : [1/(1+sin(a*x))^2,-1/(2*a)*tan(pi/4-(a*x)/2)-1/(6*a)*tan(pi/4-(a*x)/2)^3],
			  'Schaum 14.360' : [1/(p+q*sin(a*x)),0],
			  'Schaum 14.361' : [1/(p+q*sin(a*x))^2,0],
			  'Schaum 14.362' : [1/(p^2+q^2*sin(a*x)^2),1/(a*p*sqrt(p^2+q^2))*atan((sqrt(p^2+q^2)*tan(a*x))/p)],
			  'Schaum 14.363' : [1/(p^2-q^2*sin(a*x)^2),0],
			  'Schaum 14.364' : [x^m*sin(a*x),0],
			  'Schaum 14.365' : [sin(a*x)/x^n,0],
			  'Schaum 14.366' : [sin(a*x)^n,0],
			  'Schaum 14.367' : [1/(sin(a*x))^n,0],
			  'Schaum 14.368' : [x/sin(a*x)^n,0]
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
