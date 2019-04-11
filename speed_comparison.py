from furious_fastas.fastas import Fastas
from pathlib import Path
import json
from time import time
import numpy as np

from aa2atom import aa2atom, atom2str
import IsoSpecPy as iso


human = Fastas()
ff = Path('~/Projects/furious_fastas/fastas/20180913_up_human_reviewed_20394entries.fasta').expanduser()
human.read(ff)

# subs = [atom2str(aa2atom(str(h))) for h in human]
# of = Path('~/Projects/isospec/tests/formulas.json').expanduser()
# with open(of, 'w') as f:
# 	json.dump(subs, f, indent=2)

thr = .0001

# h = human[0]
# for h in human:
formula = atom2str(aa2atom(str(h)))

def test_isospec_threshold_(formula, thr):
	t0 = time()
	res = iso.IsoThreshold( formula=formula, 
			     			threshold=thr,
				 			get_confs=True  )
	t1 = time()
	return t1 - t0

def test_isospec_threshold(formula, thr, times):
	res = np.array([test_isospec_threshold_(formula, thr)
		     		 for _ in range(times)])
	return np.median(res)

formula = 'C4500H7530N1370O1210S80'
test_isospec_threshold(formula, thr, 100)

0.0002028942108154297 * 1e9
353238 
407579


