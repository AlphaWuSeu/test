
Disparity Estimation software using Quaternion Wavelet Transform (QWT)

Written by: William Chan (Rice University)

date created: November 13, 2005
modified on Feb 3, 2008

---------------------------------------------------------
Steps to run program:

1. Please make sure you have added the correct path in Matlab so that your code can 
   access the "standard_QWT" directory (e.g., see line 4 in "test_register_images.m").
2. Run "test_register_images.m" to see estimation result for Rubik's cube
3. Change the first few lines in "test_register_images.m" for results of another 
   image sequence. May need to adjust initialization parameters for different image sequences.

---------------------------------------------------------

Matlab Files:

pick_images.m - read and resize images for qwt estimation algorithm

read_sequence.m - read image sequences from /jbarron folder

test_register_images.m - test file for register_images.m

register_images.m (main disparity estimation function)
- the following files are used in register_images.m
{
	collect_phase_data.m - collect phases from QWT coefficients 
	estimate_local_freq_4.m - step 1 in registration (estimate effective spectral center)
	estimate_disparity_4.m - step 2 (estimate disparities, unwrap phase, 
				 combine subband/scale)
	wrap_quaternion_phase.m - unwrap the first two quaternion phase angles together
	interp_dmap.m - bilinearly interpolate estimation map 
	combine_result_3.m - final combination of all estimate results to create 
			     one disparity map
}

read_correct_flows.m - read correct flow maps from /jbarron folder
resize_correct_flows.m - resize correct flow maps to the size of estimated map 
			 (for easier comparison)
calculate_error_flows.m - calculate error flows given correct and estimated flows
eval_flow.m - calculate and display angular errors

----------------------------------------------------------

Other folders:
standard_QWT - code for QWT 
jbarron - image sequences for testing purposes

----------------------------------------------------------

Details about the disparity estimation algorithm:
(see my thesis/journal paper)

- for usage of register_images.m, see test_register_images.m

Figure 1: Disparity estimate for a chosen scale (with QWT magnitudes, 
          reliability maps) for all three subbands
	  Remark: Can use this diagram to observe scale estimates and adjust 
	  magnitude threshold and reliability threshold)
	  [see "register_images.m"] (need to first uncomment part of the code) 
Figure 2: Estimated disparity flows [see "combine_result_3.m"]
Figure 3: Estimated disparity flows (overlaid on reference image) 
	    [see "combine_result_3.m"]
Figure 4: Reference and target images (A and B) [see "test_register_images.m"]
Figure 5: Correct disparity flows (if available) [see "test_register_images.m"]
Figure 6: Error of disparity estimates (overlaid on reference image)
	  (if correct flows available) [see "test_register_images.m"]

- several parameters to adjust for better performance:
	- magnitude threshold (in estimate_disparity_3.m)
	- reliability threshold (in estimate_disparity_3.m)
	- outliars threshold (in combine_result_3.m)

Remark: Unreliable estimates can attribute to small QWT coefficients, 
zero-divide-by-zero in phase calculation, and occasional incorrect phase unwraps

- In this algorithm, we may observe unsatisfactory estimations near:
	- boundary areas (program artificially add boundaries to make image dyadic,
	  see test_register_images.m)
	- smooth areas (though interpolated, unreliable estimates can still cause errors)
	- if underlying disparity not smooth (e.g. near image boundaries, or 
	  cloud region in yosemite sequence)
- Remedy by getting rid of out-liars (estimates with too big magnitudes; see combine_result_3.m) 