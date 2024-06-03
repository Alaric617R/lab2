# Modify starting here
#####

TESTBENCH = mult_test.sv
SIMFILES = mult_stage.sv pipe_mult.sv
SYNFILES = two_bit_pred.vg

#####
# Should be no need to modify after here
#####
simv:   $(SIMFILES) $(TESTBENCH)
	$(VCS) $(TESTBENCH) $(SIMFILES) -o simv

novas.rc: initialnovas.rc
	sed s/UNIQNAME/$$USER/ initialnovas.rc > novas.rc


syn_simv:       $(SYNFILES) $(TESTBENCH)
	$(VCS) $(TESTBENCH) $(SYNFILES) $(LIB) -o syn_simv

syn:    syn_simv
	./syn_simv | tee syn_program.out

clean:
	rm -rvf simv* *.daidir csrc vcs.key program.out \
	syn_simv syn_simv.daidir syn_program.out \
	dve *.vpd *.vcd *.dump ucli.key \
	DVEfiles/ verdi* novas* *fsdb*

nuke:   clean
	rm -rvf *.vg *.rep *.db *.chk *.log *.out