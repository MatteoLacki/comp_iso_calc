import IsoSpecPy as iso
import numpy as np
from math import log, pi, exp, sqrt
import matplotlib.pyplot as plt
from scipy.stats import chi2
from scipy.special import gamma, gammaincinv



from IsoSpecPy.PeriodicTbl import symbol_to_masses, symbol_to_probs
import re

def parse(formula):
	symbols = re.findall("\D+", formula)
	atom_counts = [int(x) for x in re.findall("\d+", formula)]
	return zip(symbols, atom_counts)

# formula = "Sn10"
# M, P = list(zip(*iso.IsoThresholdGenerator(formula=formula, threshold=.001)))
# P = sorted(P, reverse=True)
# P = np.array(P)


def totProb2density(P, probs):
	"""Get the density threshold for the given total probability within an ellipse.

	Args:
		P (iterable): thresholds to get the intensity for.
	"""
	k = len(probs) - 1
	omega2 = get_the_square_radius(P, k)
	return np.exp( -omega2/2.0 -.5*(k*log(2*pi) + sum(np.log(el_probs)) + log(k)) )	


# formula = "C100090H200000"
def totProb2density(P, formula):
	K = 0
	C = 0.0
	log2pi = log(2*pi)
	for el, atom_cnt in parse(formula):
		probs = np.array(symbol_to_probs[el])
		probs = probs[probs > 0]
		k = len(probs)
		C -= 0.5 * ( sum(np.log(probs)) + log(k+1) + k*log2pi + k*log(atom_cnt))
		K += k
	omega2 = get_the_square_radius(P, K)
	return np.exp( -omega2/2.0 + C )	

# plt.plot(t, P)
# plt.show()

# element = 'Sn'
# el_probs = np.array(symbol_to_probs[element])
# P = np.linspace(0, 1, 1000)[:-1]
# t = totProb2density(P, el_probs)
# plt.plot(t, P)
# plt.show()

def get_probs(el):
	probs = np.array(symbol_to_probs[el])
	return probs[probs > 0]

def log_subiso_cnt_proxy(formula, P):
	K = 0
	for el,_ in parse(formula):
		p = get_probs(el)
		K += len(p) - 1
	# print(K)
	logR2 = log(chi2.ppf(P, df=K))
	# print(logR2)
	res = []
	for el, n in parse(formula):
		p  = get_probs(el)
		k  = len(p) - 1
		# print(k)
		if k > 0:
			o  = sum(log(1+(i/n)) for i in range(1,k+1))
			# print(sum(log(1+(i/n)) for i in range(1,k+1)))
			o += k/2 * (logR2 + log(2) + log(pi) + log(n))
			# print(k/2 * (logR2 + log(2) + log(pi) + log(n)))
			o -= log(gamma(k/2 + 1))
			# print(log(gamma(k/2 + 1)))
			o += sum(np.log(p)) / 2
			# print(sum(np.log(p)) / 2)
			res.append(exp(o))
			# print(exp(o))
		else:
			res.append(1)
	return np.array(res)

def get_real_confs(formula, P):
	confs = [set() for el, atom_cnt in parse(formula) ]
	for _, _, C in iso.IsoLayered(formula=formula, prob_to_cover=P, get_confs = True):
		for i, x in enumerate(C):
			confs[i].add(x)
	return np.array([len(c) for c in confs])

P = .99

# formula = "C1000H2000N40S100"
formula = "C1000H2000N40S1P1000000"
formula = "C1000H1000"

m = log_subiso_cnt_proxy(formula, P)
w = get_real_confs(formula, P)

pint("Ratios")
print("True")
print(w / sum(w))
print("Proxy")
print(m / sum(m))

print("Absolutes")
print("True")
print(w)
print("Proxy")
print(m)

sum(w)/sum(m)



# m[0]/m[1]
# m


# from scipy.special import gammainc, gamma, gammaincinv

# P = np.array([.2, .5, .7])
# chi2.ppf(P, df=10)

# k = 2


# gammainc(k/2, .99) * gamma(k/2)
# gammaincinv(k/2, .99)







