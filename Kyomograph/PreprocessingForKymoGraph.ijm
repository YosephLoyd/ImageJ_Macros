//Author: YML, Krendel Lab
//Date: 20251107
//Macro: This function is designed to find edges of cells in 2D and 
//map pixel space in spherical coordinates. Using an Otsu masking of 
//the cell body is done automatically, the object is then filled, and
//mapped to spherical coodinates. Edges are found using the find edges
//Then expanded by 11.5 pixels by convolution of using a 23x23 ones
//matrix on the edge mask. After which a final product of the cell images
//is organized as a 3 channel images that corresponds to ch1 = intensity,
//ch2 = radians (-pi:pi), and ch3 = Distance (inital units of image pixels).

//Get image name
first_image=getTitle();

//Duplicate and threshold using Outsu method
run("Duplicate...", "title=Mask duplicate");
setOption("ScaleConversions", true);
run("Auto Threshold", "method=Otsu white stack");

//Generate the initial mask using the Otsu threshold
setOption("BlackBackground", false);
run("Convert to Mask", "calculate create");

//Dusting opperation for small bits of moise in the image smaller than 51 pixels
rename("Mask2");
run("Analyze Particles...", "size=50-Infinity clear add stack");

//Fill operation for the cell body in the image
run("Fill Holes", "stack");

//Calculating theta and displacement for pixels in the cell body
run("Duplicate...", "title=Distance duplicate");
run("32-bit");
run("Duplicate...", "title=radians duplicate");
run("32-bit");
roiManager("Measure");

getPixelSize(unit, pw, ph, pd);
Length=getValue("results.count")

for (ic=0;ic<=Length-1;ic++){
	XC=getResult("X",ic);
	YC=getResult("Y",ic);
	Xloc=(XC/pw)-1;
	Yloc=(YC/ph)-1;
	selectImage("Distance");
	setSlice(ic+1);
	run("Macro...", "code=[v= (v/255)* sqrt( ((x-"+Xloc+") * (x-"+Xloc+") )+( (y-"+Yloc+") * (y-"+Yloc+") ))] slice");
	run("Macro...", "code=[v= (v* "+pw+")] slice");
	selectImage("radians");
	setSlice(ic+1);
	run("Macro...", "code=[ (atan2( (y-"+Yloc+"),(x-"+Xloc+") ) * (180/PI) )+180] ");
}

//Set image bacground to "not a number"
selectImage("Distance");
run("Multiply...", 1);
selectImage("Distance");
setThreshold(0.0100, 1000000000000000000000000000000.0000);
run("NaN Background", "stack");
resetMinAndMax;

selectImage("Mask2");
run("Subtract...", "value=254 stack");
run("32-bit");
resetMinAndMax;
setThreshold(0.0039, 1000000000000000000000000000000.0000);
run("NaN Background", "stack");

selectImage("radians");
setMinAndMax(0,360);

imageCalculator("multiply create 32-bit stack", "radians","Mask2");
selectImage("Result of radians");
selectImage("radians");
close();
selectImage("Result of radians");
rename("radians")

//Perserve ROI stats
IJ.renameResults("Results","ROI_Stats");

//Pick the larghest cell in the image using a CC approach and make a new mask
selectImage("Mask");
run("Find Connected Regions", "allow_diagonal display_one_image display_results regions_for_values_over=100 minimum_number_of_points=1 stop_after=-1");
RC=getValue("results.count");
RA=newArray(RC);

for (iR=0;iR<=RC-1;iR++){
	RA[iR]=getResult("Points In Region",iR);
}
Array.getStatistics(RA, min, max, mean, stdDev);
for (iR=0;iR<=RC-1;iR++){
		if (RA[iR]==max){
		Dusting=iR+1;
	}
}
rename("Dusted_Image_Mask");
run("32-bit");
setThreshold(Dusting-0.01, Dusting+0.01);
run("NaN Background", "stack");

selectImage("Dusted_Image_Mask");
setMinAndMax(0, 1);
run("8-bit");
run("Convert to Mask", "background=Dark calculate");
run("Fill Holes", "stack");
run("Divide...", "value=255.0000000 stack");
setMinAndMax(0, 1);
run("32-bit");
setThreshold(0.9, 1.1);
run("NaN Background", "stack");

//apply the new single cell mask to the distance and theta images
imageCalculator("multiply create 32-bit stack", "Distance","Dusted_Image_Mask");
selectImage("Result of Distance");
rename("Dusted_Distance");

selectImage("radians")
imageCalculator("multiply create 32-bit stack", "radians","Dusted_Image_Mask");
selectImage("Result of radians");
rename("Dusted_radians");


//Find edges of the masked cell and expand by convolving edge mask a 23x23 ones matrix.
//Overlaying this mask on the dusted mask with perserve the mask and pixels within 11 pixels of the edge.
selectImage("Dusted_Image_Mask");
run("Duplicate...", "title=Edges duplicate");
run("Multiply...", "value=255 stack");
run("8-bit");
run("Find Edges", "stack");
run("Duplicate...", "title=Expansion_Kernel duplicate");
selectImage("Expansion_Kernel");
run("Convolve...", "text1=[1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1\n] stack");	
run("Subtract...", "value=254 stack");
run("32-bit");
resetMinAndMax;
setThreshold(0.0039, 1000000000000000000000000000000.0000);
run("NaN Background", "stack");

//Apply edges mask on intensity, distance, and theta mask
selectImage("Expansion_Kernel")
imageCalculator("multiply create 32-bit stack", "Dusted_radians","Expansion_Kernel");
selectImage("Result of Dusted_radians");
rename("Edges_radians");

selectImage("Expansion_Kernel")
imageCalculator("multiply create 32-bit stack", "Dusted_Distance","Expansion_Kernel");
selectImage("Result of Dusted_Distance");
rename("Edges_Distance");

selectImage("Expansion_Kernel")
imageCalculator("multiply create 32-bit stack", "Dusted_Image_Mask","Expansion_Kernel");
selectImage("Result of Dusted_Image_Mask");
rename("Edges_Mask");

selectImage("Expansion_Kernel")
imageCalculator("multiply create 32-bit stack", first_image,"Edges_Mask");
selectImage("Result of "+first_image);
rename("Edges_Intensity");

//Perserve CC stats
IJ.renameResults("Results","Connected_Components_Stats");
run("Merge Channels...", "c5=[Edges_Intensity] c6=[Edges_radians] c7=[Edges_Distance] create");

//Merge the resulting edge masked images of Intensity, distance, and theta
name=split(first_image,".");
Dialog.create("What is this sample's name?");
Dialog.addString("Sample Name:", name[0]);
Dialog.show();
Idenity=Dialog.getString();

rename(Idenity+"Edges_Intensity_Radians_Distance");