Author: Marco Pirini
July 7th, 2009
(Please see Readme.doc for a nicer formatted version of this text file)

Basics:

-	the model has been created in a Matlab-Simulink environment;
-       the model has been divided in 3, functionally non re-entrant,
        modules: the STNGPE one, the GPi one and the Thalamic one
        (possibility to re-use some simulation results from the
        upstream modules without the need to re-simulate the entire
        model ? reduced computation time & more control).
-	The flow to simulate is:

1 launch launch_sysGPESTN1.m

o       upload IC, parameters, additional currents, DBS currents if
        needed, etc.
o       launch the STNGPE module (GPESTN1.mdl - in this .mdl you will
        see the architecture used by Rubin and Terman as arised from a
        private communication with them) o save results in a .mat file
        for the STNGPE simulation;

ALTERNATIVELY:

1 launch launch_sysGPESTN1_GPEDBS.m to simulate DBS on GPe target if
        needed. The steps performed by this script are the same as by
        launch_sysGPESTN1.m. Remember: when asked, choose the
        GPESTN1_GPEDBS.mdl.
2 launch launch_sysGPI_mod.m
o       upload IC, parameters, additional currents, DBS currents if
        needed, etc
o	launch the  GPI module (GPI1.mdl)
o	save results in a .mat file for the GPI simulation;

3 launch launch_sysTAL_mod.m

o       upload IC, parameters, additional currents, the cortical
        input, etc
o	launch the  TAL module (TAL8.mdl)
o       analyze the results (thalamic spike sorting and
        classification)
o	save results in a .mat file for the TAL simulation;

Alternatively, 

o       once simulated all the possible (of interest) sets of
        parameters and conditions for the SNTGPe and the GPi modules
        (different conditions (norm, park, DBS on the 3 targets),
        different values of the ggpe-->gpi conductance, different
        values of the Istriatum-->Gpi, different DBS frequencies...)

it`s possible to perform in a single step the simulation of the final
thalamic module for all of the set of parameters (and for several
realisations of the cortical input sequence to thalamus). You could do
this by launching CN_launch_CN_analyze_TAL2.m that , in turn, recalls
CN_analyze_tal2.m.

-	Other files

o       data_STN.m, data_GPe.m, data_GPi.m, data_TAL.m,
        data_synapses.m: sets of parameters for populations and
        synapses;
o	in_val.mat: some sets of Initial conditions;
o	sp_rev_thresh.m: thalamic spikes identification
o	spike_contr.m: thalamic spike classification
o       CN_calculate_sm.m: scripts that calculate a Poisson
        realization of the cortical input sequence to thalamus.
